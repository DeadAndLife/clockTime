//
//  NSString+timeStamp.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "QDCommon.h"

@interface NSString (timeStamp)

//target表示查询的范围，0:当天，1:当月，2:上月
//+ (TimeRange)timeRangeWithtarget:(TimeScope)target;

//今日@"YYYY-MM-dd HH:mm:ss"
+ (NSString *)stringForTimeStamp:(NSString *)dateFormat;

//时间戳字符串转化为dateFormat样式
- (NSString *)stringByTimeStamp:(NSString *)dateFormat;

/**
 日期格式转换

 @param goalFormat 目标格式
 @param sourceFormat 源格式
 @return 返回字符串
 */
- (NSString *)goalFormat:(NSString *)goalFormat sourceFormat:(NSString *)sourceFormat;

/**
 将double数据转化为HH:mm:ss格式
 
 @param timeInterval 源数据
 @return 结果
 */
+ (NSString *)timeStringForTimeInterval:(double)timeInterval;

/**
 HH:mm:ss格式的文本转化为时长

 @return 结果
 */
- (NSInteger)timeStampWithDateFormat;

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

/**
 某天是否为节假日，周一至周五请求假日，周末请求工作日

 @param oneDay 日期格式为YYYY-MM-dd
 @return 返回结果   yes为假日，no为工作日
 */
+ (BOOL)holidayForOneDay:(NSString *)oneDay;

@end
