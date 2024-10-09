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
        self.beginPoint = CGPointZero;
        self.endPoint = CGPointZero;
        self.lineColor = [UIColor orangeColor];
        self.lineWidth = 1;
    }
    return self;
}

- (void)setBeginPoint:(CGPoint)beginPoint{
    _beginPoint = beginPoint;
    [self setNeedsDisplay];
}
-(void)setEndPoint:(CGPoint)endPoint{
    _endPoint = endPoint;
    [self setNeedsDisplay];
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
    
    CGPoint tempBeginPoint = self.beginPoint;
    CGPoint tempEndPoint = self.endPoint;
    if (CGPointEqualToPoint(self.beginPoint, CGPointZero) &&
        CGPointEqualToPoint(self.endPoint, CGPointZero)) {
        
        tempBeginPoint = CGPointMake(0, layerHeight);
        tempEndPoint = CGPointMake(layerWidth, 0);
    }
    
    
    //起始点， 左下角是坐标原点
    [bezierPath moveToPoint:tempBeginPoint];
    
    if (self.isCubeCurve) {
        //三次贝塞尔曲线   Point表示结束的点  controlPoint控制的点
        [bezierPath addCurveToPoint:tempEndPoint controlPoint1:_firstPoint controlPoint2:_secondPoint];
    }else{
        //二次贝塞尔曲线   Point表示结束的点
        [bezierPath addQuadCurveToPoint:tempEndPoint controlPoint:_firstPoint];
    }
    
    CGContextAddPath(ctx, bezierPath.CGPath);
    
    //虚线
    if (self.isDash) {
        CGFloat dash[] = {4};
        CGContextSetLineDash(ctx, 0, dash, 1);//count 表示dash里面的个数
    }
    
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextStrokePath(ctx);
    
}

/**
 
//矩形，并填弃渐变颜色
     //关于颜色参考http://blog.sina.com.cn/s/blog_6ec3c9ce01015v3c.html
     //http://blog.csdn.net/reylen/article/details/8622932
 
     //第一种填充方式，第一种方式必须导入类库quartcore并#import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
     CAGradientLayer *gradient1 = [CAGradientLayer layer];
     gradient1.frame = CGRectMake(240, 120, 60, 30);
     gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                         (id)[UIColor grayColor].CGColor,
                         (id)[UIColor blackColor].CGColor,
                         (id)[UIColor yellowColor].CGColor,
                         (id)[UIColor blueColor].CGColor,
                         (id)[UIColor redColor].CGColor,
                         (id)[UIColor greenColor].CGColor,
                         (id)[UIColor orangeColor].CGColor,
                         (id)[UIColor brownColor].CGColor,nil];
     [self.layer insertSublayer:gradient1 atIndex:0];
 
     //第二种填充方式
     CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
     CGFloat colors[] =
     {
         1,1,1, 1.00,
         1,1,0, 1.00,
         1,0,0, 1.00,
         1,0,1, 1.00,
         0,1,1, 1.00,
         0,1,0, 1.00,
         0,0,1, 1.00,
         0,0,0, 1.00,
     };
     CGGradientRef gradient = CGGradientCreateWithColorComponents
     (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
     CGColorSpaceRelease(rgb);
 
 
 
 
 0 CGContextRef context = UIGraphicsGetCurrentContext(); 设置上下文
 1 CGContextMoveToPoint 开始画线
 2 CGContextAddLineToPoint 画直线
 4 CGContextAddEllipseInRect 画一椭圆
 4 CGContextSetLineCap 设置线条终点形状
 4 CGContextSetLineDash 画虚线
 4 CGContextAddRect 画一方框
 4 CGContextStrokeRect 指定矩形
 4 CGContextStrokeRectWithWidth 指定矩形线宽度
 4 CGContextStrokeLineSegments 一些直线
 5 CGContextAddArc 画已曲线 前俩店为中心 中间俩店为起始弧度 最后一数据为0则顺时针画 1则逆时针
 5 CGContextAddArcToPoint(context,0,0, 2, 9, 40);//先画俩条线从point 到 弟1点 ， 从弟1点到弟2点的线 切割里面的圆
 6 CGContextSetShadowWithColor 设置阴影

 7 CGContextSetRGBFillColor 这只填充颜色
 7 CGContextSetRGBStrokeColor 画笔颜色设置
 7 CGContextSetFillColorSpace 颜色空间填充
 7 CGConextSetStrokeColorSpace 颜色空间画笔设置
 8 CGContextFillRect 补充当前填充颜色的rect
 8 CGContextSetAlaha 透明度
 9 CGContextTranslateCTM 改变画布位置
 10 CGContextSetLineWidth 设置线的宽度
 11 CGContextAddRects 画多个线
 12 CGContextAddQuadCurveToPoint 画曲线
 13 CGContextStrokePath 开始绘制图片
 13 CGContextDrawPath 设置绘制模式
 14 CGContextClosePath 封闭当前线路
 15 CGContextTranslateCTM(context, 0, rect.size.height); CGContextScaleCTM(context, 1.0, -1.0);反转画布
 16 CGContextSetInterpolationQuality 背景内置颜色质量等级
 16 CGImageCreateWithImageInRect 从原图片中取小图
 17 字符串的 写入可用 nsstring本身的画图方法 - (CGSize)drawInRect:(CGRect)rect withFont:(UIFont )font lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;来写进去即可
 18对图片放大缩小的功能就是慢了点 UIGraphicsBeginImageContext(newSize); UIImage newImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
 19 CGColorGetComponents（） 返回颜色的各个直 以及透明度 可用只读const float 来接收 是个数组
 
 */

@end
