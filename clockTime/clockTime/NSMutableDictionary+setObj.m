//
//  NSMutableDictionary+setObj.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "NSMutableDictionary+setObj.h"

@implementation NSMutableDictionary (setObj)

- (void)QD_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (anObject == nil) {
        return;
    }
    [self setObject:anObject forKey:aKey];
    
}

@end
