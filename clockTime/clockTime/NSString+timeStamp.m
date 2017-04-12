//
//  NSString+timeStamp.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "NSString+timeStamp.h"

@implementation NSString (timeStamp)


+ (TimeRange)timeRangeWithtarget:(TimeScope)target {
    
    TimeRange timeRange;
    
    NSString *dateString = [NSString stringForTimeStamp:@"YYYY-MM-dd HH:mm:ss"];
    
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
        
    } else {//上月
        
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

+ (NSString *)stringForTimeStamp:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    
    return [dateFormatter stringFromDate:[NSDate date]];
    
}

- (NSString *)stringByTimeStamp:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    return [dateFormatter stringFromDate:date];
    
}

- (NSString *)goalFormat:(NSString *)goalFormat sourceFormat:(NSString *)sourceFormat {
    
    NSDateFormatter *goalFormatter = [[NSDateFormatter alloc] init];
    goalFormatter.dateFormat = goalFormat;
    
    NSDateFormatter *sourceFormatter = [[NSDateFormatter alloc] init];
    sourceFormatter.dateFormat = sourceFormat;
    
    NSDate *date = [sourceFormatter dateFromString:self];
    
    return [goalFormatter stringFromDate:date];
    
}

- (NSInteger)timeStampWithDateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    
    NSArray *timeArr = [timeStamp componentsSeparatedByString:@":"];
    
    NSInteger hour = [timeArr[0] integerValue];
    NSInteger minute = [timeArr[1] integerValue];
    NSInteger second = [timeArr[2] integerValue];
    
    return hour * 60 * 60 + minute * 60 + second;
    
}

+ (NSString *)workDurationBystartString:(NSString *)stratStr endString:(NSString *)endStr {
    
    NSInteger stratTime = [stratStr timeStampWithDateFormat];
    NSInteger endTime = [endStr timeStampWithDateFormat];
    
    if (stratTime < 12 * 60 * 60 && endTime > 12 * 60 * 60) {//签到在上午且签退在下午，需扣除午休时间
        
        //减去午休时长
        NSUInteger siestaTime = 90 * 60;
        return [NSString stringWithFormat:@"%0ld", (endTime - stratTime - siestaTime)];
        
    } else {
    
        return [NSString stringWithFormat:@"%0ld", (endTime - stratTime)];
        
    }
    
}

+ (NSString *)vacationTimeByLastVacation:(NSString *)lastVacation workDuration:(NSString *)workDuration {
        
    return [NSString stringWithFormat:@"%0f", lastVacation.doubleValue + workDuration.doubleValue - 28800.0f];

}

- (NSString *)durationString {
    
    NSInteger duration = self.integerValue;
    if (duration < 0) {
        duration = duration * -1;
    }
    
    NSInteger second = duration % 60;
    NSInteger minute = duration / 60 % 60;
    NSInteger hour = duration / 60 / 60;
    
    return self.integerValue < 0 ? [NSString stringWithFormat:@"-%ld:%02ld:%02ld", hour, minute, second] : [NSString stringWithFormat:@"%ld:%02ld:%02ld", hour, minute, second];
    
}

@end
