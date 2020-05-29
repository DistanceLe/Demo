//
//  ThirdViewController.m
//  LJAnimation
//
//  Created by LiJie on 16/7/20.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ThirdViewController.h"
#import "PushTransition.h"

#import "LJBezierLayer.h"

#define BezierWidth 300
#define PointWidth  100
#define PointRadius 0

@interface ThirdViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIView* firstControlView;
@property(nonatomic, strong)UIView* secondControlView;
@property(nonatomic, strong)UIView* bezierView;

@property(nonatomic, assign)CGPoint firstPoint;
@property(nonatomic, assign)CGPoint secondPoint;

@property(nonatomic, strong)LJBezierLayer* bezierLayer;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    [self setBeizierUI];
}
-(void)dealloc{
    NSLog(@"...third dealloc");
}
-(void)setBeizierUI{
    
    self.bezierLayer=[LJBezierLayer layer];
    self.bezierLayer.frame=CGRectMake(0, 0, BezierWidth, BezierWidth);
    self.bezierLayer.isCubeCurve=YES;
    __weak typeof(self) tempWeakSelf=self;
    
    self.bezierView=[[UIView alloc]initWithFrame:CGRectMake(35, IPHONE_HEIGHT-80-BezierWidth, BezierWidth, BezierWidth)];
    [self.bezierView.layer addSublayer:self.bezierLayer];
    self.bezierView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.bezierView];
    
    self.firstControlView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, PointWidth, PointWidth)];
    [self.firstControlView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.firstControlView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.firstPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.firstControlView.center=center;
            tempWeakSelf.bezierLayer.firstPoint=center;
        }else if (sender.state==UIGestureRecognizerStateEnded){
            CGFloat X=tempWeakSelf.firstControlView.center.x;
            CGFloat Y=tempWeakSelf.firstControlView.center.y;
            X=X<0?0:X;
            X=X>BezierWidth?BezierWidth:X;
            Y=Y<0?0:Y;
            Y=Y>BezierWidth?BezierWidth:Y;
            tempWeakSelf.firstControlView.center=CGPointMake(X, Y);
            tempWeakSelf.firstPoint=tempWeakSelf.firstControlView.center;
        }
    }];
    [self.bezierView addSubview:self.firstControlView];
    
    self.secondControlView=[[UIView alloc]initWithFrame:CGRectMake(BezierWidth-PointWidth, BezierWidth-PointWidth, PointWidth, PointWidth)];
    [self.secondControlView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.secondControlView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.secondPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.secondControlView.center=center;
            tempWeakSelf.bezierLayer.secondPoint=center;
        }else if (sender.state==UIGestureRecognizerStateEnded){
            CGFloat X=tempWeakSelf.secondControlView.center.x;
            CGFloat Y=tempWeakSelf.secondControlView.center.y;
            X=X<0?0:X;
            X=X>BezierWidth?BezierWidth:X;
            Y=Y<0?0:Y;
            Y=Y>BezierWidth?BezierWidth:Y;
            tempWeakSelf.secondControlView.center=CGPointMake(X, Y);
            tempWeakSelf.secondPoint=tempWeakSelf.secondControlView.center;
        }
    }];
    [self.bezierView addSubview:self.secondControlView];
    self.firstPoint=self.firstControlView.center;
    self.secondPoint=self.secondControlView.center;
    
    UIView* colorView=[[UIView alloc]init];
    colorView.bounds=CGRectMake(0, 0, 20, 20);
    colorView.center=self.firstControlView.layer.position;
    colorView.layer.cornerRadius=10;
    colorView.backgroundColor=[UIColor blueColor];
    
    UIView* color2View=[[UIView alloc]init];
    color2View.bounds=CGRectMake(0, 0, 20, 20);
    color2View.center=self.firstControlView.layer.position;
    color2View.layer.cornerRadius=10;
    color2View.backgroundColor=[UIColor blueColor];
    
    [self.firstControlView addSubview:colorView];
    [self.secondControlView addSubview:color2View];
}

- (IBAction)bezierTypeClick:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.bezierLayer.isCubeCurve=NO;
        self.secondControlView.hidden=YES;
    }else{
        self.bezierLayer.isCubeCurve=YES;
        self.secondControlView.hidden=NO;
    }
}

#pragma mark - ================ 转场动画 ==================
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation==UINavigationControllerOperationPop) {
        PushTransition* pop=[PushTransition defaultTransitionIsPush:NO];
        pop.transitionType=LJTransitionCompress;
        return pop;
    }else{
        return nil;
    }
    
}
- (IBAction)popClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
