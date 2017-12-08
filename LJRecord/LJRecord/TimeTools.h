//
//  TimeTools.h
//  testJson
//
//  Created by gorson on 3/10/15.
//  Copyright (c) 2015 gorson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject


/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp;

/**
 *  获取当前标准时间（例子：2015-02-03）
 *
 *  @return 标准时间字符串型
 */
+ (NSString *)getCurrentStandarTime;

/**
 *  时间戳转换为时间的方法
 *
 *  @param timestamp 时间戳
 *
 *  @return 标准时间字符串
 */
+ (NSString *)timestampChangesStandarTime:(NSString *)timestam;

+ (NSString *)timestampChangesStandarTimeNoMinute:(NSString *)timestamp;

+ (NSString *)timestampChangesStandarTimeOnlyMouthAndDay:(NSString *)timestamp;


 //时间转换星期
+(NSString *)timeToweek:(NSString *)time;
@end
