//
//  LJBezierLayer.m
//  LJAnimation
//
//  Created by LiJie on 16/7/21.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJBezierLayer.h"

@interface LJBezierLayer ()



@end

@implementation LJBezierLayer

-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(void)setFirstPoint:(CGPoint)firstPoint{
    
    _firstPoint=firstPoint;
    [self setNeedsDisplay];
}

-(void)setSecondPoint:(CGPoint)secondPoint{
    
    _secondPoint=secondPoint;
    [self setNeedsDisplay];
}

-(void)setIsCubeCurve:(BOOL)isCubeCurve{
    
    _isCubeCurve=isCubeCurve;
    [self setNeedsDisplay];
}

-(void)drawInContext:(CGContextRef)ctx{
    
    CGFloat layerHeight=self.bounds.size.height;
    CGFloat layerWidth=self.bounds.size.width;
    
    UIBezierPath* bezierPath=[UIBezierPath bezierPath];
    
    //起始点， 左下角是坐标原点
    [bezierPath moveToPoint:CGPointMake(0, layerHeight)];
    
    if (self.isCubeCurve) {
        //三次贝塞尔曲线   Point表示结束的点  controlPoint控制的点
        [bezierPath addCurveToPoint:CGPointMake(layerWidth, 0) controlPoint1:_firstPoint controlPoint2:_secondPoint];
    }else{
        //二次贝塞尔曲线   Point表示结束的点
        [bezierPath addQuadCurveToPoint:CGPointMake(layerWidth, 0) controlPoint:_firstPoint];
    }
    
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextStrokePath(ctx);
    
}

@end
