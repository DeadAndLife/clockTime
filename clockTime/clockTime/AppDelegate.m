//
//  AppDelegate.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "AppDelegate.h"
#import "QDCommon.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dataBaseConfigure = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataBaseConfigure" ofType:@"plist"]];
    
    [QDDataBaseTool updateStatementsSql:@"drop table qiandao_temp;"
                         withParsmeters:nil
                                  block:^(BOOL isOk, NSString *errorMsg) {
                                      
                                      if (!isOk) {
//                                          finish = NO;
                                          NSLog(@"%@", errorMsg);
                                      }
                                      
                                  }];
    
    if (![userInfo stringForKey:@"dataBaseVersion"] || ![[userInfo stringForKey:@"dataBaseVersion"] isEqualToString:dataBaseConfigure[@"version"]]) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.activityIndicatorViewStyle =  UIActivityIndicatorViewStyleWhiteLarge;
        activityView.center = [UIApplication sharedApplication].keyWindow.center;
        
        [[UIApplication sharedApplication].keyWindow addSubview:activityView];
        
        [activityView startAnimating];
        
        NSArray *feildsArray = dataBaseConfigure[@"updateField"];
        
        dispatch_queue_t addFieldQueue = dispatch_queue_create("addField", NULL);
        
        __block BOOL finish = YES;
        
        NSString *newFieldsType = @"";
        NSString *newFields = @"";
        NSString *oldFields = @"";
        
        for (NSString *addString in feildsArray) {
            
            if ([addString isEqualToString:@"todayDate"]) {
                if ([feildsArray.firstObject isEqualToString:addString]) {
                    newFieldsType = @"todayDate text primary key";
                    newFields = @"'todayDate'";
                    oldFields = @"todayDate";
                } else {
                    newFieldsType = [newFieldsType stringByAppendingString:@"todayDate text primary key"];
                    newFields = [newFields stringByAppendingString:@"'todayDate'"];
                    oldFields = [oldFields stringByAppendingString:@"todayDate"];
                }
            } else {
            
                if ([addString hasPrefix:@"+"]) {
                    
                    NSString *newString = [addString substringWithRange:NSMakeRange(1, addString.length - 1)];
                    if ([feildsArray.firstObject isEqualToString:addString]) {
                        newFieldsType = [NSString stringWithFormat:@"%@ text", newString];
                    } else {
                        newFieldsType = [newFieldsType stringByAppendingString:[NSString stringWithFormat:@"%@ text", newString]];
                    }
                } else {
                    
                    if ([feildsArray.firstObject isEqualToString:addString]) {
                        newFieldsType = [NSString stringWithFormat:@"%@ text", addString];
                        newFields = [NSString stringWithFormat:@"'%@'", addString];
                        oldFields = addString;
                    } else {
                        newFieldsType = [newFieldsType stringByAppendingString:[NSString stringWithFormat:@"%@ text", addString]];
                        newFields = [newFields stringByAppendingString:[NSString stringWithFormat:@"'%@'", addString]];
                        oldFields = [oldFields stringByAppendingString:addString];
                    }
                }
                
            }
            
            if (![feildsArray.lastObject isEqualToString:addString]) {
                newFieldsType = [newFieldsType stringByAppendingString:@","];
                newFields = [newFields stringByAppendingString:@","];
                oldFields = [oldFields stringByAppendingString:@","];
            }
            
        }
        
        NSLog(@"%@", UPDATE_TABEL(newFieldsType, newFields, oldFields));
        
        dispatch_barrier_sync(addFieldQueue, ^{
            
            [QDDataBaseTool updateStatementsSql:UPDATE_TABEL(newFieldsType, newFields, oldFields)
                                 withParsmeters:nil
                                          block:^(BOOL isOk, NSString *errorMsg) {
                                              
                                              if (!isOk) {
                                                  finish = NO;
                                                  NSLog(@"%@", errorMsg);
                                              }
                                              
                                          }];
            
        });
        
        [activityView stopAnimating];
        
        if (finish) {
            [userInfo setValue:dataBaseConfigure[@"version"] forKey:@"dataBaseVersion"];
            NSLog(@"finish");
        } else {
            
        }
        
        
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
