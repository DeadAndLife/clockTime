//
//  DataBaseTool.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef DataBaseTool_h
#define DataBaseTool_h

//签到时间
//@property (nonatomic) NSUInteger signInTime;
//签退时间
//@property (nonatomic) NSUInteger signOutTime;
//今日工作时长
//@property (nonatomic) NSUInteger workDuration;
//当前存休时长
//@property (nonatomic) NSUInteger vacationTime;
//理论下班时间
//@property (nonatomic, copy) NSString *knockOffTime;

//数据库名称
#define BaseFileName @"qiandao.db"

//创建表
#define createTabel @"CREATE table if not exists qiandao(signInTime intger,signOutTime intger,workDuration integer,vacationTime integer, knockOffTime text);"

//插入数据(重点为签到时间和理论下班时间)
#define INSERT_SQL @"INSERT INTO qiandao VALUES(:signInTime,:signOutTime,:workDuration,:vacationTime,:knockOffTime)"

//更新数据(签退时间，工作时长，当前存休)
#define UPDATE_SQL(signOutTime, workDuration, vacationTime) [NSString stringWithFormat:@"UPDATE qiandao SET signOutTime = %@ , workDuration = %@ , vacationTime = %@", (signOutTime), (workDuration), (vacationTime)]

//查询所有的数据
#define SELECT_ALL(minValue, maxValue) [NSString stringWithFormat:@"SELECT * from qiandao WHERE signInTime BETWEEN %@ AND %@", (minValue), (maxValue)]

//删除数据
#define DELETE_SQL(minValue, maxValue) [NSString stringWithFormat:@"DELETE from qiandao WHERE BETWEEN %@ AND %@", (minValue), (maxValue)]

#endif /* DataBaseTool_h */
