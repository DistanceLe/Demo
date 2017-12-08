//
//  ScrollViewController.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/6.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ScrollViewController.h"

#import "BackScrollView.h"
#import "AboveScrollView.h"

@interface ScrollViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *minLabel1;
@property (weak, nonatomic) IBOutlet UILabel *minLabel2;
@property (weak, nonatomic) IBOutlet UILabel *minLabel3;


@property (weak, nonatomic) IBOutlet BackScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet AboveScrollView *aboveScrollView;


@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label1.text = @"如果您的 Apple 设备需要维修，您可以前往 Apple Store 商店或授权服务提供商处。无论您选择哪种方式，我们都会确保您的设备能够恢复正常工作。";
    self.label2.text = @"某些假冒和第三方的电源适配器及电池可能设计不当，有可能会导致安全问题。为了确保您在电池更换时能够获得正品 Apple 电池，我们建议您前往 Apple Store 商店或 Apple 授权服务提供商处。如果您需要更换一个新的适配器来为您的 Apple 设备充电，我们建议您选择 Apple 的电源适配器。";
    
    self.minLabel1.text = @"AppleCare 产品可以为您提供额外保修与技术支持。如果您已经购买了 AppleCare 产品，可以在线进行管理。";
    self.minLabel2.text = @"有了 iPhone X，您的脸就是您的密码，您的照片将更加出彩。只需轻扫一下，一切即可完成。";
    self.minLabel1.text = @"我们随时提供帮助。Apple 认证维修由可信赖的专家进行，他们使用 Apple 原厂部件。只有 Apple 认证维修在 Apple 的保修服务范围内。立即发起维修请求，或滚动浏览以进一步了解 Apple 维修选项。";
    
    self.backScrollView.aboveScrollView = self.aboveScrollView;
    self.aboveScrollView.backScrollView = self.backScrollView;
    
}















@end
