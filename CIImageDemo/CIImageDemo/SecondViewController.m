//
//  SecondViewController.m
//  CIImageDemo
//
//  Created by LiJie on 2017/3/4.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<CALayerDelegate>

@property(nonatomic, strong)CALayer* theLayer;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setLayerContents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addFilter];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.theLayer.delegate = nil;
}

-(void)setLayerContents{
    
    //1 设置contents属性
    self.theLayer=[CALayer layer];
    self.theLayer.position=self.view.center;
    self.theLayer.backgroundColor = [UIColor orangeColor].CGColor;
    self.theLayer.bounds=CGRectMake(0.0f,0.0f,300.0f, 300.0f);
    self.theLayer.masksToBounds = YES;
    self.theLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"world.jpg"].CGImage);
    //self.theLayer.contents = [UIImage imageNamed:@"head.jpg"]; //这个就不起作用
    self.theLayer.contentsGravity = kCAGravityResizeAspect;
    //self.theLayer.contentsGravity = kCAGravityBottomLeft; //这个的上下正好也iOS的坐标系相反
    [self.view.layer addSublayer:self.theLayer];
    
    
    //2 通过委托 供内容 displayLayer:或 drawLayer:inContext:
    self.theLayer.delegate = self;
    
    //3 通过子类 供图层的内容, 见LJLayer类
}

-(void)addFilter{
    CIFilter* filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setDefaults];
    [filter setValue:@(150.0) forKey:@"inputRadius"];
    [filter setName:@"pulseFilter"];
    
    [self.theLayer setFilters:@[filter]];
    
    CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
    pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
    pulseAnimation.fromValue= @(0.0);
    pulseAnimation.toValue = @(1.5);
    pulseAnimation.duration = 1.0;
    pulseAnimation.repeatCount = HUGE_VALF;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.theLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}

- (IBAction)click:(UIButton *)sender {
    //设置 needDisplay 后，才会走 代理方法
    [self.theLayer setNeedsDisplay];
    //[self.theLayer setNeedsDisplayOnBoundsChange:YES];  则会自动刷新图层
    //[self.theLayer displayIfNeeded];//这个 方法不行。
}

#pragma mark - ================ LayerDelegate ==================
- (void)displayLayer:(CALayer *)layer{
    //简单的加载图片
    if ([[layer valueForKey:@"state"] boolValue]) {
        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"head.jpg"].CGImage);
    }else{
        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"button"].CGImage);
    }
    [layer setValue:@(![[layer valueForKey:@"state"] boolValue]) forKey:@"state"];
}

/**  重绘图层内容 , 如果实现了 displayLayer，就不会再走这个方法了*/
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, 15.0f, 15.0f);
    CGPathAddCurveToPoint(thePath,
                          NULL,
                          15.0f, 60.0f,
                          60.0f, 60.0f,
                          80, 20);
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, thePath);
    CGContextSetLineWidth(ctx, 8);
    CGContextStrokePath(ctx);
    CFRelease(thePath);
}

-(void)layerWillDraw:(CALayer *)layer{
    
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    
}


-(id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event{
    
    return nil;
}



@end
