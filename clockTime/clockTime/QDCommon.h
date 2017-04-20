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

/*随机色
 */
#define ranCol(alph) [UIColor colorWithRed:(arc4random() % 256) / 256.0 green:(arc4random() % 256) / 256.0 blue:(arc4random() % 256) / 256.0 alpha:alph]
/*R,G,B    请使用256色，即0~255
 * A            透明度，0~1
 */
#define colRGB(R,G,B,A) [UIColor colorWithRed:R / 256.0 green:G / 256.0 blue:B / 256.0 alpha:A]

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
