//
//  BackScrollView.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/6.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "BackScrollView.h"

@implementation BackScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"Back   offsetY = %.2f", scrollView.contentOffset.y);
    if (self.contentOffset.y > 100) {
        if (self.aboveScrollView.contentOffset.y + (self.contentOffset.y - 100) + self.aboveScrollView.bounds.size.height < self.aboveScrollView.contentSize.height) {
            self.aboveScrollView.contentOffset = CGPointMake(0, self.aboveScrollView.contentOffset.y + (self.contentOffset.y - 100));
            self.contentOffset = CGPointMake(0, 100);
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"top" object:@(self.contentOffset.y - 100)];
        
    }
    
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//
//    if (self.contentOffset.y >= 99.5){
//        return NO;
//    }
//
//    BOOL isInside = [super pointInside:point withEvent:event];
//    return isInside;
//}
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.contentOffset.y >= 99.5){
//        return self.aboveScrollView;
//    }
//    UIView* hitView = [super hitTest:point withEvent:event];
//    return hitView;
//}




@end
