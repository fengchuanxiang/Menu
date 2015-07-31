//
//  MenuScrollView.m
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "MenuScrollView.h"

@interface MenuScrollView ()
{
    CGFloat pageWidth;
}
@property (nonatomic, strong)UIView *bottomLineView;
@property(nonatomic, unsafe_unretained, readwrite) NSInteger numberOfPages;//!< default is 0

@end

@implementation MenuScrollView
{
    NSInteger lastPage;
}

- (instancetype)initWithFrame:(CGRect)frame dataScrollView:(UIScrollView *)scrollView {

    if (self = [super initWithFrame:frame]) {
        self.dataScrollView = scrollView;
        self.bottomLineHeight = 1;
        pageWidth = frame.size.width;
    }
    
    return self;
}

- (instancetype)initWithDataScrollView:(UIScrollView *)scrollView {

    return [self initWithFrame:CGRectZero dataScrollView:scrollView];
}


- (UIView *)bottomLineView {

    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    self.bottomLineView.backgroundColor = bottomLineColor;
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    
    if (_bottomLineHeight != bottomLineHeight) {
        _bottomLineHeight = bottomLineHeight;
        [self changeBottomLineViewFrame:NO];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {

    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        [self changeBottomLineViewFrame:YES];
        if (self.clickPageBlock) {
            self.clickPageBlock(currentPage);
        }
    }

}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        
        pageWidth = self.frame.size.width/numberOfPages;
        [self changeBottomLineViewFrame:NO];
    }
    
}

- (void)setTitleColor:(UIColor *)titleColor {

    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        for (UIButton *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setTitleArray:(NSArray *)titleArray {

    __weak __typeof(self)weakSelf = self;
    self.numberOfPages = titleArray.count;
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        [btn setTitleColor:weakSelf.titleColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(idx * pageWidth, 0, pageWidth, self.frame.size.height);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:weakSelf action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf addSubview:btn];

    }];
}

- (void)buttonAction:(UIButton *)button {
    
    if (_currentPage != button.tag) {
        if (self.clickPageBlock) {
            self.clickPageBlock(button.tag);
        }
        [self.dataScrollView scrollRectToVisible:CGRectMake(button.tag * _dataScrollView.frame.size.width, _dataScrollView.frame.origin.y, _dataScrollView.frame.size.width, _dataScrollView.frame.size.height) animated:YES];
    }
}

- (void)changeBottomLineViewFrame:(BOOL)animated {

    if (animated) {
        
        __weak __typeof(self)weakSelf = self;
        UIView *weakView = self.bottomLineView;
        [UIView animateWithDuration:.15 animations:^{
            weakView.frame = CGRectMake(_currentPage * pageWidth + _bottomLineIndentation, weakSelf.frame.size.height - _bottomLineHeight, pageWidth - 2 * _bottomLineIndentation, _bottomLineHeight);
        }];
        
    }else {

        self.bottomLineView.frame = CGRectMake(_currentPage * pageWidth + _bottomLineIndentation, self.frame.size.height - _bottomLineHeight, pageWidth - 2 * _bottomLineIndentation, _bottomLineHeight);
    }
}

- (void)setDataScrollView:(UIScrollView *)dataScrollView {

    if (_dataScrollView != dataScrollView) {
        // 移除之前的监听器
        if (_dataScrollView) {
            [_dataScrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        }
        
        _dataScrollView = dataScrollView;
        // 监听contentOffset
        [_dataScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSInteger page = _dataScrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        self.currentPage = page;
    }
}

@end
