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

/**
 默认值为0，与实际使用情况相反

 @return 结果 0:有提示   1:无提示
 */
+ (BOOL)promptOn;

@end
