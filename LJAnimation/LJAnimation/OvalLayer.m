//
//  OvalLayer.m
//  LJAnimation
//
//  Created by LiJie on 16/7/12.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "OvalLayer.h"
@interface OvalLayer ()

@property(nonatomic,assign)CGFloat factor;

@end

@implementation OvalLayer

-(id)init{
    self = [super init];
    if (self) {
        _factor=0.4;
        [self setNeedsDisplay];
    }
    return self;
}

-(CGRect)currentRect{
    if (_currentRect.size.width==0) {
        _currentRect=CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10);
    }
    return _currentRect;
}

-(void)drawInContext:(CGContextRef)ctx{
    
//    CGContextSaveGState(ctx);
//    CGContextRestoreGState(ctx);
    
    CGFloat offset = self.currentRect.size.width / 3.6;  //设置3.6 出来的弧度最像圆形
    
    CGPoint rectCenter = CGPointMake(self.currentRect.origin.x + self.currentRect.size.width/2 , self.currentRect.origin.y + self.currentRect.size.height/2);
    
    //8个控制点实际的偏移距离。 The real distance of 8 control points.
    CGFloat extra = (self.currentRect.size.width * 2 / 5) * _factor;
    extra=0;
    
    
    CGPoint pointA = CGPointMake(rectCenter.x ,self.currentRect.origin.y + extra);
    CGPoint pointB = CGPointMake(rectCenter.x + self.currentRect.size.width/2 ,rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x ,rectCenter.y + self.currentRect.size.height/2 - extra);
    CGPoint pointD = CGPointMake(self.currentRect.origin.x - extra*2, rectCenter.y);
    
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, pointB.y - offset);
    
    CGPoint c3 = CGPointMake(pointB.x, pointB.y + offset);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, pointD.y + offset);
    
    CGPoint c7 = CGPointMake(pointD.x, pointD.y - offset);
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
    UIBezierPath* ovalPath=[UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    UIBezierPath* rectPath=[UIBezierPath bezierPathWithRect:self.currentRect];
    
    
    CGContextAddPath(ctx, rectPath.CGPath);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    [[UIColor orangeColor]set];
    CGContextSetLineWidth(ctx, 5.0);
    CGFloat dash[]={5.0, 5.0};            //{虚线长度， 虚线间隔}
    
    
    CGContextSetLineDash(ctx, 0.0, dash, 2); //count的值等于lengths数组的长度  dash 有两个
                                             //phase参数表示在第一个虚线绘制的时候跳过多少个点
    CGContextStrokePath(ctx);

    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);

}


@end
