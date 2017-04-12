//
//  QDModel.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QDModel.h"
#import "QDCommon.h"
#import "QDDataBaseTool.h"
#import "NSString+timeStamp.h"

@implementation QDModel

+ (instancetype)qiandaoModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _todayDate = dict[kTodayDate];
        _signInTime = dict[kSignInTime];
        _signOutTime = dict[kSignOutTime];
        _workDuration = dict[kWorkDuration];
        _vacationTime = dict[kVacationTime];
        _knockOffTime = dict[kKnockOffTime];
    }
    return self;
}

+ (instancetype)todayModelForNullAttributes {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringForTimeStamp:@"YYYY-MM-dd"] forKey:kTodayDate];
    [dict setValue:@"0" forKey:kSignInTime];
    [dict setValue:@"0" forKey:kSignOutTime];
    [dict setValue:@"0" forKey:kWorkDuration];
    [dict setValue:@"0" forKey:kVacationTime];
    [dict setValue:@"0" forKey:kKnockOffTime];
    
    return [self qiandaoModelWithDictionary:dict];
}

@end
