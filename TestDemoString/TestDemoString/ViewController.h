//
//  ViewController.h
//  TestDemoString
//
//  Created by LiJie on 2017/11/9.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestModel : NSObject

@property(nonatomic, strong)NSString* name;
@property(nonatomic, strong)NSString* age;

@end

@interface ViewController : UIViewController

@property(nonatomic, strong)void(^testHandler)(NSString* name);

-(void)addTest:(void(^)(NSString* name))handler;


@end

