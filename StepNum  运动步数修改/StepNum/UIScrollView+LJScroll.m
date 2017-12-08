//
//  UIScrollView+LJScroll.m
//  StepNum
//
//  Created by LiJie on 2016/9/26.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "UIScrollView+LJScroll.h"


@implementation UIScrollView (LJScroll)

-(void)scrollToBottomAnimation:(BOOL)animation{
    CGFloat contentHeight=self.contentSize.height;
    CGFloat height=self.frame.size.height;
    
    CGFloat contentWidth=self.contentSize.width;
    CGFloat width=self.frame.size.width;
    
    if (contentHeight>height) {
        [self setContentOffset:CGPointMake(0, contentHeight-height) animated:animation];
    }
    if (contentWidth>width) {
        [self setContentOffset:CGPointMake(contentWidth-width, 0) animated:animation];
    }
}

@end
