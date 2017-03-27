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
    
    if (target == oneDay) {//当前
        
        
        
    } else if (target == currentMonth) {//当月
        
        
        
    } else if (target == precedingMonth) {//上月
        
        
        
    }
    
    return timeRange;
    
}

+ (NSString *)stringForTimeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    return [dateFormatter stringFromDate:[NSDate date]];
    
}

@end
