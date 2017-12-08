//
//  LJRefreshView.h
//  LJRefresh
//
//  Created by LiJie on 16/8/22.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJRefreshView : UIView

@property(nonatomic, assign)CGFloat refreshProgress;

-(void)refresh;
-(void)endRefresh;

@end
