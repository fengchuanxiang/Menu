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
    UIButton *lastSelectedButton;//最后一次选中的按钮
    NSInteger finallPage;//最后要滚动到的页（为了防止有多页时，在两个不相邻页面切换时，会调用多次setCurrentSelectedIndex方法，有多个动画效果）
    BOOL isDragged;//滚动是否是有手动拖拽引起的
}
@property (nonatomic, strong)UIView *bottomLineView;
@property(nonatomic, unsafe_unretained, readwrite) NSInteger numberOfPages;//!< default is 0
@property(nonatomic, unsafe_unretained) NSInteger currentSelectedIndex;//!< default is 0.

@end

@implementation MenuScrollView


- (void)dealloc {
    [_dataScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame dataScrollView:(UIScrollView *)scrollView {

    if (self = [super initWithFrame:frame]) {
        self.dataScrollView = scrollView;
        self.bottomLineHeight = 1;
        self.bottomLineIndentation = 10;
        self.bottomLineHeight = 2;
        self.bottomLineColor = [UIColor redColor];
        self.titleColorNormal = [UIColor blackColor];
        self.titleColorSelected = [UIColor redColor];
        pageWidth = frame.size.width;
        finallPage = 0;
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


/**
 *  加这个属性是为了外部设置currentPage时有动画效果，会与现有的动画冲突
 *
 *  @param currentSelectedIndex 当前选中位置
 */
- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    
    if (_currentSelectedIndex != currentSelectedIndex && currentSelectedIndex == finallPage) {
        
        _currentSelectedIndex = currentSelectedIndex;
        _currentPage = currentSelectedIndex;
        
        UIButton *btn = (UIButton *)[self viewWithTag:currentSelectedIndex + 100];
        lastSelectedButton.selected = NO;
        lastSelectedButton = btn;
        lastSelectedButton.selected = YES;
        
        if (self.clickPageBlock) {
            self.clickPageBlock(currentSelectedIndex);
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {

    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        finallPage = currentPage;
        isDragged = NO;
        
        [self changeBottomLineViewFrame:YES];
        if (self.clickPageBlock) {
            self.clickPageBlock(currentPage);
        }
    }
}

- (BOOL)shouldShowAnimationWithPage:(NSInteger)page {

    return YES;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;
        
        pageWidth = self.frame.size.width/numberOfPages;
        [self changeBottomLineViewFrame:NO];
    }
    
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal titleColorSelected:(UIColor *)titleColorSelected {
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:titleColorNormal forState:UIControlStateNormal];
            [btn setTitleColor:titleColorSelected forState:UIControlStateSelected];
            [btn setTitleColor:titleColorSelected forState:UIControlStateHighlighted];
        }
    }
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    
    if (_titleColorNormal != titleColorNormal) {
        _titleColorNormal = titleColorNormal;
        for (UIButton *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setTitleColor:titleColorNormal forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    
    if (_titleColorSelected != titleColorSelected) {
        _titleColorSelected = titleColorSelected;
        for (UIButton *btn in self.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setTitleColor:titleColorSelected forState:UIControlStateSelected];
                [btn setTitleColor:titleColorSelected forState:UIControlStateHighlighted];
            }
        }
    }
    
}


- (void)setTitleArray:(NSArray *)titleArray {

    __weak __typeof(self)weakSelf = self;
    self.numberOfPages = titleArray.count;
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx + 100;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColorSelected forState:UIControlStateSelected];
        [btn setTitleColor:self.titleColorSelected forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(idx * pageWidth, 0, pageWidth, self.frame.size.height);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:weakSelf action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf addSubview:btn];

    }];
}

- (void)buttonAction:(UIButton *)button {
    
    if (lastSelectedButton != button) {
        
        lastSelectedButton.selected = NO;
        lastSelectedButton = button;
        lastSelectedButton.selected = YES;
        
        //为了防止有多页时，在两个不相邻页面切换时，会调用多次setCurrentSelectedIndex方法，有多个动画效果
        finallPage = button.tag - 100;
        isDragged = NO;
        
        if (self.clickPageBlock) {
            self.clickPageBlock(button.tag);
        }
        [self.dataScrollView scrollRectToVisible:CGRectMake((button.tag - 100) * _dataScrollView.frame.size.width, _dataScrollView.frame.origin.y, _dataScrollView.frame.size.width, _dataScrollView.frame.size.height) animated:YES];
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
        
        if (_dataScrollView.isDragging) {//说明手动拖拽，不是间隔页面
            isDragged = YES;
        }
        
        NSInteger page = (_dataScrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width/2.0)/[UIScreen mainScreen].bounds.size.width;
        if (isDragged) {
            finallPage = page;
        }
        
        self.bottomLineView.frame = CGRectMake(_dataScrollView.contentOffset.x/_numberOfPages + _bottomLineIndentation, self.frame.size.height - _bottomLineHeight, pageWidth - 2 * _bottomLineIndentation, _bottomLineHeight);
        self.currentSelectedIndex = page;
    }
}

@end
