//
//  ViewController.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "QDDataBaseTool.h"
#import "QDModel.h"
#import "QDCommon.h"
#import "NSString+timeStamp.h"

#define todayRange [NSString timeRangeWithtarget:oneDay]

#define yesterdayRange [NSString timeRangeWithtarget:yesterday]

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@property (weak, nonatomic) IBOutlet UILabel *vacationTimeLabel;
//今日记录
@property (nonatomic, strong) QDModel *todayModel;
//昨日记录
@property (nonatomic, strong) QDModel *yesterdayModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signOutButton addTarget:self action:@selector(signOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self vacationTimeInit];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self dataBaseInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据库相关
- (void)dataBaseInit {
    
    [self yesterdayModelInit];
    [self todayModelInit];

    
}

- (void)todayModelInit {
    
    __weak typeof(self) weakSelf = self;
    
    TimeRange timeRange = todayRange;
    
    [QDDataBaseTool selectStatementsSql:SELECT_ALL(timeRange.minTime, timeRange.maxTime)
                         withParsmeters:nil
                                forMode:@"QDModel"
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                      
                                      if (resposeObjc.count) {
                                          
                                          weakSelf.todayModel = resposeObjc[0];
                                          
                                          if (weakSelf.todayModel.signInTime) {
                                              
                                              weakSelf.signInButton.enabled = NO;
                                              
                                              [weakSelf.signInButton setTitle:[NSString stringWithFormat:@"已签到\n%@", [weakSelf.todayModel.signInTime stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateDisabled];
                                              [weakSelf.signInButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                                              [weakSelf.signInButton.titleLabel setNumberOfLines:2];
                                              
                                          }
                                          
                                          if (weakSelf.todayModel.signOutTime) {
                                              
                                              [weakSelf.signOutButton setTitle:[NSString stringWithFormat:@"已签退\n%@", [weakSelf.todayModel.signOutTime stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateNormal];
                                              [weakSelf.signOutButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                                              [weakSelf.signOutButton.titleLabel setNumberOfLines:2];
                                              
                                              if (_todayModel.vacationTime.doubleValue <= 0) {
                                                  weakSelf.vacationTimeLabel.textColor = [UIColor redColor];
                                              } else {
                                                  weakSelf.vacationTimeLabel.textColor = [UIColor greenColor];
                                              }
                                              weakSelf.vacationTimeLabel.text = [_todayModel.vacationTime durationString];
                                              
                                          }
                                          
                                      } else {
                                          
                                          NSLog(@"%@", errorMsg);
                                          
                                      }
                                      
                                  }];
    
}

- (void)yesterdayModelInit {
    
    __weak typeof(self) weakSelf = self;
    
    TimeRange timeRange = yesterdayRange;
    
    [QDDataBaseTool selectStatementsSql:SELECT_ALL(timeRange.minTime, timeRange.maxTime)
                         withParsmeters:nil
                                forMode:@"QDModel"
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                      
                                      if (resposeObjc.count) {
                                          
                                          weakSelf.yesterdayModel = resposeObjc[0];
                                          [weakSelf vacationTimeInit];

                                      } else {
                                          
                                          NSLog(@"%@", errorMsg);
                                          
                                      }
                                      
                                  }];
    
}

#pragma mark - 按钮事件处理
//签到
- (IBAction)signInButtonClick:(UIButton *)sender {
    
    if (_todayModel) {
        
    } else {
        
        __weak typeof(self) weakSelf = self;
        
        NSMutableDictionary *parsmeters = [[NSMutableDictionary alloc] init];
        
        NSDate *now = [NSDate date];
        
        [parsmeters setValue:[NSString stringForTimeStamp:@"YYYY-MM-dd"] forKey:kTodayDate];
        [parsmeters setValue:[NSString stringWithFormat:@"%0f", now.timeIntervalSince1970] forKey:kSignInTime];
        [parsmeters setValue:@"0" forKey:kSignOutTime];
        [parsmeters setValue:@"0" forKey:kWorkDuration];
        [parsmeters setValue:_yesterdayModel.vacationTime ? : @"0" forKey:kVacationTime];
        
        [parsmeters setValue:@"0" forKey:kKnockOffTime];
        
        [QDDataBaseTool updateStatementsSql:INSERT_SQL
                             withParsmeters:parsmeters
                                      block:^(BOOL isOk, NSString *errorMsg) {
                                          
                                          if (isOk) {
                                              
                                              sender.enabled = NO;

                                              [sender setTitle:[NSString stringWithFormat:@"已签到\n%@", [[NSString stringWithFormat:@"%0f", now.timeIntervalSince1970] stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateDisabled];
                                              [sender.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                                              [sender.titleLabel setNumberOfLines:2];
                                              
                                              _todayModel = [QDModel qiandaoModelWithDictionary:parsmeters];
                                              
                                          } else {
                                              
                                              NSLog(@"%@", errorMsg);
                                              
                                          }
                                          
                                      }];
        
    }
    
}

//签退
- (IBAction)signOutButtonClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSDate *now = [NSDate date];
    NSString *signOutString = [NSString stringWithFormat:@"%0f", now.timeIntervalSince1970];
    NSString *workDurationString = [NSString workDurationBystartString:_todayModel.signInTime endString:signOutString];
    NSString *vacationString = [NSString vacationTimeByLastVacation:_yesterdayModel.vacationTime ? : @"0" workDuration:workDurationString];
    
    NSString *sqlStr = UPDATE_SQL(signOutString, workDurationString, vacationString, [NSString stringForTimeStamp:@"YYYY-MM-dd"]);
    
    [QDDataBaseTool updateStatementsSql:sqlStr
                         withParsmeters:nil
                                  block:^(BOOL isOk, NSString *errorMsg) {
                                      
                                      if (isOk) {
                                          
//                                          [weakSelf todayModelInit];
                                          [sender setTitle:[NSString stringWithFormat:@"已签退\n%@", [[NSString stringWithFormat:@"%0f", now.timeIntervalSince1970] stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateNormal];
                                          [sender.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                                          [sender.titleLabel setNumberOfLines:2];
                                          
                                          _todayModel.signOutTime = signOutString;
                                          _todayModel.workDuration = workDurationString;
                                          _todayModel.vacationTime = vacationString;
                                          
                                          if (_todayModel.vacationTime.doubleValue <= 0) {
                                              weakSelf.vacationTimeLabel.textColor = [UIColor redColor];
                                          } else {
                                              weakSelf.vacationTimeLabel.textColor = [UIColor greenColor];
                                          }
                                          weakSelf.vacationTimeLabel.text = [_todayModel.vacationTime durationString];
                                          
                                      } else {
                                          
                                          NSLog(@"%@", errorMsg);
                                          
                                      }
                                      
                                  }];
    
}

//上月历史
- (IBAction)precedingMonthButtonClick:(UIButton *)sender {
    
    
}

//当前月历史
- (IBAction)currentMonthButtonClick:(UIButton *)sender {
    
}

- (void)vacationTimeInit {
    
    if (_todayModel.vacationTime.doubleValue) {
        
        if (_todayModel.vacationTime.doubleValue <= 0) {
            self.vacationTimeLabel.textColor = [UIColor redColor];
        } else {
            self.vacationTimeLabel.textColor = [UIColor greenColor];
        }
        self.vacationTimeLabel.text = [_todayModel.vacationTime durationString];
        
    } else if (_yesterdayModel.vacationTime.doubleValue) {
        
        if (_yesterdayModel.vacationTime.doubleValue <= 0) {
            self.vacationTimeLabel.textColor = [UIColor redColor];
        } else {
            self.vacationTimeLabel.textColor = [UIColor greenColor];
        }
        self.vacationTimeLabel.text = [_yesterdayModel.vacationTime durationString];
        
    } else {
        
        self.vacationTimeLabel.textColor = [UIColor redColor];
        self.vacationTimeLabel.text = @"0:00:00";
        
    }
    
}

@end
