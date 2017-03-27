//
//  QDCommon.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#ifndef QDCommon_h
#define QDCommon_h

struct TimeRange {
    NSInteger               minTime;
    NSInteger               maxTime;
};

enum TimeScope {
    oneDay,
    currentMonth,
    precedingMonth
};

static NSString * const kSignInTime = @"signInTime";//签到时间
static NSString * const kSignOutTime = @"signOutTime";//签退时间
static NSString * const kWorkDuration = @"workDuration";//今日工作时长
static NSString * const kVacationTime = @"vacationTime";//当前存休时长
static NSString * const kKnockOffTime = @"knockOffTime";//理论下班时间

#endif /* QDCommon_h */
