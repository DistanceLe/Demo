//
//  LJVolumeView.h
//  LJRecord
//
//  Created by LiJie on 16/5/26.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJVolumeView : UIView


+(instancetype)defaultVolumeView;

-(void)playRecord;
-(void)playRecordWithProgress:(CGFloat)progress;

-(void)stopPlay;


@end
