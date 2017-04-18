//
//  ViewController.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "QDSettingTableViewController.h"
#import "QDModel.h"
#import "QDHomeView.h"
#import "QDCommon.h"

@interface ViewController ()<UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) UIBarButtonItem *previousBarButton;

@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic, strong) QDModel *yesterdayModel;

@property (nonatomic, strong) QDModel *todayModel;

@property (nonatomic, strong) QDModel *tomorrowModel;

@property (weak, nonatomic) IBOutlet QDHomeView *homeView;

@property (nonatomic, strong) NSArray *yearArray;

@property (nonatomic, strong) NSArray *monthArray;

@property (nonatomic, strong) NSArray *dayArray;

/**
 日期的字典，分三层结构
 
 * .eg
 *{
 *  "2016": {
 *      "12": [
 *          22,
 *          25
 *      ]
 *  },
 *  "2017": {
 *      "1": [
 *          1,
 *          2
 *      ],
 *      "2": [
 *          2,
 *          3
 *      ]
 *  }
 *}
 */
@property (nonatomic, strong) NSMutableDictionary *dateDict;

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
    
    [self dataModelInit];
    
    [self navigationInit];
    
    [self updateHomeView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self dataModelInit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataModelInit {
    
    [self yesterdayModelInit];
    [self todayModelInit];
    [self tommorrowModelInit];

}

- (void)allTimeArrayInit {
    
    _yearArray = [_dateDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    _monthArray = [((NSDictionary *)[_dateDict valueForKey:_yearArray[0]]).allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    _dayArray = [(NSDictionary *)[_dateDict valueForKey:_yearArray[0]] valueForKey:_monthArray[0]];
    
}


- (void)navigationInit {
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftBtn setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(datePickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left01 = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [previousBtn setImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [previousBtn addTarget:self action:@selector(previousButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 32)];
    [rightBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right01 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.nextBarButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItems = @[left01, self.previousBarButton];
    self.navigationItem.rightBarButtonItems = @[right01, self.nextBarButton];
    
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
}

- (void)updateHomeView {
    
    if (!self.homeView) {
        self.homeView = [[NSBundle mainBundle] loadNibNamed:@"QDHomeView" owner:self options:nil][0];

        self.homeView.frame = CGRectMake(0, 64, QYScreenW, QYScreenH - 64 - 44);
        
        [self.homeView.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.homeView.signOutButton addTarget:self action:@selector(signOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.homeView.swipeGestureRecognizer addTarget:self action:@selector(swipeGestureAction:)];
        [self.homeView.panGestureRecognizer addTarget:self action:@selector(panGestureAction:)];
        
        [self.view addSubview:self.homeView];
    }
    
    self.homeView.sourceModel = self.todayModel;
    
    self.previousBarButton.enabled = self.yesterdayModel ? YES : NO;
    
    self.nextBarButton.enabled = self.tomorrowModel ? YES : NO;
    
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
                                          
                                      } else {
                                          
                                          weakSelf.yesterdayModel = nil;
                                          
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
                                          
                                      } else {
                                          
                                          if ([weakSelf.todayModel.todayDate isEqualToString:[NSString stringForTimeStamp:@"YYYY-MM-dd"]]) {//
                                              
                                              weakSelf.tomorrowModel = nil;
                                              
                                          } else {
                                              
                                              weakSelf.tomorrowModel = [QDModel todayModelForNullAttributes];
                                              
                                          }
                                        
                                      }
                                      
                                      [weakSelf updateHomeView];
                                      
                                  }];
    
}

- (void)dateDictInit {
    
    __weak typeof(self) weakSelf = self;
    
    if (!self.dateDict) {
        self.dateDict = [NSMutableDictionary dictionary];
    }
    
    [QDDataBaseTool selectStatementsSql:SELECT_KEY(kTodayDate)
                         withParsmeters:nil
                                forMode:nil
                                  block:^(NSMutableArray *resposeObjc, NSString *errorMsg) {
                                     
                                      if (resposeObjc.count) {
                                          
                                          [weakSelf.dateDict removeAllObjects];
                                          
                                          [resposeObjc enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                             
                                              if ([obj isKindOfClass:[NSDictionary class]]) {
                                                  
                                                  NSDictionary *dict = (NSDictionary *)obj;
                                                  
                                                  NSString *dateString = [dict valueForKey:kTodayDate];
                                                  //年，月，日
                                                  NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
                                                  NSString *monthString = [NSString stringWithFormat:@"%@-%@", dateArray[0], dateArray[1]];
                                                  
                                                  NSMutableDictionary *yearDict = [NSMutableDictionary dictionary];
                                                  NSMutableArray *month = [NSMutableArray array];
                                                  
                                                  if ([weakSelf.dateDict valueForKey:dateArray[0]]) {//存在本年的数据
                                                      
                                                      yearDict = [weakSelf.dateDict valueForKey:dateArray[0]];
                                                      
                                                      if ([yearDict valueForKey:monthString]) {//存在本月数据
                                                          
                                                          month = [yearDict valueForKey:monthString];
                                                          [month addObject:dateString];
                                                          
                                                      } else {
                                                          
                                                          [month addObject:dateString];
                                                          
                                                          [yearDict setObject:month forKey:monthString];
                                                          
                                                      }
                                                      
                                                  } else {
                                                      
                                                      [month addObject:dateString];
                                                      
                                                      [yearDict setValue:month forKey:monthString];
                                                      
                                                      [weakSelf.dateDict setValue:yearDict forKey:dateArray[0]];
                                                      
                                                  }
                                                  
                                              }
                                              
                                          }];
                                          
                                          [weakSelf allTimeArrayInit];
                                          
                                      } else {
                                          
                                          
                                          
                                      }
                                      
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

//日期选择
- (IBAction)datePickerButtonClick:(UIButton *)sender {
    
    [self dateDictInit];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, QYScreenW, QYScreenH)];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    [backgroundView setBackgroundColor:colRGB(253, 250, 245, 0.95)];
    
    UIPickerView *datePicker = [[UIPickerView alloc] init];
    CGPoint center = backgroundView.center;
    datePicker.center = CGPointMake(center.x, center.y - 100);
    
    datePicker.delegate = self;
    datePicker.dataSource = self;
    _datePicker = datePicker;
    
    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [selectButton setTitle:@"查询" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectButton.center = CGPointMake(center.x + 50, center.y + 100);
    [selectButton addTarget:self action:@selector(searchOneDay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.center = CGPointMake(center.x - 50, center.y + 100);
    [cancelButton addTarget:backgroundView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    backgroundView.userInteractionEnabled = YES;
    
    [backgroundView addSubview:selectButton];
    [backgroundView addSubview:cancelButton];
    [backgroundView addSubview:_datePicker];
    
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
}

//查询某天纪录
- (IBAction)searchOneDay:(UIButton *)sender {
    
    NSInteger dayNum = [_datePicker selectedRowInComponent:2];
    
    self.todayDate = _dayArray[dayNum];
    [self dataModelInit];
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
    [sender.superview removeFromSuperview];
    
}

//设置
- (IBAction)settingButtonClick:(UIButton *)sender {
    
    QDSettingTableViewController *settingVC = [[QDSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

//签到
- (IBAction)signInButtonClick:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSString *signInTime = [NSString stringForTimeStamp:@"HH:mm:ss"];
    
    [dict setValue:self.todayDate forKey:kTodayDate];
    [dict setValue:signInTime forKey:kSignInTime];
    [dict setValue:@"0" forKey:kSignOutTime];
    [dict setValue:@"0" forKey:kWorkDuration];
    
    if (!self.yesterdayModel.vacationTime || ![[self.yesterdayModel.todayDate componentsSeparatedByString:@"-"][1] isEqualToString:[self.todayDate componentsSeparatedByString:@"-"][1]]) {//不存在存休时间，或隔月签到
        
        [dict setValue:@"0" forKey:kVacationTime];
        
    } else {
        
        [dict setValue:self.yesterdayModel.vacationTime forKey:kVacationTime];
        
    }

    [dict setValue:@"0" forKey:kKnockOffTime];
    
    [QDDataBaseTool updateStatementsSql:INSERT_SQL
                         withParsmeters:dict
                                  block:^(BOOL isOk, NSString *errorMsg) {
                                      
                                      if (isOk) {
                                          
                                          weakSelf.todayModel.signInTime = signInTime;
                                          
                                          if (!weakSelf.yesterdayModel.vacationTime || ![[self.yesterdayModel.todayDate componentsSeparatedByString:@"-"][1] isEqualToString:[self.todayDate componentsSeparatedByString:@"-"][1]]) {
                                              
                                              weakSelf.todayModel.vacationTime = @"0";
                                              
                                          } else {
                                              
                                              weakSelf.todayModel.vacationTime = weakSelf.yesterdayModel.vacationTime;
                                              
                                          }
                                          
                                          [weakSelf updateHomeView];
                                          
                                      } else {
                                       
                                          NSLog(@"%@", errorMsg);
                                          
                                      }
                                      
                                  }];
    
}

//签退
- (IBAction)signOutButtonClick:(UIButton *)sender {
    
    if ([self.todayModel.signInTime isEqualToString:@"0"]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSString *signOutTime = [NSString stringForTimeStamp:@"HH:mm:ss"];
    
    NSString *workDuration = [NSString workDurationBystartString:self.todayModel.signInTime endString:signOutTime];
    NSString *vacationTime;
    
    if (!self.yesterdayModel.vacationTime || ![[self.yesterdayModel.todayDate componentsSeparatedByString:@"-"][1] isEqualToString:[self.todayDate componentsSeparatedByString:@"-"][1]]) {//不存在存休时间，或隔月签到
        
        vacationTime = [NSString vacationTimeByLastVacation:@"0" workDuration:workDuration];
        
    } else {
        
        vacationTime = [NSString vacationTimeByLastVacation:self.yesterdayModel.vacationTime workDuration:workDuration];

    }
    
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

#pragma mark  -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return component == 0 ? _yearArray.count : component == 1 ? _monthArray.count : _dayArray.count;

}

#pragma mark  -UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return component == 0 ? _yearArray[row] : component == 1 ? [_monthArray[row] componentsSeparatedByString:@"-"][1] : [_dayArray[row] componentsSeparatedByString:@"-"][2] ;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        //获取左边列选中的行内容
        NSString *key = _yearArray[row];
        //获取对应的右列中的数组
        _monthArray = [((NSDictionary *)[_dateDict valueForKey:key]).allKeys sortedArrayUsingSelector:@selector(compare:)];
        _dayArray = [(NSDictionary *)[_dateDict valueForKey:key] valueForKey:_monthArray[0]];
        
        //刷新右列
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
        //强制选中右列第0行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (component == 1) {
        //获取左边列选中的行内容
        NSString *key = _monthArray[row];
        //获取对应的右列中的数组
        _dayArray = [(NSDictionary *)[_dateDict valueForKey:[key componentsSeparatedByString:@"-"][0]] valueForKey:key];
        
        //刷新右列
        [pickerView reloadComponent:2];
        
        //强制选中右列第0行
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }
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
