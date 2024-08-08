//
//  ViewController.m
//  LJAnimation
//
//  Created by LiJie on 16/7/7.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "PushTransition.h"
#import <CoreText/CoreText.h>

#import "OvalLayer.h"
#import "TestView.h"
#import "KYLoadingHUD.h"
#import "LJButton.h"
#import "LJButton_Google.h"

@interface ViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;

@property (strong,nonatomic) CAShapeLayer *layer;

@property (nonatomic, strong)UIDynamicAnimator* dynamicAnimator;

@property (nonatomic, strong)UIAttachmentBehavior* attachementBehavior;//吸附
@property (nonatomic, strong)UIAttachmentBehavior* attachement2Behavior;//吸附
@property (nonatomic, strong)UIAttachmentBehavior* attachement3Behavior;//吸附
@property (nonatomic, strong)UICollisionBehavior* collisionBehavior;//碰撞
@property (nonatomic, strong)UIGravityBehavior* gravityBehavior;//重力
@property (nonatomic, strong)UIPushBehavior* pushBehavior;//推动
@property (nonatomic, strong)UISnapBehavior* snapBehavior;//捕捉
@property (nonatomic, strong)UIDynamicItemBehavior* itemBehavior;//在item层级设定一些参数

@property (nonatomic, strong)LJButton_Google* but;
@property (nonatomic, strong)UIView* controlPoint;
@property (nonatomic, strong)UIView* controlPoint2;
@property (nonatomic, strong)UIView* panView;
@property (nonatomic, assign)CGPoint panPoint;


@property (strong,nonatomic) UIImageView *ballImageView;;
//@property (strong,nonatomic) UIView *middleView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *bottomView;

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIGravityBehavior *panGravity;
@property (strong,nonatomic) UIGravityBehavior *viewsGravity;

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self test];
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
    [self test7];
    
    
    return;
    
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    NSMutableArray* mArray=[NSMutableArray arrayWithArray:@[[NSMutableString stringWithFormat:@"abcdefg"], @"44444",  @0, @1, @2]];
    NSArray* array=@[[NSMutableString stringWithFormat:@"abcdefg"], @"44444",  @0, @1, @2];
    
    NSMutableString* mStr=mArray[0];
    [mStr insertString:@"...." atIndex:0];
    
    //崩溃了：。。。
//    NSMutableArray* mStr2=mArray[1];
//    [mStr2 insertObject:@"9999" atIndex:0];
    
    NSMutableString* mStr3=array[0];
    [mStr3 insertString:@"~~~~" atIndex:0];
    
    //崩溃了：。。。
//    NSMutableString* mStr4=array[1];
//    [mStr4 insertString:@"****" atIndex:0]; 
    
    NSNumber* number=mArray[2];
    number=@(6666);
    
    NSNumber* number1=array[2];
    number1=@(00000);
    
    NSLog(@"%@ \n %@", mArray, array);
    
}

#pragma mark - ================ UINavigationControllerDelegate ==================

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation==UINavigationControllerOperationPush) {
        PushTransition* push=[PushTransition defaultTransitionIsPush:YES];
        return push;
    }else{
        return nil;
    }
}
-(UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    return image;
}
-(void)test7{
    _but=[LJButton_Google buttonWithType:UIButtonTypeCustom];
    [_but addTargetClickHandler:^(id sender, id status) {
        NSLog(@"click...");
    }];
    _but.circleEffectColor=kRGBColor(10, 100, 220, 0.2);
    _but.frame=CGRectMake(0, IPHONE_HEIGHT-200, 50, 50);
    _but.backgroundColor=[UIColor lightGrayColor];
    [_but setTitle:@"我是来搞破坏的" forState:UIControlStateNormal];
    [self.view addSubview:_but];
    
    _dynamicAnimator=[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    [self attachement1];
//    [self attachement];
}

/**  UIView通过动画吸附到某个点上 */
-(void)snap{
    
    self.snapBehavior=[[UISnapBehavior alloc]initWithItem:self.but snapToPoint:self.but.center];
    self.snapBehavior.damping=0.7;
    [self.dynamicAnimator addBehavior:self.snapBehavior];
    @weakify(self);
    [self.view addTapGestureHandler:^(UITapGestureRecognizer *tap, UIView *itself) {
        @strongify(self);
        CGPoint tapPoint=[tap locationInView:self.view];
        self.snapBehavior.snapPoint=tapPoint;
    }];
}

/**  实现每点击一次掉落一张图片 */
-(void)gravity{
    
    self.gravityBehavior=[[UIGravityBehavior alloc]initWithItems:nil];
    
    self.collisionBehavior=[[UICollisionBehavior alloc]initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary=YES;
    
    self.itemBehavior=[[UIDynamicItemBehavior alloc]initWithItems:nil];
    self.itemBehavior.elasticity=0.6;
    self.itemBehavior.friction=0.5;
    self.itemBehavior.resistance=0.5;
    
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.itemBehavior];
    
    @weakify(self);
    [self.view addTapGestureHandler:^(UITapGestureRecognizer *tap, UIView *itself) {
       @strongify(self);
        UIImage* image=[UIImage imageNamed:@"login_ali"];
        UIImageView* imageView=[[UIImageView alloc]initWithImage:image];
        [self.view addSubview:imageView];
        
        CGPoint tapPos=[tap locationInView:self.view];
        imageView.center=tapPos;
        
        [self.gravityBehavior addItem:imageView];
        [self.collisionBehavior addItem:imageView];
        [self.itemBehavior addItem:imageView];
    }];
    
}
-(void)attachement1{
    _panView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view insertSubview:_panView belowSubview:_but];
    
    CAGradientLayer *grd=[[CAGradientLayer alloc] init];
    [grd setFrame:_panView.frame];
    grd.colors = [[NSArray alloc] initWithObjects:(__bridge id)([UIColor colorWithRed:0.0 green:191.0/255.0 blue:255.0/255.0 alpha:1].CGColor),(__bridge id)([UIColor whiteColor].CGColor), nil];
    [_panView.layer addSublayer:grd];
    
    self.but.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-30, [[UIScreen mainScreen] bounds].size.height/1.5, 30, 30);

    
    /**  连接块不能太小，要不然会有拉不动的感觉。模仿的是现实世界，小物块拉不动大物块 */
    _controlPoint2 = [[UIView alloc] initWithFrame:CGRectMake(_but.center.x-15, 200, 60, 60)];
    [_controlPoint2 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_controlPoint2];
    [_controlPoint2 setCenter:CGPointMake(_controlPoint2.center.x, _panView.center.y+100)];
    
    _controlPoint = [[UIView alloc] initWithFrame:CGRectMake(_but.center.x-15, 200, 60, 60)];
    [_controlPoint setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_controlPoint];
    [_controlPoint setCenter:CGPointMake(_controlPoint.center.x, _panView.center.y+200)];
    
    _animator=[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.panGravity=[[UIGravityBehavior alloc] initWithItems:@[self.panView]];
    [self.animator addBehavior:self.panGravity];
    
    _viewsGravity=[[UIGravityBehavior alloc] initWithItems:@[_but,_controlPoint2,_controlPoint]];
    [_animator addBehavior:_viewsGravity];
    
    @weakify(self);
    _viewsGravity.action=^{
        @strongify(self);
//        NSLog(@"acting 220");
        // 弹性 会一直进来
        UIBezierPath* path=[[UIBezierPath alloc]init];
        [path moveToPoint:self.panView.center];
        [path addCurveToPoint:self.but.center controlPoint1:self.controlPoint2.center controlPoint2:self.controlPoint.center];
        if (!self.layer) {
            self.layer=[[CAShapeLayer alloc]init];
            self.layer.fillColor=[UIColor clearColor].CGColor;
            self.layer.strokeColor=[UIColor redColor].CGColor;
            self.layer.lineWidth=5.0f;
            
            [self.layer setShadowOffset:CGSizeMake(-1, 2)];
            [self.layer setShadowOpacity:0.5];
            [self.layer setShadowRadius:5.0];
            [self.layer setShadowColor:[UIColor blackColor].CGColor];
            [self.layer setMasksToBounds:NO];
            
            [self.view.layer insertSublayer:self.layer below:self.but.layer];
        }
        self.layer.path=path.CGPath;
    };
    UICollisionBehavior *Collision=[[UICollisionBehavior alloc] initWithItems:@[_panView]];
    
    [Collision addBoundaryWithIdentifier:@"Left" fromPoint:CGPointMake(-1, 0)
                                 toPoint:CGPointMake(-1, [[UIScreen mainScreen] bounds].size.height)];
    
    [Collision addBoundaryWithIdentifier:@"Right" fromPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1,0)
                                 toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1, [[UIScreen mainScreen] bounds].size.height)];
    
    [Collision addBoundaryWithIdentifier:@"Middle" fromPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height/2)
                                 toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2)];
    [_animator addBehavior:Collision];
    
    //3 UIAttachmentBehaviors
    UIAttachmentBehavior *attach1=[[UIAttachmentBehavior alloc]initWithItem:_panView
                                                             attachedToItem:_controlPoint2];
    [_animator addBehavior:attach1];
    
    UIAttachmentBehavior *attach2=[[UIAttachmentBehavior alloc] initWithItem:_controlPoint2
                                                              attachedToItem:_controlPoint];
    [_animator addBehavior:attach2];
    
    UIAttachmentBehavior *attach3=[[UIAttachmentBehavior alloc] initWithItem:_controlPoint
                                                            offsetFromCenter:UIOffsetMake(0, 0)
                                                              attachedToItem:_but
                                   //使球的连接点在 球上方，这样球就可以转动了。
                                                            offsetFromCenter:UIOffsetMake(0, -_but.bounds.size.height/2)];
    [_animator addBehavior:attach3];
    
    //UIDynamicItemBehavior
    UIDynamicItemBehavior *PanItem=[[UIDynamicItemBehavior alloc] initWithItems:@[_panView,_controlPoint2,_controlPoint,_but]];
    PanItem.elasticity=0.5;
    [_animator addBehavior:PanItem];
    
    [_panView addPanGestureHandler:^(UIPanGestureRecognizer *pan, UIView *itself) {
        @strongify(self);
        CGPoint location = [pan locationInView:self.view];
        pan.view.center=location;
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        
        if (pan.state==UIGestureRecognizerStateBegan) {
            [self.animator removeBehavior:self.panGravity];
        }
        else if (pan.state==UIGestureRecognizerStateChanged){
            
        }
        else if (pan.state==UIGestureRecognizerStateEnded) {
            [self.animator addBehavior:self.panGravity];
        }
        
        [self.animator updateItemUsingCurrentState:pan.view];
    }];
}
 //======================
-(void)attachement{
    
    _panView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2)];
    [_panView setAlpha:0.5];
    [self.view addSubview:_panView];
    [_panView.layer setShadowOffset:CGSizeMake(-1, 2)];
    [_panView.layer setShadowOpacity:0.5];
    [_panView.layer setShadowRadius:5.0];
    [_panView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_panView.layer setMasksToBounds:NO];
    [_panView.layer setShadowPath:[UIBezierPath bezierPathWithRect:_panView.bounds].CGPath];
    
    
    CAGradientLayer *grd=[[CAGradientLayer alloc] init];
    [grd setFrame:_panView.frame];
    grd.colors = [[NSArray alloc] initWithObjects:(__bridge id)([UIColor colorWithRed:0.0 green:191.0/255.0 blue:255.0/255.0 alpha:1].CGColor),(__bridge id)([UIColor whiteColor].CGColor), nil];
    [_panView.layer addSublayer:grd];
    
    
    
    _ballImageView=[[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-30, [[UIScreen mainScreen] bounds].size.height/1.5, 60, 60)];
    
    [_ballImageView setImage:[UIImage imageNamed:@"ball"]];
    [self.view addSubview:_ballImageView];
    [_ballImageView.layer setShadowOffset:CGSizeMake(-4, 4)];
    [_ballImageView.layer setShadowOpacity:0.5];
    [_ballImageView.layer setShadowRadius:5.0];
    [_ballImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_ballImageView.layer setMasksToBounds:NO];
    
    
    /**  连接块不能太小，要不然会有拉不动的感觉。模仿的是现实世界，小物块拉不动大物块 */
    _topView = [[UIView alloc] initWithFrame:CGRectMake(_ballImageView.center.x-15, 200, 30, 30)];
    [_topView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_topView];
    [_topView setCenter:CGPointMake(_topView.center.x, _panView.center.y*3/2)];
    
    
    //3
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(_ballImageView.center.x-15, 200, 30, 30)];
    [_bottomView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_bottomView];
    [_bottomView setCenter:CGPointMake(_bottomView.center.x, _panView.center.y*2.25)];
    
    _animator=[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    self.panGravity=[[UIGravityBehavior alloc] initWithItems:@[self.panView]];
    [self.animator addBehavior:self.panGravity];
    
    _viewsGravity=[[UIGravityBehavior alloc] initWithItems:@[_ballImageView,_topView,_bottomView]];
    [_animator addBehavior:_viewsGravity];
    
    @weakify(self);
    _viewsGravity.action=^{
        @strongify(self);
        NSLog(@"acting 349");
        UIBezierPath* path=[[UIBezierPath alloc]init];
        [path moveToPoint:self.panView.center];
        [path addCurveToPoint:self.ballImageView.center controlPoint1:self.topView.center controlPoint2:self.bottomView.center];
        if (!self.layer) {
            self.layer=[[CAShapeLayer alloc]init];
            self.layer.fillColor=[UIColor clearColor].CGColor;
            self.layer.strokeColor=[UIColor redColor].CGColor;
            self.layer.lineWidth=5.0f;
            
            [self.layer setShadowOffset:CGSizeMake(-1, 2)];
            [self.layer setShadowOpacity:0.5];
            [self.layer setShadowRadius:5.0];
            [self.layer setShadowColor:[UIColor blackColor].CGColor];
            [self.layer setMasksToBounds:NO];
            
            [self.view.layer insertSublayer:self.layer below:self.but.layer];
        }
        self.layer.path=path.CGPath;
    };
    
    UICollisionBehavior *Collision=[[UICollisionBehavior alloc] initWithItems:@[_panView]];
    
    [Collision addBoundaryWithIdentifier:@"Left" fromPoint:CGPointMake(-1, 0)
                                 toPoint:CGPointMake(-1, [[UIScreen mainScreen] bounds].size.height)];
    
    [Collision addBoundaryWithIdentifier:@"Right" fromPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1,0)
                                 toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width+1, [[UIScreen mainScreen] bounds].size.height)];
    
    [Collision addBoundaryWithIdentifier:@"Middle" fromPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height/2)
                                 toPoint:CGPointMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height/2)];
    [_animator addBehavior:Collision];
    
    
    //3 UIAttachmentBehaviors
    UIAttachmentBehavior *attach1=[[UIAttachmentBehavior alloc]initWithItem:_panView
                                                             attachedToItem:_topView];
    [_animator addBehavior:attach1];
    
    UIAttachmentBehavior *attach2=[[UIAttachmentBehavior alloc] initWithItem:_topView
                                                              attachedToItem:_bottomView];
    [_animator addBehavior:attach2];
    
    UIAttachmentBehavior *attach3=[[UIAttachmentBehavior alloc] initWithItem:_bottomView
                                                            offsetFromCenter:UIOffsetMake(0, 0)
                                                              attachedToItem:_ballImageView
                                   //使球的连接点在 球上方，这样球就可以转动了。
                                                            offsetFromCenter:UIOffsetMake(0, -_ballImageView.bounds.size.height/2)];
    [_animator addBehavior:attach3];
    
    //UIDynamicItemBehavior
    UIDynamicItemBehavior *PanItem=[[UIDynamicItemBehavior alloc] initWithItems:@[_panView,_topView,_bottomView,_ballImageView]];
    PanItem.elasticity=0.5;
    [_animator addBehavior:PanItem];
    
    [_panView addPanGestureHandler:^(UIPanGestureRecognizer *pan, UIView *itself) {
        @strongify(self);
        CGPoint translation = [pan translationInView:pan.view];
        if (!(pan.view.center.y+ translation.y>([[UIScreen mainScreen] bounds].size.height/2)-(pan.view.bounds.size.height/2))) {
            
            pan.view.center=CGPointMake(pan.view.center.x, pan.view.center.y+ translation.y);
            [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
        }
        if (pan.state==UIGestureRecognizerStateBegan) {
            [self.animator removeBehavior:self.panGravity];
        }
        else if (pan.state==UIGestureRecognizerStateChanged){
            
        }
        else if (pan.state==UIGestureRecognizerStateEnded) {
            [self.animator addBehavior:self.panGravity];
        }
        
        [self.animator updateItemUsingCurrentState:pan.view];
    }];
}

-(void)push{
    _pushBehavior=[[UIPushBehavior alloc]initWithItems:@[self.but] mode:UIPushBehaviorModeInstantaneous];
    @weakify(self);
    [self.view addTapGestureHandler:^(UITapGestureRecognizer *tap, UIView *itself) {
        @strongify(self);
        
        CGPoint location=[tap locationInView:self.view];
        CGPoint boxLocation=[tap locationInView:itself];
        CGFloat magnitude=sqrtf((location.x*location.x)+(location.y*location.y));
        
        [self.dynamicAnimator removeAllBehaviors];
        self.pushBehavior.pushDirection=CGVectorMake(location.x/10, location.y/10);
        self.pushBehavior.magnitude=magnitude;
        [self.dynamicAnimator addBehavior:self.pushBehavior];
        
        UIOffset centerOffest=UIOffsetMake(boxLocation.x-CGRectGetMinX(itself.bounds), boxLocation.y=CGRectGetMinY(itself.bounds));
        self.attachementBehavior=[[UIAttachmentBehavior alloc]initWithItem:itself offsetFromCenter:centerOffest attachedToAnchor:location];
        self.attachementBehavior.damping=0.6;
        self.attachementBehavior.frequency=0.8;
        [self.dynamicAnimator addBehavior:self.attachementBehavior];
    }];
}

-(void)test6{
    
    LJButton* but=[LJButton buttonWithType:UIButtonTypeSystem];
    but.frame=CGRectMake(30, 100, 200, 200);
    but.backgroundColor=[UIColor lightGrayColor];
    [but setTitle:@"我是来搞破坏的" forState:UIControlStateNormal];
    [self.view addSubview:but];
    
    
    
//    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 180, 100, 60)];
//    imageView.image=[self imageWithColor:[UIColor orangeColor] size:CGSizeMake(10, 10)];
//    [self.view addSubview:imageView];
}


-(void)test5{
    KYLoadingHUD* hud=[[KYLoadingHUD alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:hud];
    
    [hud showHUD];
    
    
}


-(void)test4{
    
    //创建path
    CGMutablePathRef letters=CGPathCreateMutable();
    
    //设置字体
    CTFontRef font=CTFontCreateWithName(CFSTR("Helvetica-Bold"), 100, NULL);
    NSDictionary* attrs=[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font, kCTFontAttributeName, nil];
    
    
    NSAttributedString* attrString=[[NSAttributedString alloc]initWithString:@"李杰" attributes:attrs];
    
    //创建line
    CTLineRef line=CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    //根据line 获得一个数组
    CFArrayRef runArray=CTLineGetGlyphRuns(line);
    
    //获得每一个run
    for (CFIndex runIndex=0; runIndex<CFArrayGetCount(runArray); runIndex++) {
        
        //获得run字体
        CTRunRef run=(CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont=CFDictionaryGetValue((CTRunGetAttributes(run)), kCTFontAttributeName);
        
        //获得run的每一个形象字
        for (CFIndex runGlyphIndex=0; runGlyphIndex<CTRunGetGlyphCount(run); runGlyphIndex++) {
            
            //获得形象字
            CFRange thisGlyphRange=CFRangeMake(runGlyphIndex, 1);
            
            //获得形象字信息
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            //获得形象字外线的Path
            CGPathRef letter=CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t=CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    CFRelease(line);
    
    //根据构造出来的path 构造bezier对象
    UIBezierPath* path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    //根据bezier 创建shapeLayer对象
    CAShapeLayer* pathLayer=[CAShapeLayer layer];
    pathLayer.path=path.CGPath;
    pathLayer.frame=CGRectMake(50, 50, 200, 200);
    pathLayer.bounds=CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped=YES;
    pathLayer.strokeColor=[[UIColor purpleColor]CGColor];
    pathLayer.fillColor=nil;
    pathLayer.lineWidth=5.0f;
    pathLayer.lineJoin=kCALineJoinBevel;
    
    [self.view.layer addSublayer:pathLayer];
    
    
    CABasicAnimation* pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration=10.0f;
    pathAnimation.fromValue=@0;
    pathAnimation.toValue=@1;
    
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}



-(void)test3{
    UIView* testVeiw1=[[UIView alloc]initWithFrame:CGRectMake(20, 20, 150, 150)];
    testVeiw1.backgroundColor=[UIColor greenColor];
    [self.view addSubview:testVeiw1];
    
    UIView* testVeiw=[[UIView alloc]initWithFrame:CGRectMake(20, 20, 150, 150)];
    testVeiw.backgroundColor=[UIColor redColor];
    [self.view addSubview:testVeiw];
    testVeiw.layer.zPosition=150;
    
    
    UIBezierPath* startPath=[UIBezierPath bezierPathWithRect:testVeiw.bounds];
    UIBezierPath* finalPath=[UIBezierPath bezierPath];
    [finalPath moveToPoint:CGPointMake(0, 0)];
    [finalPath addLineToPoint:CGPointMake(testVeiw.lj_width, 0)];
    [finalPath addQuadCurveToPoint:CGPointMake(testVeiw.lj_width/2, testVeiw.lj_height) controlPoint:CGPointMake(testVeiw.lj_width/2, 0)];
    [finalPath addLineToPoint:CGPointMake(testVeiw.lj_width/2, testVeiw.lj_height)];
    [finalPath addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(testVeiw.lj_width/2, 0)];
    
    CAShapeLayer* maskLayer=[CAShapeLayer layer];
    maskLayer.path=startPath.CGPath;
    testVeiw.layer.mask=maskLayer;
    
    CABasicAnimation* bezierAnimation=[CABasicAnimation animationWithKeyPath:@"path"];
    bezierAnimation.fromValue=(__bridge id)(startPath.CGPath);
    bezierAnimation.toValue=(__bridge id)(finalPath.CGPath);
    bezierAnimation.duration=3.35;
    bezierAnimation.fillMode=kCAFillModeForwards;
    bezierAnimation.removedOnCompletion=NO;
    bezierAnimation.beginTime=CACurrentMediaTime()+1.0f;
    
    
    CABasicAnimation* rotationXAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationXAnimation.fromValue=@(0);
    rotationXAnimation.toValue=@(M_PI_4/2);
    
    CABasicAnimation* rotationYAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationYAnimation.fromValue=@(0);
    rotationYAnimation.toValue=@(M_PI_4);
    
    CABasicAnimation* rotationZAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationZAnimation.fromValue=@(0);
    rotationZAnimation.toValue=@(M_PI_4/3);
    
    CABasicAnimation* scaleAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue=@1;
    scaleAnimation.toValue=@0.1;
    
    CABasicAnimation* scaleYAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleYAnimation.fromValue=@1;
    scaleYAnimation.toValue=@4;
    
    CABasicAnimation* offsetAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation"];
    offsetAnimation.fromValue=[NSValue valueWithCGPoint:testVeiw.frame.origin];
    offsetAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 360)];
    
    CAAnimationGroup* group=[CAAnimationGroup animation];
    group.animations=@[ rotationYAnimation, rotationXAnimation, rotationZAnimation];
    group.duration=3.35;
    group.fillMode=kCAFillModeForwards;
    group.removedOnCompletion=NO;
    group.beginTime=CACurrentMediaTime()+1.0f;
    
//    [testVeiw.layer.mask addAnimation:bezierAnimation forKey:@"bezier"];
    [testVeiw.layer addAnimation:group forKey:@"group"];
    
}

-(void)test2{
    
    CALayer* maskLayer=[CALayer layer];
    maskLayer.contents=(id)[UIImage imageNamed:@"products_comment_start_3"].CGImage;
    maskLayer.bounds=CGRectMake(0, 0, 30, 30);
    maskLayer.position=self.view.center;
    _loginImageView.layer.mask=maskLayer;
    
    
    CAKeyframeAnimation* keyAnimation=[CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    keyAnimation.duration=6.0f;
//    keyAnimation.beginTime=CACurrentMediaTime()+2.0f;
    keyAnimation.values=@[[NSValue valueWithCGRect:CGRectMake(0, 0, 30, 30)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 25, 25)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)],
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 2000, 2000)]];
    keyAnimation.keyTimes=@[@0, @0.08, @0.18, @0.28, @0.38, @0.48,
                            @0.58, @0.68, @0.78, @0.88, @1];
    keyAnimation.fillMode=kCAFillModeForwards;
    keyAnimation.removedOnCompletion=NO;
    keyAnimation.delegate=self;
    [_loginImageView.layer.mask addAnimation:keyAnimation forKey:@"mask"];
    
}
-(void)dealloc{
    NSLog(@"...VC... dealloc");
}
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"....开始了。。");
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        _loginImageView.layer.mask=nil;
    }
}

-(void)test1{
    TestView* view=[[TestView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH/2+100, IPHONE_HEIGHT)];
    view.backgroundColor=[[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    view.diff=-100;
    [self.view addSubview:view];
    [view setNeedsDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       view.diff=5;
                       [view setNeedsDisplay];
                   });
    
}

-(void)test{
    UIView* testView=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    testView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:testView];
    
//    testView.layer.backgroundFilters
    
    //CATransform3D 的数据结构定义一个同质的三维变换(4x4 CGFloat 值的矩阵),
    //用于 图层的旋转,缩放,偏移,歪斜和应用的透视
    CATransform3D aTransform=CATransform3DIdentity;
    aTransform.m34=1.0;
    
    testView.layer.transform=aTransform;
    
//    testView.layer.transform.rotation.x=0;  无法运行
    //rotation.x    rotation.y    rotation.z     rotation
    //scale.x       scale.y       scale.z        scale
    //translation.x translation.y translation.z  translation
    
    //size.width    size.height    origin.y      origin.x
    [testView.layer setValue:@(1) forKey:@"transform.rotation.x"];
    
    testView.layer.zPosition=0.3;
    
    
    CALayer* testLayer=[[CALayer alloc]init];
    testLayer.frame=CGRectMake(100, 100, 220, 90);
    testLayer.backgroundColor=[UIColor redColor].CGColor;
//    [self.view.layer addSublayer:testLayer];
    
    
    OvalLayer* circleLayer=[OvalLayer layer];
    circleLayer.frame=CGRectMake(120, 200, 200, 200);
    circleLayer.backgroundColor=[UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:circleLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                   {
                       circleLayer.currentRect=CGRectMake(40, 40, 80, 80);
                       [circleLayer setNeedsDisplay];
                   });
    
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35*NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//                   {
//                       //重载隐式动画的时间
//                       [CATransaction begin];
//                       [CATransaction setValue:@(2.0) forKey:kCATransactionAnimationDuration];
//                       testLayer.position=CGPointMake(100, 400);
//                       
//                       [CATransaction begin];
//                       [CATransaction setValue:@(4.0) forKey:kCATransactionAnimationDuration];
//                       testLayer.opacity=0.1;
//                       
//                       [CATransaction commit];
//                       [CATransaction commit];
//                   });
    
    
    CABasicAnimation* theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=6;
    
    theAnimation.autoreverses=YES; //设置为YES,旋转后再旋转到原来的位置
    theAnimation.fromValue=@(2.0);
    theAnimation.toValue=@(0.2);
    
    [testLayer addAnimation:theAnimation forKey:@"one"];
    
    /** 
     滤镜效果：
     CIAccordionFoldTransition,
     CIAdditionCompositing,
     CIAffineClamp,
     CIAffineTile,
     CIAffineTransform,
     CIAreaAverage,
     CIAreaHistogram,
     CIAreaMaximum,
     CIAreaMaximumAlpha,
     CIAreaMinimum,
     CIAreaMinimumAlpha,
     CIAztecCodeGenerator,
     CIBarsSwipeTransition,
     CIBlendWithAlphaMask,
     CIBlendWithMask,
     CIBloom,
     CIBoxBlur,
     CIBumpDistortion,
     CIBumpDistortionLinear,
     CICheckerboardGenerator,
     CICircleSplashDistortion,
     CICircularScreen,
     CICircularWrap,
     CICMYKHalftone,
     CICode128BarcodeGenerator,
     CIColorBlendMode,
     CIColorBurnBlendMode,
     CIColorClamp,
     CIColorControls,
     CIColorCrossPolynomial,
     CIColorCube,
     CIColorCubeWithColorSpace,
     CIColorDodgeBlendMode,
     CIColorInvert,
     CIColorMap,
     CIColorMatrix,
     CIColorMonochrome,
     CIColorPolynomial,
     CIColorPosterize,
     CIColumnAverage,
     CIComicEffect,
     CIConstantColorGenerator,
     CIConvolution3X3,
     CIConvolution5X5,
     CIConvolution7X7,
     CIConvolution9Horizontal,
     CIConvolution9Vertical,
     CICopyMachineTransition,
     CICrop,
     CICrystallize,
     CIDarkenBlendMode,
     CIDepthOfField,
     CIDifferenceBlendMode,
     CIDiscBlur,
     CIDisintegrateWithMaskTransition,
     CIDisplacementDistortion,
     CIDissolveTransition,
     CIDivideBlendMode,
     CIDotScreen,
     CIDroste,
     CIEdges,
     CIEdgeWork,
     CIEightfoldReflectedTile,
     CIExclusionBlendMode,
     CIExposureAdjust,
     CIFalseColor,
     CIFlashTransition,
     CIFourfoldReflectedTile,
     CIFourfoldRotatedTile,
     CIFourfoldTranslatedTile,
     CIGammaAdjust,
     CIGaussianBlur,
     CIGaussianGradient,
     CIGlassDistortion,
     CIGlassLozenge,
     CIGlideReflectedTile,
     CIGloom,
     CIHardLightBlendMode,
     CIHatchedScreen,
     CIHeightFieldFromMask,
     CIHexagonalPixellate,
     CIHighlightShadowAdjust,
     CIHistogramDisplayFilter,
     CIHoleDistortion,
     CIHueAdjust,
     CIHueBlendMode,
     CIKaleidoscope,
     CILanczosScaleTransform,
     CILenticularHaloGenerator,
     CILightenBlendMode,
     CILightTunnel,
     CILinearBurnBlendMode,
     CILinearDodgeBlendMode,
     CILinearGradient,
     CILinearToSRGBToneCurve,
     CILineOverlay,
     CILineScreen,
     CILuminosityBlendMode,
     CIMaskedVariableBlur,
     CIMaskToAlpha,
     CIMaximumComponent,
     CIMaximumCompositing,
     CIMedianFilter,
     CIMinimumComponent,
     CIMinimumCompositing,
     CIModTransition,
     CIMotionBlur,
     CIMultiplyBlendMode,
     CIMultiplyCompositing,
     CINoiseReduction,
     CIOpTile,
     CIOverlayBlendMode,
     CIPageCurlTransition,
     CIPageCurlWithShadowTransition,
     CIParallelogramTile,
     CIPDF417BarcodeGenerator,
     CIPerspectiveCorrection,
     CIPerspectiveTile,
     CIPerspectiveTransform,
     CIPerspectiveTransformWithExtent,
     CIPhotoEffectChrome,
     CIPhotoEffectFade,
     CIPhotoEffectInstant,
     CIPhotoEffectMono,
     CIPhotoEffectNoir,
     CIPhotoEffectProcess,
     CIPhotoEffectTonal,
     CIPhotoEffectTransfer,
     CIPinchDistortion,
     CIPinLightBlendMode,
     CIPixellate,
     CIPointillize,
     CIQRCodeGenerator,
     CIRadialGradient,
     CIRandomGenerator,
     CIRippleTransition,
     CIRowAverage,
     CISaturationBlendMode,
     CIScreenBlendMode,
     CISepiaTone,
     CIShadedMaterial,
     CISharpenLuminance,
     CISixfoldReflectedTile,
     CISixfoldRotatedTile,
     CISmoothLinearGradient,
     CISoftLightBlendMode,
     CISourceAtopCompositing,
     CISourceInCompositing,
     CISourceOutCompositing,
     CISourceOverCompositing,
     CISpotColor,
     CISpotLight,
     CISRGBToneCurveToLinear,
     CIStarShineGenerator,
     CIStraightenFilter,
     CIStretchCrop,
     CIStripesGenerator,
     CISubtractBlendMode,
     CISunbeamsGenerator,
     CISwipeTransition,
     CITemperatureAndTint,
     CIToneCurve,
     CITorusLensDistortion,
     CITriangleKaleidoscope,
     CITriangleTile,
     CITwelvefoldReflectedTile,
     CITwirlDistortion,
     CIUnsharpMask,
     CIVibrance,
     CIVignette,
     CIVignetteEffect,
     CIVortexDistortion,
     CIWhitePointAdjust,
     CIZoomBlur */
    CIFilter* filter=[CIFilter filterWithName:@"CIBloom"];
    [filter setDefaults];
    [filter setValue:@(20.0) forKey:@"inputRadius"];
    //    [filter setValue:@"pulseFilter" forKey:@"name"];
    
//    [testLayer setFilters:@[filter]];
//    NSArray* filtersName=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
//    NSLog(@"%@", filtersName);
    

    CABasicAnimation* pulseAnimation=[CABasicAnimation animationWithKeyPath:@"filters.bloom.inputRadius"];
    pulseAnimation.fromValue=@(0.0);
    pulseAnimation.toValue=@(5.5);
    pulseAnimation.duration=1.0;
    pulseAnimation.repeatCount=HUGE_VALF;
    pulseAnimation.autoreverses=YES;
    pulseAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [testLayer addAnimation:pulseAnimation forKey:@"pulse"];
    
    
    
    
    
    
}











@end
