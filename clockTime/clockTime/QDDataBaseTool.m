//
//  QDDataBaseTool.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QDDataBaseTool.h"
#import "FMDB.h"

//静态变量
static FMDatabaseQueue *queue;

@implementation QDDataBaseTool

+(NSString *)getFilePath{
    //docmuents 目录
    NSString *docmuentsPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docmuentsPath stringByAppendingPathComponent:BaseFileName];
}
//获取数据库对象
+(FMDatabaseQueue *)getFMDataBase{
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //只会调用一次
    //创建数据库对象
    
    if (!queue) {
        
        queue=[FMDatabaseQueue databaseQueueWithPath:[QDDataBaseTool getFilePath]];
        NSLog(@"%@",[QDDataBaseTool getFilePath]);
        //创建表
        [QDDataBaseTool createTable];
    }
    //    });
    
    return queue;
}

+(void)createTable{
    
    [[QDDataBaseTool getFMDataBase]inDatabase:^(FMDatabase *db) {
        //创建表 执行多条sql语句
        if ([db executeStatements:createTabel]) {
            //          NSLog(@"====create oke");
        } ;
    }];
}

+(void)updateStatementsSql:(NSString *)sql withParsmeters:(NSDictionary *)pars block:(callFiniseh)block{
    [[QDDataBaseTool getFMDataBase]inDatabase:^(FMDatabase *db) {
        if (pars) {
            //执行带参数
            block([db executeUpdate:sql withParameterDictionary:pars],[db lastErrorMessage]);
        }else{
            block([db executeUpdate:sql],[db lastErrorMessage]);
        }
    }];
}

+(void)selectStatementsSql:(NSString *)sql withParsmeters:(NSDictionary *)pars forMode:(NSString *)modeName block:(callResult)block{
    [[QDDataBaseTool getFMDataBase]inDatabase:^(FMDatabase *db) {
        //1.声明FMResultSet
        FMResultSet *set;
        if(pars){
            set=[db executeQuery:sql withParameterDictionary:pars];
        }else{
            set=[db executeQuery:sql];
        }
        //2.取结果
        NSMutableArray *dataArr=[NSMutableArray array];
        while ([set next]) {
            
            if (modeName) {
                //字典转mode
                NSObject *objc=[NSClassFromString(modeName) new];
                //kvc
                [objc setValuesForKeysWithDictionary:[set resultDictionary]];
                
                [dataArr addObject:objc];
            }else{
                //结果存放成字典
                [dataArr addObject:[set resultDictionary]];
            }
        }
        
        //回调
        block(dataArr,[db lastErrorMessage]);
    }];
}

@end
