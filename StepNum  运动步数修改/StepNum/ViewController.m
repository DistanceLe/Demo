//
//  ViewController.m
//  StepNum
//
//  Created by LiJie on 2016/9/26.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
#import "UIScrollView+LJScroll.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *stepTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property(nonatomic, strong)HKHealthStore* healthStore;
@property(nonatomic, strong)NSString* contentStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthStore=[[HKHealthStore alloc]init];
    [self addObserver:self forKeyPath:@"contentStr" options:NSKeyValueObservingOptionNew context:nil];
    
    
    HKQuantityType* stepCountType=[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet* writeDataTypes=[NSSet setWithObjects:stepCountType, nil];
    [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:nil completion:^(BOOL success, NSError * _Nullable error) {
        NSString* infoStr=nil;
        if (success) {
            infoStr=@"获取权限成功!\n";
        }else{
            infoStr=@"获取权限失败!!!\n";
        }
        self.contentStr=infoStr;
    }];
}

- (IBAction)addTap:(id)sender {
    __block NSString* infoStr=nil;
    if ([self.stepTextField.text longLongValue]>0) {
        NSInteger step=[self.stepTextField.text integerValue];
        //数据看类型为步数.
        HKQuantityType *quantityTypeIdentifier = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        
        //表示步数的数据单位的数量
        HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:step];
        
        //数量样本.
        HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType:quantityTypeIdentifier
                                                                              quantity:quantity
                                                                             startDate:[NSDate date]
                                                                               endDate:[NSDate date] metadata:nil];
        
        //保存
        [self.healthStore saveObject:temperatureSample withCompletion:^(BOOL success, NSError *error) {
            if (success) {
                //保存成功
                infoStr=[NSString stringWithFormat:@"❤️已增加了 %ld个步数到健康数据中\n", step];
            }else {
                //保存失败
                infoStr=[NSString stringWithFormat:@"💔增加 %ld个步数到健康数据中失败\n", step];
            }
            self.contentStr=infoStr;
        }];
    }else{
        infoStr=@"步数输入错误!!!\n";
        self.contentStr=infoStr;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentStr"]) {
        NSString* newStr=[change valueForKey:NSKeyValueChangeNewKey];
        NSMutableString *textViewStr=[NSMutableString stringWithString:self.contentTextView.text];
        [textViewStr appendString:newStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentTextView.text=textViewStr;
            [self.contentTextView scrollToBottomAnimation:YES];
        });
    }
}


@end
