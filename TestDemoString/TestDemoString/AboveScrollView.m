//
//  AboveScrollView.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/6.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "AboveScrollView.h"

@interface AboveScrollView()

@property(nonatomic, assign)CGPoint tempPoint;
@property(nonatomic, strong)UIEvent* event;

@end

@implementation AboveScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    
    __weak typeof(self) tempWeakSelf=self;
    [[NSNotificationCenter defaultCenter]addObserverForName:@"top" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@" offset ======%@", note.object);
        
        if (tempWeakSelf.contentOffset.y + [note.object floatValue] + self.bounds.size.height < self.contentSize.height) {
            tempWeakSelf.contentOffset = CGPointMake(0, tempWeakSelf.contentOffset.y + [note.object floatValue]);
        }
    }];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.backScrollView.contentOffset.y < 95) {
        self.tempPoint = point;
        self.event = event;
        return NO;
    }else if (self.backScrollView.contentOffset.y >= 99.5){
        //return YES;
    }
    
    BOOL isInside = [super pointInside:point withEvent:event];
    [self printLog:[NSString stringWithFormat:@"point:%@ Inside:%@", NSStringFromCGPoint(point), @(isInside)]];
    return isInside;
}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.backScrollView.contentOffset.y >= 99){
//        return nil;
//    }
//    UIView* hitView = [super hitTest:point withEvent:event];
//    return hitView;
//}
-(void)printLog:(NSString*)log{
    
    NSLog(@"%@====>>>%@ %p", log, NSStringFromClass([self class]), self);
}

@end






