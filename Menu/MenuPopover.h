//
//  MenuPopover.h
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  点击菜单回调block
 *
 *  @param buttonIndex 点击按钮的位置
 */
typedef void (^MenuClickBlock)(NSInteger buttonIndex);


@interface MenuPopover : UIView


@property (nonatomic, copy) MenuClickBlock menuClickBlock;

- (instancetype)initWithMenuFrame:(CGRect)frame menuClickBlock:(MenuClickBlock)menuClickBlock;

- (void)show;


@end
