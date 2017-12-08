//
//  LJLayer.m
//  CIImageDemo
//
//  Created by LiJie on 2017/3/4.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "LJLayer.h"
#import <UIKit/UIKit.h>

@implementation LJLayer


/**  
 实现重绘方法并不意味重绘会自动发生。
 你必须显式的 促使实例重新缓存其内容，
 可以通过发送以下任何一个方法 
 setNeedsDisplay 或 setNeedsDisplayInRect:的消息，
 亦或者设置图层的 needsDisplaOnBoundsChange 属性 为 YES */
-(void)drawInContext:(CGContextRef)theContext{
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,15.0f,15.f);
    CGPathAddCurveToPoint(thePath,
                          NULL,
                          15.f,250.0f,
                          295.0f,250.0f,
                          295.0f,15.0f);
    CGContextBeginPath(theContext);
    CGContextAddPath(theContext, thePath );
    CGContextSetLineWidth(theContext, 10);
    CGContextSetStrokeColorWithColor(theContext, [UIColor orangeColor].CGColor);
    CGContextStrokePath(theContext);
    
    CGPathRelease(thePath);
}

@end
