//
//  LJVolumeView.m
//  LJRecord
//
//  Created by LiJie on 16/5/26.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJVolumeView.h"

//动态获取设备高度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
//动态获取设备宽度
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_WIDTH  100

@interface LJVolumeView ()

@property(nonatomic, strong)UIView*      backVolumeView;
@property(nonatomic, strong)UIImageView* backGround;
@property(nonatomic, strong)UIImageView* volumeImageView;
@property(nonatomic, strong)NSTimer*     timer;


@end

@implementation LJVolumeView

+(instancetype)defaultVolumeView
{
    
    static LJVolumeView* tempView=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempView=[[LJVolumeView alloc]initWithFrame:CGRectMake((IPHONE_WIDTH-VIEW_WIDTH)/2, (IPHONE_HEIGHT-VIEW_WIDTH)/2, VIEW_WIDTH, VIEW_WIDTH)];
        [tempView initUI];
        tempView.hidden=YES;
        [[[[UIApplication sharedApplication]delegate]window] addSubview:tempView];
    });
    return tempView;
}

-(NSTimer*)timer
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(timerActive) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)initUI
{
    _backGround=[[UIImageView alloc]initWithFrame:self.bounds];
    _volumeImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    _backGround.image=[UIImage imageNamed:@"volumeBackGround"];
    _volumeImageView.image=[UIImage imageNamed:@"volume"];
    
    _backVolumeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH/2, VIEW_WIDTH)];
    _backVolumeView.clipsToBounds=YES;
    _backVolumeView.backgroundColor=[UIColor clearColor];
    [_backVolumeView addSubview:_volumeImageView];
    
    [self addSubview:_backGround];
    [self addSubview:_backVolumeView];
}

-(void)playRecord
{
    self.timer.fireDate=[NSDate distantPast];
}
-(void)playRecordWithProgress:(CGFloat)progress
{
    self.hidden=NO;
    [UIView animateWithDuration:0.35 animations:^{
        CGRect tempFrame=self.bounds;
        tempFrame.size.width=progress* VIEW_WIDTH*4/5+VIEW_WIDTH*1/5;
        self.backVolumeView.frame=tempFrame;
    }];
}

-(void)stopPlay
{
    self.timer.fireDate=[NSDate distantFuture];
    self.hidden=YES;
}

-(void)timerActive
{
    CGFloat progress=arc4random()%100/100.0f;
    [self playRecordWithProgress:progress];
}

@end
