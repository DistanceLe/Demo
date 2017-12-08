//
//  UIScrollView+LJRefresh.h
//  LJRefresh
//
//  Created by LiJie on 16/8/19.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshHeadBlock)();
typedef void(^RefreshFootBlock)();

@interface UIScrollView (LJRefresh)

-(void)addLJHeadRefresh:(RefreshHeadBlock)handler;

-(void)addLJFootRefresh:(RefreshFootBlock)handler;

-(void)beginHeadRefresh;
-(void)endLJRefresh;

@end
