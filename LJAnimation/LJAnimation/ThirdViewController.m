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

//#define BezierWidth 300
#define PointWidth  100
#define PointRadius 0

@interface ThirdViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)UIView* firstControlView;
@property(nonatomic, strong)UIView* secondControlView;

@property(nonatomic, strong)UIView* beginView;
@property(nonatomic, strong)UIView* endView;

//@property(nonatomic, strong)UIView* bezierView;

@property(nonatomic, assign)CGPoint firstPoint;
@property(nonatomic, assign)CGPoint secondPoint;

@property(nonatomic, assign)CGPoint beginPoint;
@property(nonatomic, assign)CGPoint endPoint;

@property(nonatomic, strong)LJBezierLayer* bezierLayer;

@property (weak, nonatomic) IBOutlet UIView *bezierView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
}
-(void)dealloc{
    NSLog(@"...third dealloc");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setBeizierUI];
}

-(void)setBeizierUI{
    
    self.bezierLayer=[LJBezierLayer layer];
//    self.bezierLayer.frame=CGRectMake(0, 0, BezierWidth, BezierWidth);
    self.bezierLayer.frame=self.bezierView.bounds;
    self.bezierLayer.isCubeCurve=YES;
    __weak typeof(self) tempWeakSelf=self;
    
//    self.bezierView=[[UIView alloc]initWithFrame:CGRectMake(35, IPHONE_HEIGHT-80-BezierWidth, BezierWidth, BezierWidth)];
    [self.bezierView.layer addSublayer:self.bezierLayer];
    self.bezierView.backgroundColor=[UIColor lightGrayColor];
//    [self.view addSubview:self.bezierView];
    
    CGFloat BezierWidth = self.bezierView.lj_width;
    CGFloat BezierHeight = self.bezierView.lj_height;
    
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
            Y=Y>BezierHeight?BezierHeight:Y;
            tempWeakSelf.firstControlView.center=CGPointMake(X, Y);
            tempWeakSelf.firstPoint=tempWeakSelf.firstControlView.center;
        }
    }];
    [self.bezierView addSubview:self.firstControlView];
    
    self.secondControlView=[[UIView alloc]initWithFrame:CGRectMake(BezierWidth-PointWidth, BezierHeight-PointWidth, PointWidth, PointWidth)];
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
            Y=Y>BezierHeight?BezierHeight:Y;
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
    colorView.backgroundColor=[UIColor systemCyanColor];
    
    UIView* color2View=[[UIView alloc]init];
    color2View.bounds=CGRectMake(0, 0, 20, 20);
    color2View.center=self.firstControlView.layer.position;
    color2View.layer.cornerRadius=10;
    color2View.backgroundColor=[UIColor blueColor];
    
    [self.firstControlView addSubview:colorView];
    [self.secondControlView addSubview:color2View];
    
    
    
    self.beginView=[[UIView alloc]initWithFrame:CGRectMake(-PointWidth/2, BezierHeight-PointWidth/2, PointWidth, PointWidth)];
    [self.beginView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.beginView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.beginPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.beginView.center=center;
            tempWeakSelf.bezierLayer.beginPoint=center;
            NSLog(@"%.2f, %.2f", center.x, center.y);
        }else if (sender.state==UIGestureRecognizerStateEnded){
            CGFloat X=tempWeakSelf.beginView.center.x;
            CGFloat Y=tempWeakSelf.beginView.center.y;
            X=X<0?0:X;
            X=X>BezierWidth?BezierWidth:X;
            Y=Y<0?0:Y;
            Y=Y>BezierHeight?BezierHeight:Y;
            tempWeakSelf.beginView.center=CGPointMake(X, Y);
            tempWeakSelf.beginPoint=tempWeakSelf.beginView.center;
        }
    }];
    [self.bezierView addSubview:self.beginView];
    
    self.endView=[[UIView alloc]initWithFrame:CGRectMake(BezierWidth-PointWidth/2, -PointWidth/2, PointWidth, PointWidth)];
    [self.endView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.endView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.endPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.endView.center=center;
            tempWeakSelf.bezierLayer.endPoint=center;
        }else if (sender.state==UIGestureRecognizerStateEnded){
            CGFloat X=tempWeakSelf.endView.center.x;
            CGFloat Y=tempWeakSelf.endView.center.y;
            X=X<0?0:X;
            X=X>BezierWidth?BezierWidth:X;
            Y=Y<0?0:Y;
            Y=Y>BezierHeight?BezierHeight:Y;
            tempWeakSelf.endView.center=CGPointMake(X, Y);
            tempWeakSelf.endPoint=tempWeakSelf.endView.center;
        }
    }];
    [self.bezierView addSubview:self.endView];
    
    self.beginPoint=self.beginView.center;
    self.endPoint=self.endView.center;
    
    UIView* color3View=[[UIView alloc]init];
    color3View.bounds=CGRectMake(0, 0, 20, 20);
    color3View.center=self.firstControlView.layer.position;
    color3View.layer.cornerRadius=10;
    color3View.backgroundColor=[UIColor redColor];
    
    UIView* color4View=[[UIView alloc]init];
    color4View.bounds=CGRectMake(0, 0, 20, 20);
    color4View.center=self.firstControlView.layer.position;
    color4View.layer.cornerRadius=10;
    color4View.backgroundColor=[UIColor orangeColor];
    
    [self.beginView addSubview:color3View];
    [self.endView addSubview:color4View];
    
    self.bezierLayer.beginPoint = self.beginView.center;
    self.bezierLayer.endPoint = self.endView.center;
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
