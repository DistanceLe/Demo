//
//  LJRefreshView.m
//  LJRefresh
//
//  Created by LiJie on 16/8/22.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJRefreshView.h"
#import "CurveLayer.h"

@interface LJRefreshView ()

@property (nonatomic,strong)CurveLayer *curveLayer;
@property (nonatomic, strong)NSString* friend;

@end

@implementation LJRefreshView

-(CurveLayer *)curveLayer{
    if (!_curveLayer) {
        _curveLayer=[CurveLayer layer];
        _curveLayer.frame=self.bounds;
        _curveLayer.contentsScale=[UIScreen mainScreen].scale;
        _curveLayer.progress=0.0f;
        _curveLayer.curveColor=[UIColor orangeColor];
        [_curveLayer setNeedsDisplay];
        [self.layer addSublayer:_curveLayer];
    }
    return _curveLayer;
}

-(void)setRefreshProgress:(CGFloat)refreshProgress{
    _refreshProgress=refreshProgress;
//    self.alpha=refreshProgress;
    self.curveLayer.progress=refreshProgress;
    [self.curveLayer setNeedsDisplay];
}

-(void)refresh{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.curveLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)endRefresh{
    [self.curveLayer removeAllAnimations];
}





















@end
