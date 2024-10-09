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
#define PointWidth  60
#define ColorPointWidth  20
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
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@property(nonatomic, strong)NSString* beginStr;
@property(nonatomic, strong)NSString* endStr;
@property(nonatomic, strong)NSString* controlStr;
@property(nonatomic, strong)NSString* control2Str;


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

-(void)refreshInfo{
    self.infoTextView.text = [NSString stringWithFormat:@"图片大小:(%.2f, %.2f)\n\n起始点:%@\n\n终点:%@\n\n第一个控制点:%@\n\n第二控制点:%@",self.bezierView.lj_width, self.bezierView.lj_height, self.beginStr, self.endStr, self.controlStr, self.control2Str];
}

-(void)setBeizierUI{
    
    LJBezierLayer* blackLine = [LJBezierLayer layer];
    blackLine.frame = self.bezierView.bounds;
    blackLine.beginPoint=CGPointMake(0.3597*self.bezierView.lj_width, 0.6885*self.bezierView.lj_height);
    blackLine.endPoint=CGPointMake(0.799*self.bezierView.lj_width, 0.5681*self.bezierView.lj_height);
    blackLine.firstPoint=CGPointMake(0.6052*self.bezierView.lj_width, 0.394*self.bezierView.lj_height);
    blackLine.lineColor = [UIColor blackColor];
    [self.bezierView.layer addSublayer:blackLine];
    
    
    #pragma mark - ================ 上下两条曲线 ==================
    LJBezierLayer* upLine = [LJBezierLayer layer];
    upLine.frame = self.bezierView.bounds;
    upLine.beginPoint=CGPointMake(0.337*self.bezierView.lj_width, 0.6604*self.bezierView.lj_height);
    upLine.endPoint=CGPointMake(0.6766*self.bezierView.lj_width, 0.4514*self.bezierView.lj_height);
    upLine.firstPoint=CGPointMake(0.5474*self.bezierView.lj_width, 0.3842*self.bezierView.lj_height);
    upLine.lineColor = [UIColor lightGrayColor];
    upLine.isDash = YES;
    [self.bezierView.layer addSublayer:upLine];
    
    
    LJBezierLayer* downLine = [LJBezierLayer layer];
    downLine.frame = self.bezierView.bounds;
    downLine.beginPoint=CGPointMake(0.3812*self.bezierView.lj_width, 0.7159*self.bezierView.lj_height);
    downLine.endPoint=CGPointMake(0.7766*self.bezierView.lj_width, 0.6145*self.bezierView.lj_height);
    downLine.firstPoint=CGPointMake(0.6039*self.bezierView.lj_width, 0.4838*self.bezierView.lj_height);
    downLine.lineColor = [UIColor lightGrayColor];
    downLine.isDash = YES;
    [self.bezierView.layer addSublayer:downLine];
    
    #pragma mark - ================ 上下偏移 四条曲线 ==================
    LJBezierLayer* black1Line = [LJBezierLayer layer];
    black1Line.frame = self.bezierView.bounds;
    black1Line.beginPoint=CGPointMake(0.3552*self.bezierView.lj_width, 0.682*self.bezierView.lj_height);
    black1Line.endPoint=CGPointMake(0.7299*self.bezierView.lj_width, 0.5046*self.bezierView.lj_height);
    black1Line.firstPoint=CGPointMake(0.5786*self.bezierView.lj_width, 0.4148*self.bezierView.lj_height);
    black1Line.lineColor = [UIColor blackColor];
    [self.bezierView.layer addSublayer:black1Line];
    
    
    LJBezierLayer* black2Line = [LJBezierLayer layer];
    black2Line.frame = self.bezierView.bounds;
    black2Line.beginPoint=CGPointMake(0.35*self.bezierView.lj_width, 0.6762*self.bezierView.lj_height);
    black2Line.endPoint=CGPointMake(0.6942*self.bezierView.lj_width, 0.4704*self.bezierView.lj_height);
    black2Line.firstPoint=CGPointMake(0.5786*self.bezierView.lj_width, 0.4068*self.bezierView.lj_height);
    black2Line.lineColor = [UIColor blackColor];
    [self.bezierView.layer addSublayer:black2Line];
    
    
    LJBezierLayer* black01Line = [LJBezierLayer layer];
    black01Line.frame = self.bezierView.bounds;
    black01Line.beginPoint=CGPointMake(0.364*self.bezierView.lj_width, 0.694*self.bezierView.lj_height);
    black01Line.endPoint=CGPointMake(0.7597*self.bezierView.lj_width, 0.5638*self.bezierView.lj_height);
    black01Line.firstPoint=CGPointMake(0.5688*self.bezierView.lj_width, 0.449*self.bezierView.lj_height);
    black01Line.lineColor = [UIColor blackColor];
    [self.bezierView.layer addSublayer:black01Line];
    
    LJBezierLayer* black02Line = [LJBezierLayer layer];
    black02Line.frame = self.bezierView.bounds;
    black02Line.beginPoint=CGPointMake(0.3683*self.bezierView.lj_width, 0.6986*self.bezierView.lj_height);
    black02Line.endPoint=CGPointMake(0.7422*self.bezierView.lj_width, 0.587*self.bezierView.lj_height);
    black02Line.firstPoint=CGPointMake(0.5617*self.bezierView.lj_width, 0.4728*self.bezierView.lj_height);
    black02Line.lineColor = [UIColor blackColor];
    [self.bezierView.layer addSublayer:black02Line];
    
    
    
    
    
    
    
    
    
    self.bezierLayer=[LJBezierLayer layer];
//    self.bezierLayer.frame=CGRectMake(0, 0, BezierWidth, BezierWidth);
    self.bezierLayer.frame=self.bezierView.bounds;
//    self.bezierLayer.isCubeCurve=YES;
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
            
            tempWeakSelf.controlStr = [NSString stringWithFormat:@"(%.2f,%.2f)=(%.2f%%, %.2f%%)", center.x, center.y, center.x/tempWeakSelf.bezierView.lj_width*100, center.y/tempWeakSelf.bezierView.lj_height*100];
            [tempWeakSelf refreshInfo];
            
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
            
            tempWeakSelf.control2Str = [NSString stringWithFormat:@"(%.2f,%.2f)=(%.2f%%, %.2f%%)", center.x, center.y, center.x/tempWeakSelf.bezierView.lj_width*100, center.y/tempWeakSelf.bezierView.lj_height*100];
            [tempWeakSelf refreshInfo];
            
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
    colorView.bounds=CGRectMake(0, 0, ColorPointWidth, ColorPointWidth);
    colorView.center=self.firstControlView.layer.position;
    colorView.layer.cornerRadius=ColorPointWidth/2.0;
    colorView.backgroundColor=[UIColor systemCyanColor];
    
    UIView* color2View=[[UIView alloc]init];
    color2View.bounds=CGRectMake(0, 0, ColorPointWidth, ColorPointWidth);
    color2View.center=self.firstControlView.layer.position;
    color2View.layer.cornerRadius=ColorPointWidth/2.0;
    color2View.backgroundColor=[UIColor blueColor];
    
    [self.firstControlView addSubview:colorView];
    [self.secondControlView addSubview:color2View];
    
    
    
    self.beginView=[[UIView alloc]initWithFrame:CGRectMake(0, BezierHeight-PointWidth, PointWidth, PointWidth)];
    [self.beginView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.beginView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.beginPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.beginView.center=center;
            tempWeakSelf.bezierLayer.beginPoint=center;
            
            tempWeakSelf.beginStr = [NSString stringWithFormat:@"(%.2f,%.2f)=(%.2f%%, %.2f%%)", center.x, center.y, center.x/tempWeakSelf.bezierView.lj_width*100, center.y/tempWeakSelf.bezierView.lj_height*100];
            [tempWeakSelf refreshInfo];
            
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
    
    self.endView=[[UIView alloc]initWithFrame:CGRectMake(BezierWidth-PointWidth, 0, PointWidth, PointWidth)];
    [self.endView addPanGestureHandler:^(UIPanGestureRecognizer* sender, id status) {
        CGPoint panPoint=[sender translationInView:tempWeakSelf.endView];
        if (sender.state==UIGestureRecognizerStateChanged) {
            CGPoint center=tempWeakSelf.endPoint;
            center.x+=panPoint.x;
            center.y+=panPoint.y;
            
            tempWeakSelf.endView.center=center;
            tempWeakSelf.bezierLayer.endPoint=center;
            
            tempWeakSelf.endStr = [NSString stringWithFormat:@"(%.2f,%.2f)=(%.2f%%, %.2f%%)", center.x, center.y, center.x/tempWeakSelf.bezierView.lj_width*100, center.y/tempWeakSelf.bezierView.lj_height*100];
            [tempWeakSelf refreshInfo];
            
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
    color3View.bounds=CGRectMake(0, 0, ColorPointWidth, ColorPointWidth);
    color3View.center=self.firstControlView.layer.position;
    color3View.layer.cornerRadius=ColorPointWidth/2.0;
    color3View.backgroundColor=[UIColor redColor];
    
    UIView* color4View=[[UIView alloc]init];
    color4View.bounds=CGRectMake(0, 0, ColorPointWidth, ColorPointWidth);
    color4View.center=self.firstControlView.layer.position;
    color4View.layer.cornerRadius=ColorPointWidth/2.0;
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
