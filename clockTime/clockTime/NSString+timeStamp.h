//
//  NSString+timeStamp.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QDCommon.h"

@interface NSString (timeStamp)

//target表示查询的范围，0:当天，1:当月，2:上月
+ (TimeRange)timeRangeWithtarget:(TimeScope)target;

//今日@"YYYY-MM-dd HH:mm:ss"
+ (NSString *)stringForTimeStamp:(NSString *)dateFormat;

//时间戳字符串转化为dateFormat样式
- (NSString *)stringByTimeStamp:(NSString *)dateFormat;

/**
 计算工作时长

 @param stratStr 开始时间
 @param endStr 结束时间
 @return 工作时长
 */
+ (NSString *)workDurationBystartString:(NSString *)stratStr endString:(NSString *)endStr;

/**
 计算存休时长

 @param lastVacation 昨天的存休时长
 @param workDuration 今日工作时长
 @return 存休时长
 */
+ (NSString *)vacationTimeByLastVacation:(NSString *)lastVacation workDuration:(NSString *)workDuration;

- (NSString *)durationString;

@end
