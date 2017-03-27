//
//  QDModel.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDModel : NSObject

//签到时间
@property (nonatomic) NSInteger signInTime;

//签退时间
@property (nonatomic) NSInteger signOutTime;

//今日工作时长
@property (nonatomic) NSInteger workDuration;

//当前存休时长
@property (nonatomic) NSInteger vacationTime;

//理论下班时间
@property (nonatomic, copy) NSString *knockOffTime;

+ (instancetype)qiandaoModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
