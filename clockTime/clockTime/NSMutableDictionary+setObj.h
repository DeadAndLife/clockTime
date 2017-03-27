//
//  NSMutableDictionary+setObj.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (setObj)

- (void)QD_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
