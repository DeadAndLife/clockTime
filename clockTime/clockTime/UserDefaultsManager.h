//
//  UserDefaultsManager.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/18.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManager : NSObject

+ (void)setLunchTime:(NSString *)lunchTime;

+ (void)setWorkTime:(NSString *)workTime;

+ (void)setPromptOn:(BOOL)promptOn;

+ (NSString *)lunchTime;

+ (NSString *)workTime;

+ (BOOL)promptOn;

@end
