//
//  UserDefaultsManager.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/18.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QDCommon.h"

@implementation UserDefaultsManager

+ (void)setLunchTime:(NSString *)lunchTime {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setValue:lunchTime forKey:@"lunchTime"];
    
}

+ (void)setWorkTime:(NSString *)workTime {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setValue:workTime forKey:@"workTime"];
    
}

+ (void)setPromptOn:(BOOL)promptOn {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setBool:promptOn forKey:@"promptOn"];
    
}

+ (NSString *)lunchTime {
    
    NSString *lunchTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lunchTime"];
    
    if (lunchTime.length) {
        return lunchTime;
    }else {
        return @"01:30:00";
    }
    
}

+ (NSString *)workTime {
    
    NSString *workTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"workTime"];
    
    if (workTime.length) {
        return workTime;
    }else {
        return @"08:00:00";
    }
    
}

+ (BOOL)promptOn {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"promptOn"];
    
}

@end
