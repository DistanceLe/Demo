//
//  RecordListTableViewCell.h
//  LJRecord
//
//  Created by LiJie on 16/5/20.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordListTableViewCell : UITableViewCell

@property(nonatomic, strong)NSTimer* timer;
@property(nonatomic, assign)CGFloat recordTime;
@property(nonatomic, assign)CGFloat currentRecordTime;

-(void)startPlay;
-(void)stopPlay;

@end
