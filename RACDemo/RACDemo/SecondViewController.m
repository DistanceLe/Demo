//
//  SecondViewController.m
//  RACDemo
//
//  Created by celink on 15/10/9.
//  Copyright © 2015年 celink. All rights reserved.
//

#import "SecondViewController.h"
//#import "RACEXTScope.h"
#import "ReactiveCocoa.h"



typedef void(^BlockMY)(NSInteger abc);


@interface SecondViewController ()

@property(nonatomic, strong)UITextField* textField;
@property (weak, nonatomic) IBOutlet UITextField *secondField;

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup aft∂er loading the view.
    
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    self.textField.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.textField];
    
     @weakify(self)
    //@try {} @catch (...) {} __attribute__((objc_ownership(weak))) __typeof__(self) self_weak_ = (self);
    
//    __weak typeof(self) tempWeakSelf=self;
    
//    @autoreleasepool {} __attribute__((objc_ownership(weak))) __typeof__(self) self_weak_ = (self);
//    
//    __attribute__((objc_ownership(weak))) typeof(self) tempWeakSelf=self;
    
    
//    [self.textField.rac_textSignal subscribeNext:^(id x)
//    {
//        @strongify(self)
////        __attribute__((objc_ownership(strong))) __typeof__(self) self = self_weak_;
//        self.view.backgroundColor=[UIColor orangeColor];
//        
//    }];
//    
//    [_secondField.rac_textSignal subscribeNext:^(id x) {
//       
//        self_weak_.view.backgroundColor=[UIColor greenColor];
//    }];
    
}
- (IBAction)buttonClick:(id)sender
{
    //通知第一个控制器，告诉他，按钮被点击了
    //通知代理
    //判断代理信号是否有值
    if (self.delegateSignal)
    {
        [self.delegateSignal sendNext:nil];
    }
}

-(void)dealloc
{
    NSLog(@"vc dealloc");
}

@end
