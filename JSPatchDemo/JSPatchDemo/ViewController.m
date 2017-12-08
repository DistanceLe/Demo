//
//  ViewController.m
//  JSPatchDemo
//
//  Created by LiJie on 2017/2/8.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import <JSPatchPlatform/JSPatch.h>

#define var __auto_type

@interface ViewController ()

@property(nonatomic, assign)NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**  在线参数功能与 JSPatch 脚本下发功能独立，互不影响。
     在线参数的计费方式同样按请求次数计算，每调用一次 +updateConfigWithAppKey: 方法算一次请求。 */
    
    //以下是在线参数：
    
    //会在此处发请求获取刚才设置的在线参数
    [JSPatch updateConfigWithAppKey:@"5ee592994bd95ff4"];
    
    //请求返回时进行一些操作
    [JSPatch setupUpdatedConfigCallback:^(NSDictionary *configs, NSError *error) {
        
    }];
    
    
    //var name = @"";
    
    
    
    //获取成功后，可以通过 +getConfigParams 拿到所有参数，
    //也可以通过 +getConfigParam: 接口拿到单个参数
    NSDictionary* configs = [JSPatch getConfigParams];
    NSString* name = [JSPatch getConfigParam:@"name"];
    NSLog(@"..name = %@, \n%@", name, configs);
}




- (IBAction)click:(UIButton *)sender {
    
    self.index = self.index + 1;
    NSString* text = [@(self.index) stringValue];
    
    [sender setTitle:text forState:UIControlStateNormal];
    
    
}





@end
