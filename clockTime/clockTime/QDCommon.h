//
//  QDCommon.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#ifndef QDCommon_h
#define QDCommon_h

#define QYScreenW [UIScreen mainScreen].bounds.size.width
#define QYScreenH [UIScreen mainScreen].bounds.size.height

typedef struct _TimeRange {
    NSInteger               minTime;//最小时间
    NSInteger               maxTime;//最大时间
}TimeRange;

typedef NS_ENUM(NSInteger, TimeScope) {
    oneDay,//当天信息
    yesterday,//昨天信息
    currentMonth,//本月信息
    precedingMonth,//上月信息
};

static NSString * const kTodayDate = @"todayDate";//签到时间
static NSString * const kSignInTime = @"signInTime";//签到时间
static NSString * const kSignOutTime = @"signOutTime";//签退时间
static NSString * const kWorkDuration = @"workDuration";//今日工作时长
static NSString * const kVacationTime = @"vacationTime";//当前存休时长
static NSString * const kKnockOffTime = @"knockOffTime";//理论下班时间

#endif /* QDCommon_h */
