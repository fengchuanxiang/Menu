//
//  MenuScrollView.h
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击某一个菜单
 *
 *  @param page 点击的页
 */
typedef void (^ MenuDidClickPageBlock)(NSInteger page);

@interface MenuScrollView : UIScrollView


@property (nonatomic, strong) UIScrollView *dataScrollView;//!< 显示数据源的scrollView
@property(nonatomic, unsafe_unretained, readonly) NSInteger numberOfPages;//!< default is 0
@property(nonatomic, unsafe_unretained) NSInteger currentPage;//!< default is 0. value pinned to 0..numberOfPag
@property (nonatomic, copy) MenuDidClickPageBlock clickPageBlock;
@property (nonatomic, unsafe_unretained) BOOL showBottomLine;
@property (nonatomic, unsafe_unretained) CGFloat bottomLineIndentation;//!< default is 0
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, unsafe_unretained) CGFloat bottomLineHeight;//!< default is 1
@property (nonatomic, strong) UIColor *titleColorNormal;
@property (nonatomic, strong) UIColor *titleColorSelected;

@property (nonatomic, strong) NSArray *titleArray;



- (instancetype)initWithFrame:(CGRect)frame dataScrollView:(UIScrollView *)scrollView;

- (instancetype)initWithDataScrollView:(UIScrollView *)scrollView;

- (void)setTitleColorNormal:(UIColor *)titleColorNormal titleColorSelected:(UIColor *)titleColorSelected;

@end
