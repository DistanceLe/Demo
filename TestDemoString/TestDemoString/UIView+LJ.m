//
//  UIView+LJ.m
//  TestDemoString
//
//  Created by LiJie on 2017/12/1.
//  Copyright © 2017年 LiJie. All rights reserved.
//

#import "UIView+LJ.h"

#import <objc/runtime.h>


@implementation UIView (LJ)

+(void)load{
    Method origin;
    Method custom;
//    origin = class_getInstanceMethod([UIView class], @selector(pointInside:withEvent:));
//    custom = class_getInstanceMethod([UIView class], @selector(lj_pointInside:withEvent:));
//    method_exchangeImplementations(origin, custom);
//
//    origin = class_getInstanceMethod([UIView class], @selector(hitTest:withEvent:));
//    custom = class_getInstanceMethod([UIView class], @selector(lj_hitTest:withEvent:));
//    method_exchangeImplementations(origin, custom);
    
//    origin = class_getInstanceMethod([self class], @selector(touchesBegan:withEvent:));
//    custom = class_getInstanceMethod([self class], @selector(lj_touchesBegan:withEvent:));
//    method_exchangeImplementations(origin, custom);
//
//    origin = class_getInstanceMethod([UIView class], @selector(touchesMoved:withEvent:));
//    custom = class_getInstanceMethod([UIView class], @selector(lj_touchesMoved:withEvent:));
//    method_exchangeImplementations(origin, custom);
//    
//    origin = class_getInstanceMethod([UIView class], @selector(touchesEnded:withEvent:));
//    custom = class_getInstanceMethod([UIView class], @selector(lj_touchesEnded:withEvent:));
//    method_exchangeImplementations(origin, custom);
}


-(BOOL)lj_pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL isInside = [self lj_pointInside:point withEvent:event];
    [self printLog:[NSString stringWithFormat:@"point:%@ Inside:%@", NSStringFromCGPoint(point), @(isInside)]];
    return isInside;
}

-(UIView *)lj_hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView* hitView = [self lj_hitTest:point withEvent:event];
    [self printLog:[NSString stringWithFormat:@"hitTest:%@", NSStringFromCGPoint(point)]];
    return hitView;
}


#pragma mark - ================ Touch ==================
-(void)lj_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self printLog:[NSString stringWithFormat:@"--begin, %p--%p", touches, event.allTouches]];
    UIResponder * next = [self nextResponder];
    NSMutableString * prefix = @"".mutableCopy;
    
    while (next != nil) {
        NSLog(@"\t\t\t\t\t%@%@", prefix, [next class]);
        [prefix appendString: @"--"];
        next = [next nextResponder];
    }
    [self lj_touchesBegan:touches withEvent:event];
}

-(void)lj_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self printLog:[NSString stringWithFormat:@"--moved, %p--%p", touches, event.allTouches]];
    [self lj_touchesMoved:touches withEvent:event];
}

-(void)lj_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self printLog:[NSString stringWithFormat:@"--end, %p--%p", touches, event.allTouches]];
    [self lj_touchesEnded:touches withEvent:event];
}
-(void)printLog:(NSString*)log{
    
    NSLog(@"%@====>>>%@ %p", log, NSStringFromClass([self class]), self);
}

#pragma mark - ================ enableNextResponder ==================
/**  是否让手势 向下响应 */
static NSString* enableNextResponderKey = @"enableNextResponderKey";

-(void)setEnableNextResponder:(BOOL)enableNextResponder {
    objc_setAssociatedObject(self, &enableNextResponderKey, enableNextResponderKey, OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)enableNextResponder {
    return objc_getAssociatedObject(self, &enableNextResponderKey);
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (self.enableNextResponder) {
//        [[self nextResponder] touchesBegan:touches withEvent:event];
//    }
//    [super touchesBegan:touches withEvent:event];
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.enableNextResponder) {
//        [[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//    [super touchesEnded:touches withEvent:event];
//}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.enableNextResponder) {
//        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//    [super touchesMoved:touches withEvent:event];
//}
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.enableNextResponder) {
//        [[self nextResponder] touchesCancelled:touches withEvent:event];
//    }
//    [super touchesCancelled:touches withEvent:event];
//}

@end


@implementation UIViewController (LJ)

- (void)lj_touchesBegan: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event
{
    [self printLog:[NSString stringWithFormat:@"--begin, %p--%p", touches, event.allTouches]];
}

- (void)lj_touchesMoved: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event
{
    [self printLog:[NSString stringWithFormat:@"--moved, %p--%p", touches, event.allTouches]];
}

- (void)lj_touchesEnded: (NSSet<UITouch *> *)touches withEvent: (UIEvent *)event
{
    [self printLog:[NSString stringWithFormat:@"--end, %p--%p", touches, event.allTouches]];
}

-(void)printLog:(NSString*)log{
    
    //NSLog(@"%@||||>>>%@", log, NSStringFromClass([self class]));
}

@end
