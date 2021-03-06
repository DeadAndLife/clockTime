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

/**
 *  参数说明
 *
 *  @param  signInTime      签到时间
 *  @param  signOutTime     签退时间
 *  @param  workDuration    今日工作时长
 *  @param  vacationTime    当前存休时长
 *  @param  knockOffTime    理论下班时间
 *  
 *  version 1.0.1
 *  @param  isHoliday       是否节假日
 *
 */

//数据库名称
#define BaseFileName @"qiandao.db"

//创建表
#define createTabel @"CREATE table if not exists qiandao(todayDate text primary key,signInTime text,signOutTime text,workDuration text,vacationTime text, knockOffTime text, isHoliday text);"

//更新数据库
#define UPDATE_TABEL(newFieldsType, newFields, oldFields) [NSString stringWithFormat:@"ALTER TABLE qiandao RENAME TO qiandao_temp;\n%@\n%@\n DROP TABLE qiandao_temp;", [NSString stringWithFormat:@"CREATE table if not exists qiandao(%@) ;", (newFieldsType)], [NSString stringWithFormat:@"INSERT INTO qiandao (%@) SELECT %@ FROM qiandao_temp ;", (newFields), (oldFields)]]

//插入数据(重点为签到时间和理论下班时间)
#define INSERT_SQL @"INSERT INTO qiandao VALUES(:todayDate,:signInTime,:signOutTime,:workDuration,:vacationTime,:knockOffTime,:isHoliday)"

//更新数据(签退时间，工作时长，当前存休)
//#define UPDATE_SQL(todayDate) [NSString stringWithFormat:@"UPDATE qiandao SET VALUES(:signOutTime,:workDuration,:vacationTime) WHERE signInTime = '%@'", (todayDate)]
#define UPDATE_SQL(signOutTime, workDuration, vacationTime, isHoliday, todayDate) [NSString stringWithFormat:@"UPDATE qiandao SET signOutTime = '%@' , workDuration = '%@' , vacationTime = '%@' , isHoliday = '%@' WHERE todayDate = '%@'", (signOutTime), (workDuration), (vacationTime), (isHoliday), (todayDate)]

//查询所有的数据
#define SELECT_ALL(minValue, maxValue) [NSString stringWithFormat:@"SELECT * from qiandao WHERE signInTime BETWEEN %ld AND %ld", (minValue), (maxValue)]

#define SELECT_ALLDATA [NSString stringWithFormat:@"SELECT * from qiandao"]

#define SELECT_KEY(key) [NSString stringWithFormat:@"SELECT %@ from qiandao", (key)]

#define SELECT_TODAY(todayDate) [NSString stringWithFormat:@"SELECT * from qiandao WHERE todayDate = '%@'", (todayDate)]

#define SELECT_PREVIOUS(todayDate) [NSString stringWithFormat:@"SELECT * from qiandao WHERE todayDate < '%@' ORDER BY todayDate desc limit 1", (todayDate)]

#define SELECT_NEXT(todayDate) [NSString stringWithFormat:@"SELECT * from qiandao WHERE todayDate > '%@' limit 1", (todayDate)]

//删除数据
#define DELETE_SQL(minValue, maxValue) [NSString stringWithFormat:@"DELETE from qiandao WHERE todayDate BETWEEN '%@' AND '%@'", (minValue), (maxValue)]

//导出文件
#define EXPORT_FILE(filePath) [NSString stringWithFormat:@"SELECT * from qiandao INTO outfile '%@' fields terminated by ',' optionally enclosed by '\"' escaped by '\"' lines terminated by '\r\n'", (filePath)]

#endif /* DataBaseTool_h */
