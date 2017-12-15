//
//  ViewController.m
//  TestDemoString
//
//  Created by LiJie on 2017/11/9.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import "TestButton.h"
#import "TestViewC.h"

#import "UIView+LJ.h"
#import "JSWave.h"


#import "LJGif.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@implementation TestModel

@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet TestButton *testButton;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gifImageView;


@end





@implementation ViewController

//求N的阶乘，递归
-(long)factorialWithN:(NSInteger)n{
    if (n == 1 || n == 0) {
        return 1;
    }
    return [self factorialWithN:n-1]*n;
}
- (IBAction)buttonClick:(UIButton *)sender {
    NSLog(@"click --------->");
    [LJGif getGifImage];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    self.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:fileURL]];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"...click==========>");
    [self.view endEditing:YES];//结束编辑
}

-(void)testViewTap:(UITapGestureRecognizer*)tap{
    NSLog(@"====testViewTap!!!!!!!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    return;
    UIButton* but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(0, 150, 100, 100);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"but" forState:UIControlStateNormal];
    [self.view addSubview:but];
    
    
    //NSLog(@"...factorial: %ld", [self factorialWithN:10]);
    
//    self.scrollView.enableNextResponder = YES;
//    self.testViewC.enableNextResponder = YES;
    //self.testButton.enableNextResponder = YES;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(testViewTap:)];
//    [self.testViewC addGestureRecognizer:tap];
    
    
    
    NSMutableDictionary* mutableDic = [NSMutableDictionary dictionary];
    TestModel* model = [[TestModel alloc]init];
    
    [mutableDic setValue:model forKey:@"model"];
    model.name = @"xiaoming";
    model.age = @"12";
    NSLog(@"...%@", [mutableDic[@"model"] valueForKey:@"name"]);
    
//    TestModel* temp = mutableDic[@"model"];
    
    self.contentLabel.text = @"算了\n郑文杰  16:02:41\n不能 IB 都是渣渣\n郑文杰  16:02:43\n不搞了";
    
    
    
    JSWave* waveView = [[JSWave alloc]initWithFrame:CGRectMake(0, 80, 320, 80)];
    waveView.waveCurvature = 2;
    waveView.waveSpeed = 3;
    waveView.waveHeight = 16;
    [self.view addSubview:waveView];
    [waveView startWaveAnimation];
    
    
    
    
    
    NSString* string1 = @"abcdef";
    NSString* string2 = [string1 copy];
    
    NSLog(@"%p, %p", &string1, &string2);
    
    string2 = @"1234";
    NSLog(@"%@  %@", string1, string2);
    NSLog(@"%p, %p", &string1, &string2);
    
    
    NSMutableString* mutableString1 = [string1 mutableCopy];
    NSLog(@"%p, %p", &string1, &mutableString1);
    
    [mutableString1 appendString:@"123"];
    NSLog(@"%@  %@", string1, mutableString1);
    NSLog(@"%p, %p", &string1, &mutableString1);
    NSLog(@"%@ %@", NSStringFromClass([string1 class]), NSStringFromClass([string2 class]));
    
    NSMutableString* mutableString2 = [mutableString1 mutableCopy];
    
    NSLog(@"%@ %@", NSStringFromClass([mutableString1 class]), NSStringFromClass([mutableString2 class]));
    NSLog(@"%p, %p", &mutableString1, &mutableString2);
    
    NSMutableString* mutableString3 = [NSMutableString stringWithString:@"11111"];
    NSLog(@"%@", NSStringFromClass([mutableString3 class]));
}





@end
