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

@implementation QDModel

+ (instancetype)qiandaoModelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _signInTime = [dict[kSignInTime] integerValue];
        _signOutTime = [dict[kSignOutTime] integerValue];
        _workDuration = [dict[kWorkDuration] integerValue];
        _vacationTime = [dict[kVacationTime] integerValue];
        _knockOffTime = dict[kKnockOffTime];
    }
    return self;
}

@end
