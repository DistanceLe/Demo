//
//  SecondViewController.m
//  LJAnimation
//
//  Created by LiJie on 16/7/14.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "SecondViewController.h"
#import "PushTransition.h"
@interface SecondViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)CALayer*layerOne;
@property(nonatomic,strong)CALayer*colorLayer;

@property(nonatomic, strong)UIView* testView;

@end

@implementation SecondViewController
{
    UIPercentDrivenInteractiveTransition* percentTransition;
    
}

-(void)dealloc{
    NSLog(@"...sencond dealloc");
}

-(void)test{
    self.testView=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.testView.backgroundColor=[UIColor redColor];
    [self.testView addTapGestureHandler:^(UITapGestureRecognizer *tap, UIView *itself) {
        itself.backgroundColor=RandomColor;
    }];
    [self.view addSubview:self.testView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layerOne=[CALayer layer];
    self.layerOne.frame=CGRectMake(0, 0, 40, 40);
    self.layerOne.position=CGPointMake(30, 64+30);
    self.layerOne.backgroundColor=[UIColor greenColor].CGColor;
    [self.view.layer addSublayer:self.layerOne];
    
    self.colorLayer=[CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
    

    /**  ================================= */
    
    UIScreenEdgePanGestureRecognizer* edgeGes=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges=UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    UIButton* popButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [popButton setTitle:@"pop" forState:UIControlStateNormal];
    popButton.frame=CGRectMake(30, 30, 100, 80);
    popButton.backgroundColor=[UIColor purpleColor];
    __weak typeof(self) tempWeakSelf=self;
    [popButton addTargetClickHandler:^(id sender, id status) {
        [tempWeakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:popButton];
    [self test];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    return percentTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    return nil;
    if (operation==UINavigationControllerOperationPop) {
        PushTransition* pop=[PushTransition defaultTransitionIsPush:NO];
        return pop;
    }else if (operation==UINavigationControllerOperationPush){
        PushTransition* push=[PushTransition defaultTransitionIsPush:YES];
        push.transitionType=LJTransitionCompress;
        return push;
    }else{
        return nil;
    }
}


-(void)edgePan:(UIScreenEdgePanGestureRecognizer*)recognizer{
    CGFloat per=[recognizer translationInView:self.view].x/IPHONE_WIDTH;
    
    per=MIN(1.0, (MAX(0.0, per)));
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        percentTransition=[[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state==UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state==UIGestureRecognizerStateEnded || recognizer.state==UIGestureRecognizerStateCancelled){
        if (per>0.4) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition=nil;
    }
    
}


#pragma mark - ================ CALayer的呈现与模型 ==================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if ([self.colorLayer.presentationLayer hitTest:point]) {//实时layout 可以看到改变的效果
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }else if ([self.layerOne.modelLayer hitTest:point])//或者[self.layerOne hitTest:point]  原始的Layout看不到效果
    {
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.layerOne.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        CGPoint point1=point;
        point1.x=point.x+100;
        self.layerOne.position=point1;
        [CATransaction commit];
    }
}







@end
