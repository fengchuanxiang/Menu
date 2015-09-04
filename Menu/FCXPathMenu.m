//
//  FCXPathMenu.m
//  Menu
//
//  Created by 冯 传祥 on 15/9/4.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "FCXPathMenu.h"
#import "FCXPathButtonItem.h"

//paht展开动画时，远点、近点、终点的展开半径
static CGFloat const kFarRadius = 140.0f;
static CGFloat const kNearRadius = 110.0f;
static CGFloat const kEndRadius = 120.0f;


@interface FCXPathMenu ()

@property (nonatomic, strong) UIView *pathSuperView;
@property (nonatomic, strong) NSArray *menusArray;


@end

@implementation FCXPathMenu


- (instancetype)initWithFrame:(CGRect)frame
                    superView:(UIView *)superView
                   menusArray:(NSArray *)menusArray {

    if (self = [super initWithFrame:frame]) {
        _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mainButton setBackgroundImage:[UIImage imageNamed:@"PathMain"] forState:UIControlStateNormal];
        _mainButton.frame = frame;
        [_mainButton addTarget:self action:@selector(mainButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.pathSuperView = superView;
        
        self.menusArray = menusArray;

        [superView addSubview:_mainButton];
    }
    
    return self;
}

- (void)setMenusArray:(NSArray *)menusArray {

    if (_menusArray != menusArray) {
        _menusArray = nil;
        _menusArray = [menusArray copy];
        
        for (FCXPathButtonItem *item  in _menusArray) {
            [item addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
            item.frame = _mainButton.frame;
            item.startPoint = _mainButton.center;
            item.farPoint = CGPointMake(_mainButton.center.x + kFarRadius * cos(item.expandAngle), _mainButton.center.y - kFarRadius * sin(item.expandAngle));
            item.nearPoint = CGPointMake(_mainButton.center.x + kNearRadius * cos(item.expandAngle), _mainButton.center.y - kNearRadius * sin(item.expandAngle));
            item.endPoint = CGPointMake(_mainButton.center.x + kEndRadius * cos(item.expandAngle), _mainButton.center.y - kEndRadius * sin(item.expandAngle));
            
            [self.pathSuperView addSubview:item];
        }
    }
}

- (void)menuAction:(UIButton *)button {

    if (self.menuClickBlock) {
        self.menuClickBlock(button.tag);
    }
    
    //有动画效果
    [self mainButtonAction];
    
    //点击菜单进入新界面不要动画时
//    [self hideMenus];
}

- (void)hideMenus {

    self.mainButton.transform = CGAffineTransformMakeRotation(0);
    for (FCXPathButtonItem *item in self.menusArray) {
        item.center = _mainButton.center;
    }
}

-(void)mainButtonAction {
    
    if (self.isExpanding) {
        [self shrink];
    }else{
        [self expand];
    }
    
    self.expanding = !self.expanding;
    
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        _mainButton.transform = CGAffineTransformMakeRotation(angle);
    }];
}

-(void)expand
{
    for (FCXPathButtonItem *item in self.menusArray) {
        [self expand:item scale:1];
    }
}

-(void)expand:(FCXPathButtonItem *)button scale:(CGFloat)scale {
    
    //系统原因，在7.0的系统第二次会动画会闪退
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.duration = 0.5f;
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:.3],
                                    [NSNumber numberWithFloat:.4], nil];
        
        CAKeyframeAnimation *zoomScale = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        zoomScale.duration = .5f;
        zoomScale.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)]];
        zoomScale.keyTimes = [NSArray arrayWithObjects:
                              //                                [NSNumber numberWithFloat:.5],
                              [NSNumber numberWithFloat:.3], nil];
        zoomScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, button.startPoint.x, button.startPoint.y);
        CGPathAddLineToPoint(path, NULL, button.farPoint.x, button.farPoint.y);
        CGPathAddLineToPoint(path, NULL, button.nearPoint.x, button.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, button.endPoint.x, button.endPoint.y);     positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, zoomScale, rotateAnimation, nil];
        animationgroup.duration = .5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [button.layer addAnimation:animationgroup forKey:@"Expand"];
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 72 * scale, 72 * scale);
        button.center = button.endPoint;
    }else{
        [UIView animateWithDuration:.3 animations:^{
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 72 * scale, 72 * scale);
            button.center = button.endPoint;
        }];
    }
}


-(void)shrink {
    
    for (FCXPathButtonItem *item in self.menusArray) {
        [self shrink:item scale:.8];
    }
}

-(void)shrink:(FCXPathButtonItem *)button scale:(CGFloat)scale {
    
    //系统原因，在7.0的系统第二次会动画会闪退
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
        rotateAnimation.duration = 0.5f;
        rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:.0],
                                    [NSNumber numberWithFloat:.4],
                                    [NSNumber numberWithFloat:.5], nil];
        
        CAKeyframeAnimation *zoomScale = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        zoomScale.duration = .5f;
        zoomScale.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)]];
        zoomScale.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:.4],
                              [NSNumber numberWithFloat:.5], nil];
        zoomScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, button.endPoint.x, button.endPoint.y);
        CGPathAddLineToPoint(path, NULL, button.farPoint.x, button.farPoint.y);
        CGPathAddLineToPoint(path, NULL, button.startPoint.x, button.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, zoomScale, rotateAnimation, nil];
        animationgroup.duration = .5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [button.layer addAnimation:animationgroup forKey:@"Shrink"];
        button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 72 * scale, 72 * scale);
        button.center = button.startPoint;
    }else{
        [UIView animateWithDuration:.3 animations:^{
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 72 * scale, 72 * scale);
            button.center = button.startPoint;
        }];
    }
}


@end
