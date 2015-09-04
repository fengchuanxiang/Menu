//
//  FCXPathButtonItem.h
//  Menu
//
//  Created by 冯 传祥 on 15/9/4.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCXPathButtonItem : UIButton


//展开时的角度
@property (nonatomic, unsafe_unretained) double expandAngle;

//paht展开动画时，按照开始点、远点、近点、终点的顺序进行
@property (nonatomic, unsafe_unretained) CGPoint startPoint;
@property (nonatomic, unsafe_unretained) CGPoint farPoint;
@property (nonatomic, unsafe_unretained) CGPoint nearPoint;
@property (nonatomic, unsafe_unretained) CGPoint endPoint;


@end
