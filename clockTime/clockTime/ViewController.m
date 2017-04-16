//
//  ViewController.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "QDModel.h"
#import "QDHomeView.h"
#import "QDDataBaseTool.h"
#import "QDCommon.h"
#import "NSString+timeStamp.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) UIBarButtonItem *previousBarButton;

@property (nonatomic, strong) QDModel *yesterdayModel;

@property (nonatomic, strong) QDModel *todayModel;

@property (nonatomic, strong) QDModel *tomorrowModel;

@property (weak, nonatomic) IBOutlet QDHomeView *homeView;

@end

@implementation ViewController

#pragma mark - Lazy Load
- (NSString *)todayDate {
    
    if (_todayDate == nil) {
        _todayDate = [NSString stringForTimeStamp:@"YYYY-MM-dd"];
    }
    
    return _todayDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self yesterdayModelInit];
    [self todayModelInit];
    [self tommorrowModelInit];
    
    [self navigationInit];
    
    [self updateHomeView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationInit {
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftBtn setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    UIBarButtonItem *left01 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIButton *previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [previousBtn setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    UIBarButtonItem *right01 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    UIBarButtonItem *right01 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] landscapeImagePhone:[UIImage imageNamed:@"calender"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
//    self.nextBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
    self.nextBarButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItems = @[left01, self.previousBarButton];
    self.navigationItem.rightBarButtonItems = @[right01, self.nextBarButton];
    
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
}

- (void)updateHomeView {
    
    if (!self.homeView.sourceModel) {
        self.homeView = [[NSBundle mainBundle] loadNibNamed:@"QDHomeView" owner:self options:nil][0];

        self.homeView.frame = CGRectMake(0, 64, QYScreenW, QYScreenH - 64 - 44);
        
        [self.homeView.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.homeView.signOutButton addTarget:self action:@selector(signOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.homeView.swipeGestureRecognizer addTarget:self action:@selector(swipeGestureAction:)];
        [self.homeView.panGestureRecognizer addTarget:self action:@selector(panGestureAction:)];
        
        [self.view addSubview:self.homeView];
    }
    
    self.homeView.sourceModel = self.todayModel;
    
}

#pragma mark - 数据库相关

- (void)yesterdayModelInit {
    
    __weak typeof(self) weakSelf = self;
    
    [QDDataBaseTool selectStatementsSql:SELECT_PREVIOUS(self.todayDate)
                         withParsmeters:nil
                                forMode:@"QDModel"
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                     
                                      if (resposeObjc.count) {
                                          
                                          weakSelf.yesterdayModel = resposeObjc[0];
                                          weakSelf.nextBarButton.enabled = YES;
                                          
                                      } else {
                                          
                                          weakSelf.yesterdayModel = nil;
                                          weakSelf.previousBarButton.enabled = NO;
                                          
                                      }
                                      
                                      [weakSelf updateHomeView];
                                      
                                  }];
    
}

- (void)todayModelInit {
    
    __weak typeof(self) weakSelf = self;
    
    [QDDataBaseTool selectStatementsSql:SELECT_TODAY(self.todayDate)
                         withParsmeters:nil
                                forMode:@"QDModel"
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                      
                                      if (resposeObjc.count) {
                                          
                                          weakSelf.todayModel = resposeObjc[0];
                                          
                                      } else {
                                          
                                          weakSelf.todayModel = [QDModel todayModelForNullAttributes];
                                          
                                      }
                                      
                                  }];
    
}

- (void)tommorrowModelInit {
    
    __weak typeof(self) weakSelf = self;
    
    [QDDataBaseTool selectStatementsSql:SELECT_NEXT(self.todayDate)
                         withParsmeters:nil
                                forMode:@"QDModel"
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                      
                                      if (resposeObjc.count) {
                                          
                                          weakSelf.tomorrowModel = resposeObjc[0];
                                          weakSelf.previousBarButton.enabled = YES;
                                          
                                      } else {
                                          
                                          if ([weakSelf.todayModel.todayDate isEqualToString:[NSString stringForTimeStamp:@"YYYY-MM-dd"]]) {//
                                              
                                              weakSelf.tomorrowModel = nil;
                                              weakSelf.nextBarButton.enabled = NO;
                                              
                                          } else {
                                              
                                              weakSelf.tomorrowModel = [QDModel todayModelForNullAttributes];
                                              
                                          }
                                        
                                      }
                                      
                                      [weakSelf updateHomeView];
                                      
                                  }];
    
}

#pragma mark - 按钮事件处理
//上一天
- (IBAction)previousButtonClick:(UIBarButtonItem *)sender {
    
    self.tomorrowModel = self.todayModel;
    self.todayModel = self.yesterdayModel;
    
    self.todayDate = self.todayModel.todayDate;
    
    [self yesterdayModelInit];
    
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
}

//下一天
- (IBAction)nextButtonClick:(UIBarButtonItem *)sender {
    
    self.yesterdayModel = self.todayModel;
    self.todayModel = self.tomorrowModel;
    
    self.todayDate = self.todayModel.todayDate;
    
    [self tommorrowModelInit];
    
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
}

//签到
- (IBAction)signInButtonClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSDate *date = [NSDate date];
    NSString *signInTime = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    
    [dict setValue:self.todayDate forKey:kTodayDate];
    [dict setValue:signInTime forKey:kSignInTime];
    [dict setValue:@"0" forKey:kSignOutTime];
    [dict setValue:@"0" forKey:kWorkDuration];
    [dict setValue:@"0" forKey:kVacationTime];
    [dict setValue:@"0" forKey:kKnockOffTime];
    
    [QDDataBaseTool updateStatementsSql:INSERT_SQL
                         withParsmeters:dict
                                  block:^(BOOL isOk, NSString *errorMsg) {
                                      
                                      if (isOk) {
                                          
                                          weakSelf.todayModel.signInTime = signInTime;
                                          [weakSelf updateHomeView];
                                          
                                      } else {
                                       
                                          NSLog(@"%@", errorMsg);
                                          
                                      }
                                      
                                  }];
    
}

//签退
- (IBAction)signOutButtonClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSDate *date = [NSDate date];
    NSString *signOutTime = [NSString stringWithFormat:@"%f", date.timeIntervalSince1970];
    
    NSString *workDuration = [NSString workDurationBystartString:self.todayModel.signInTime endString:signOutTime];
    NSString *vacationTime = [NSString vacationTimeByLastVacation:self.yesterdayModel ? self.yesterdayModel.vacationTime : @"0" workDuration:workDuration];
    
    [QDDataBaseTool updateStatementsSql:UPDATE_SQL(signOutTime, workDuration, vacationTime, self.todayDate)
                         withParsmeters:nil
                                  block:^(BOOL isOk, NSString *errorMsg) {
                                     
                                      if (isOk) {
                                          
                                          weakSelf.todayModel.signOutTime = signOutTime;
                                          weakSelf.todayModel.workDuration = workDuration;
                                          weakSelf.todayModel.vacationTime = vacationTime;
                                          
                                          [weakSelf updateHomeView];
                                          
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

#pragma mark - UIGestureRecognizerDelegate
- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point=[sender translationInView:sender.view.superview];
        
        if (point.x > 0) {
            
            if (!self.yesterdayModel) {
                return;
            }
            [self previousButtonClick:self.previousBarButton];
            
        } else if (point.x < 0){
            
            if (!self.tomorrowModel) {
                return;
            }
            [self nextButtonClick:self.nextBarButton];
            
        }
        
    }
    
}

- (IBAction)swipeGestureAction:(UISwipeGestureRecognizer *)sender {

    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionRight:{
            if (!self.yesterdayModel) {
                return;
            }
            [self previousButtonClick:self.previousBarButton];
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:{
            if (!self.tomorrowModel) {
                return;
            }
            [self nextButtonClick:self.nextBarButton];
        }
            break;
        default:{
            
        }
            break;
    }
    
}

@end
