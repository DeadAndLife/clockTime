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
+ (struct TimeRange)timeRangeWithtarget:(enum TimeScope)target;

+ (NSString *)stringForTimeStamp;

@end
