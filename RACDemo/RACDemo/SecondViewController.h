//
//  SecondViewController.h
//  RACDemo
//
//  Created by celink on 15/10/9.
//  Copyright © 2015年 celink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSubject;

@interface SecondViewController : UIViewController

@property(nonatomic, strong)RACSubject* delegateSignal;

@end
