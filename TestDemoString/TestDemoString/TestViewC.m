//
//  TestViewC.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/1.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "TestViewC.h"
#import "UIView+LJ.h"
@implementation TestViewC

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"...testView C Begin");
    if (self.enableNextResponder) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}


@end
