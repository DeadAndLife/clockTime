//
//  NSString+timeStamp.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "NSString+timeStamp.h"

@implementation NSString (timeStamp)


+ (struct TimeRange)timeRangeWithtarget:(enum TimeScope)target {
    
    struct TimeRange timeRange;
    
    NSString *dateString = [NSString stringForTimeStamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    if (target == oneDay) {//当天
        
        NSString *calendar = [dateString componentsSeparatedByString:@" "][0];
        
        NSString *todayBegin = [calendar stringByAppendingString:@" 00:00:00"];
        NSDate *beginDate = [dateFormatter dateFromString:todayBegin];
        NSString *todayEnd = [calendar stringByAppendingString:@" 23:59:59"];
        NSDate *endDate = [dateFormatter dateFromString:todayEnd];
        
        timeRange.minTime = beginDate.timeIntervalSince1970;
        timeRange.maxTime = endDate.timeIntervalSince1970;
        
    } else if (target == yesterday) {//昨天
      
        NSString *calendar = [dateString componentsSeparatedByString:@" "][0];
        
        NSArray *calendarArr = [calendar componentsSeparatedByString:@"-"];
        
        if ([calendarArr[2] isEqualToString:@"01"] || [calendarArr[2] isEqualToString:@"1"]) {//为每月第一天时
            
            NSString *todayBegin = [calendar stringByAppendingString:@" 00:00:00"];
            NSDate *beginDate = [dateFormatter dateFromString:todayBegin];
            NSString *todayEnd = [calendar stringByAppendingString:@" 23:59:59"];
            NSDate *endDate = [dateFormatter dateFromString:todayEnd];
            
            timeRange.minTime = beginDate.timeIntervalSince1970;
            timeRange.maxTime = endDate.timeIntervalSince1970;
            
        } else {
            
            NSUInteger yesterday = [calendarArr[2] integerValue] - 1;
            
            NSString *yesterDay = [NSString stringWithFormat:@"%@-%@-%ld", calendarArr[0], calendarArr[1], yesterday];
            
            NSString *yesterdayBegin = [yesterDay stringByAppendingString:@" 00:00:00"];
            NSDate *beginDate = [dateFormatter dateFromString:yesterdayBegin];
            NSString *yesterdayEnd = [yesterDay stringByAppendingString:@" 23:59:59"];
            NSDate *endDate = [dateFormatter dateFromString:yesterdayEnd];
            
            timeRange.minTime = beginDate.timeIntervalSince1970;
            timeRange.maxTime = endDate.timeIntervalSince1970;
            
        }
        
        
    } else if (target == currentMonth) {//当月
        
        NSString *calendar = [dateString componentsSeparatedByString:@" "][0];
        
        NSArray *calendarArr = [calendar componentsSeparatedByString:@"-"];
        
        NSString *currentMonth = [NSString stringWithFormat:@"%@-%@", calendarArr[0], calendarArr[1]];
            
        NSString *monthBegin = [currentMonth stringByAppendingString:@"-01 00:00:00"];
        NSDate *beginDate = [dateFormatter dateFromString:monthBegin];
        
        NSDate *endDate;
        
        NSInteger month = [calendarArr[1] integerValue];
        
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month ==12) {
            
            NSString *monthEnd = [currentMonth stringByAppendingString:@"-31 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            
            NSString *monthEnd = [currentMonth stringByAppendingString:@"-30 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        } else {
            
            NSString *monthEnd = [currentMonth stringByAppendingString:@"-28 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        }

        timeRange.minTime = beginDate.timeIntervalSince1970;
        timeRange.maxTime = endDate.timeIntervalSince1970;
        
    } else if (target == precedingMonth) {//上月
        
        NSString *calendar = [dateString componentsSeparatedByString:@" "][0];
        
        NSArray *calendarArr = [calendar componentsSeparatedByString:@"-"];
        
        NSString *precedingMonth;
        
        NSInteger month = [calendarArr[1] integerValue];
        
        if (month == 1) {//本月为1月，获取去年12月的
            
            precedingMonth = [NSString stringWithFormat:@"%ld-%@", [calendarArr[0] integerValue] - 1, @"12"];
            
            month = 12;
            
        } else {
            
            precedingMonth = [NSString stringWithFormat:@"%@-%ld", calendarArr[0], --month];
            
        }
        
        NSString *monthBegin = [precedingMonth stringByAppendingString:@"-01 00:00:00"];
        NSDate *beginDate = [dateFormatter dateFromString:monthBegin];
        
        NSDate *endDate;
        
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month ==12) {
            
            NSString *monthEnd = [precedingMonth stringByAppendingString:@"-31 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            
            NSString *monthEnd = [precedingMonth stringByAppendingString:@"-30 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        } else {
            
            NSString *monthEnd = [precedingMonth stringByAppendingString:@"-28 23:59:59"];
            endDate = [dateFormatter dateFromString:monthEnd];
            
        }
        
        timeRange.minTime = beginDate.timeIntervalSince1970;
        timeRange.maxTime = endDate.timeIntervalSince1970;
        
    }
    
    return timeRange;
    
}

+ (NSString *)stringForTimeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:[NSDate date]];
    
}

@end
