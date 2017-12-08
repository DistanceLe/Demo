//
//  TestView.m
//  LJAnimation
//
//  Created by LiJie on 16/7/13.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "TestView.h"

#define EXTRAAREA 50

@implementation TestView

-(void)drawRect:(CGRect)rect{
    
    
    [[UIColor redColor]set];
    
    //圆弧线
    UIBezierPath* apath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:50 startAngle:0 endAngle:M_PI clockwise:YES];
    
    //矩形
    apath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 30, 100, 100) cornerRadius:0];
    
    //椭圆，园
    apath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(30, 30, 150, 100)];
    
    //矩形，指定那个圆角
    apath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 30, 120, 160) byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    
    
    apath.lineWidth=5.0;
    apath.lineCapStyle=kCGLineCapRound;//线条拐角
    apath.lineJoinStyle=kCGLineJoinRound;//终点处理
    [apath stroke];
//    return;
    
    
    
    
    
    
    
    
    
    
    
    if (_diff==5) {
        
        UIGraphicsPushContext(UIGraphicsGetCurrentContext());
        
        UIBezierPath* path=[UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50, 50)];
        [path addLineToPoint:CGPointMake(100, 50)];
        [path addCurveToPoint:CGPointMake(100, 200) controlPoint1:CGPointMake(50, 100) controlPoint2:CGPointMake(200, 178)];
        [path closePath];
        [[[UIColor greenColor]colorWithAlphaComponent:1] set];
        
        [path fill];
        
        UIGraphicsPopContext();
        
        return;
        
        CGContextRef context=UIGraphicsGetCurrentContext();
        CGContextAddPath(context, path.CGPath);
        
        CGContextFillPath(context);
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, 0)];
    
    //绘制三次贝塞尔曲线
    //    [path addCurveToPoint:NULL controlPoint1:NULL controlPoint2:NULL];
    
    //绘制二次贝塞尔曲线
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-EXTRAAREA, self.frame.size.height) controlPoint:CGPointMake(IPHONE_WIDTH/2+_diff, IPHONE_HEIGHT/2)];
    
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    //Sets the fill and stroke colors in the current drawing context
    [[[UIColor orangeColor]colorWithAlphaComponent:1] set];
    [path fill];    //填充内容
//    [path stroke]; //画出边框，
    return;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    
    CGContextFillPath(context);
}

@end
