//
//  QDModel.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDModel : NSObject

//日期    YYYY-MM-dd
@property (nonatomic, copy) NSString *todayDate;

//签到时间
@property (nonatomic, copy) NSString *signInTime;

//签退时间
@property (nonatomic, copy) NSString *signOutTime;

//今日工作时长
@property (nonatomic, copy) NSString *workDuration;

//当前存休时长
@property (nonatomic, copy) NSString *vacationTime;

//理论下班时间
@property (nonatomic, copy) NSString *knockOffTime;

//是否节假日
@property (nonatomic, copy) NSString *isHoliday;

+ (instancetype)qiandaoModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)todayModelForNullAttributes;

@end
