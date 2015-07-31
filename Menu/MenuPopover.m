//
//  MenuPopover.m
//  Menu
//
//  Created by fcx on 15/7/31.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "MenuPopover.h"

@implementation MenuPopover
{
    UIImageView *menuImageView;
}



- (instancetype)initWithMenuFrame:(CGRect)frame menuClickBlock:(MenuClickBlock)menuClickBlock {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        self.menuClickBlock = menuClickBlock;
        menuImageView = [[UIImageView alloc] initWithFrame:frame];
        menuImageView.image = [UIImage imageNamed:@"menu"];
        menuImageView.userInteractionEnabled = YES;
        menuImageView.layer.anchorPoint = CGPointMake(1, 0);
        menuImageView.frame = frame;
        [self addSubview:menuImageView];
        
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topButton.frame = CGRectMake(0, 8.5, 100, 43.5);
        topButton.tag = 0;
        [topButton setTitle:@"menu1" forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuImageView addSubview:topButton];
        
        UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomButton.frame = CGRectMake(0, 8.5 + 43.5, 100, 43.5);
        bottomButton.tag = 1;
        [bottomButton setTitle:@"menu2" forState:UIControlStateNormal];
        [bottomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuImageView addSubview:bottomButton];
        
        UITapGestureRecognizer *tapGesgure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGesgure];
        
    }
    return self;
}


- (void)buttonAction:(UIButton *)button {
    
    [self dismiss];
    if (self.menuClickBlock) {
        self.menuClickBlock(button.tag);
    }
    
}

- (void)show {
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    __weak UIImageView *weakImageView = menuImageView;
    
    menuImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss {
    
    __weak __typeof(self)weakSelf = self;
    __weak UIImageView *weakImageView = menuImageView;
    
    [UIView animateWithDuration:.15 animations:^{
        
        weakImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
    
}



@end
