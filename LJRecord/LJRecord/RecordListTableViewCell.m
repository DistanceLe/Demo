//
//  RecordListTableViewCell.m
//  LJRecord
//
//  Created by LiJie on 16/5/20.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "RecordListTableViewCell.h"

@implementation RecordListTableViewCell
{
    CGFloat currentTime;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(NSTimer*)timer
{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

-(void)setCurrentRecordTime:(CGFloat)currentRecordTime
{
    if (currentRecordTime==0) {
        _currentRecordTime=0;
        if (currentTime>0) {
            [self stopPlay];
        }
    }else{
        _currentRecordTime=currentRecordTime;
        [self startPlay];
        currentTime=_currentRecordTime;
    }
}

-(void)startPlay
{
    self.timer.fireDate=[NSDate distantPast];
    currentTime=0;
}

-(void)stopPlay
{
    self.timer.fireDate=[NSDate distantFuture];
    self.detailTextLabel.text=[NSString stringWithFormat:@"%.1f s ",_recordTime];
}

-(void)timerAction
{
    self.detailTextLabel.text=[NSString stringWithFormat:@"%.1f s / %.1f s",_recordTime, currentTime];
    ++currentTime;
    if (currentTime-1>_recordTime) {
        self.timer.fireDate=[NSDate distantFuture];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7*NSEC_PER_SEC)), dispatch_get_main_queue(), ^
       {
           self.detailTextLabel.text=[NSString stringWithFormat:@"%.1f s ",_recordTime];
       });
    }
    if (currentTime>_recordTime) {
        currentTime=_recordTime+0.001;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
