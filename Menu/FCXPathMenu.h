//
//  FCXPathMenu.h
//  Menu
//
//  Created by 冯 传祥 on 15/9/4.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MenuClickBlock)(NSInteger buttonIndex);

@interface FCXPathMenu : UIView

@property (nonatomic, strong) UIButton *mainButton;
@property (nonatomic, assign, getter=isExpanding) BOOL expanding;
@property (nonatomic, copy) MenuClickBlock menuClickBlock;


- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                   menusArray:(NSArray *)menusArray;

@end
