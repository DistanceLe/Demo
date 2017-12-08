//
//  PushTransition.m
//  LJAnimation
//
//  Created by LiJie on 16/7/14.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "PushTransition.h"


@interface PushTransition ()<CAAnimationDelegate>

@property(nonatomic, assign)BOOL push;
@property(nonatomic, assign)NSInteger animationCount;
@property(nonatomic, strong)id<UIViewControllerContextTransitioning> transitionContext;
@property(nonatomic, strong)UIViewController* tempToVC;
@property(nonatomic, strong)UIViewController* tempFromVC;

@end


@implementation PushTransition

+(instancetype)defaultTransitionIsPush:(BOOL)push{
    PushTransition* temp=[[PushTransition alloc]init];
    temp.push=push;
    return temp;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 1.0f;
}

-(void)dealloc{
    NSLog(@"*****transiton  dealloc");
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext=transitionContext;
    
    UIViewController* fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC=[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* containerView=[transitionContext containerView];
    _tempToVC=toVC;
    _tempFromVC=fromVC;
    if (_push) {
        [containerView addSubview:fromVC.view];
        [containerView addSubview:toVC.view];
    }else{
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
    }
    
    
    if (self.transitionType==LJTransitionCompress) {
        
        CABasicAnimation* rotationAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        if (_push) {
            rotationAnimation.fromValue=@(M_PI_2);
            rotationAnimation.toValue=@(0);
        }else{
            rotationAnimation.fromValue=@0;
            rotationAnimation.toValue=@(M_PI_2);
        }
        
        CABasicAnimation* opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        if (_push) {
            opacityAnimation.fromValue=@0.1;
            opacityAnimation.toValue=@1;
        }else{
            opacityAnimation.fromValue=@1;
            opacityAnimation.toValue=@0.1;
        }
        
        CAAnimationGroup* groupAnimation=[CAAnimationGroup animation];
        groupAnimation.animations=@[rotationAnimation, opacityAnimation];
        groupAnimation.duration=[self transitionDuration:transitionContext];
        groupAnimation.fillMode=kCAFillModeForwards;
        groupAnimation.removedOnCompletion=NO;
        groupAnimation.delegate=self;
        
        if (_push) {
            toVC.view.layer.zPosition=IPHONE_HEIGHT;
            [toVC.view.layer addAnimation:groupAnimation forKey:@"group"];
        }else{
            fromVC.view.layer.zPosition=IPHONE_HEIGHT;
            [fromVC.view.layer addAnimation:groupAnimation forKey:@"group"];
        }
        
        return;
    }
    
    
    if (_push) {
        UIBezierPath* finalPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake((IPHONE_WIDTH-IPHONE_HEIGHT)*1.5, -IPHONE_HEIGHT*1.5 , IPHONE_HEIGHT*3, IPHONE_HEIGHT*3)];
        UIBezierPath* startPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(IPHONE_WIDTH-50, 0, 50, 50)];
        
        CAShapeLayer* maskLayer=[CAShapeLayer layer];
        maskLayer.path=finalPath.CGPath;
        toVC.view.layer.mask=maskLayer;
        
        CABasicAnimation* pingAnimation=[CABasicAnimation animationWithKeyPath:@"path"];
        pingAnimation.fromValue=(__bridge id)(startPath.CGPath);
        pingAnimation.toValue=(__bridge id)(finalPath.CGPath);
        pingAnimation.duration=[self transitionDuration:transitionContext];
        pingAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pingAnimation.fillMode=kCAFillModeForwards;
        pingAnimation.removedOnCompletion=NO;
        pingAnimation.delegate=self;
        [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
        
    }else{
        
//        UIBezierPath* startPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake((IPHONE_WIDTH-IPHONE_HEIGHT)*1.5, -IPHONE_HEIGHT*1.5 , IPHONE_HEIGHT*3, IPHONE_HEIGHT*3)];
//        UIBezierPath* finalPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(IPHONE_WIDTH-30, 30, 15, 15)];
//        
//        CAShapeLayer* maskLayer=[CAShapeLayer layer];
//        maskLayer.path=startPath.CGPath;
//        fromVC.view.layer.mask=maskLayer;
//        
//        CABasicAnimation* pingAnimation=[CABasicAnimation animationWithKeyPath:@"path"];
//        pingAnimation.fromValue=(__bridge id)(startPath.CGPath);
//        pingAnimation.toValue=(__bridge id)(finalPath.CGPath);
//        pingAnimation.duration=[self transitionDuration:transitionContext];
//        pingAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pingAnimation.fillMode=kCAFillModeForwards;
//        pingAnimation.removedOnCompletion=NO;
//        pingAnimation.delegate=self;
//        [maskLayer addAnimation:pingAnimation forKey:@"pingInvertPOP"];
//        return;
        
        
        
        
        CABasicAnimation* scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue=@0.9;
        scaleAnimation.toValue=@1;
        
        CABasicAnimation* opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue=@0.3;
        opacityAnimation.toValue=@1;
        
        CAAnimationGroup* groupAnimation=[CAAnimationGroup animation];
        groupAnimation.animations=@[scaleAnimation, opacityAnimation];
        groupAnimation.duration=[self transitionDuration:transitionContext];
        groupAnimation.fillMode=kCAFillModeForwards;
        groupAnimation.removedOnCompletion=NO;
        groupAnimation.delegate=self;
        [toVC.view.layer addAnimation:groupAnimation forKey:@"group"];
        
        CABasicAnimation* offsetAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        offsetAnimation.fromValue=@0;
        offsetAnimation.toValue=@(IPHONE_WIDTH);
        offsetAnimation.duration=[self transitionDuration:transitionContext];
        offsetAnimation.fillMode=kCAFillModeForwards;
        offsetAnimation.removedOnCompletion=NO;
        offsetAnimation.delegate=self;
        [fromVC.view.layer addAnimation:offsetAnimation forKey:@"offset"];
        self.animationCount=2;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([anim isEqual:[self.tempToVC.view.layer animationForKey:@"group"]]) {
        [self.tempToVC.view.layer removeAnimationForKey:@"group"];
        self.animationCount--;
    }else if([anim isEqual:[self.tempFromVC.view.layer animationForKey:@"group"]]){
        [self.tempFromVC.view.layer removeAnimationForKey:@"group"];
    }else if([anim isEqual:[self.tempFromVC.view.layer animationForKey:@"offset"]]){
        self.animationCount--;
        [self.tempFromVC.view.layer removeAnimationForKey:@"offset"];
    }else{
        [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask=nil;
        [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    }
    if (self.animationCount<=0) {
        BOOL isCancel=[self.transitionContext transitionWasCancelled];
        
        //该方法不能多次执行，会出问题。只能执行一次
        [self.transitionContext completeTransition:!isCancel];
    }
}



@end
