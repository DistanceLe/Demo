//
//  PushTransition.h
//  LJAnimation
//
//  Created by LiJie on 16/7/14.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LJTransitionCompress = 1,   //压缩，扩展
    LJTransitionPush,           //推，有一些缩放效果
    LJTransitionCurve,          //圆圈扩张
} LJTransitionType;

@interface PushTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign)LJTransitionType transitionType;

+(instancetype)defaultTransitionIsPush:(BOOL)push;



@end
