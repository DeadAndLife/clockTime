//
//  ViewController.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "QDModel.h"
#import "QDScrollView.h"
#import "QDDataBaseTool.h"
#import "QDCommon.h"
#import "NSString+timeStamp.h"

@interface ViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UILabel *vacationTimeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;

//临近三条的记录(只记录日期)
@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationInit];

    //添加pageViewController
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
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
    
    UIBarButtonItem *left01 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *left02 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous"] style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonClick:)];
    
    
    UIBarButtonItem *right01 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] landscapeImagePhone:[UIImage imageNamed:@"calender"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *right02 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
    right02.enabled = NO;
    
    self.navigationItem.leftBarButtonItems = @[left01, left02];
    self.navigationItem.rightBarButtonItems = @[right01, right02];
    
    self.navigationItem.title = [NSString stringForTimeStamp:@"EEE MM-dd"];
    
}

//pageViewController
- (UIPageViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(10.0)}];
        
        //设置数据源和代理
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        //设置内容控制器
        [_pageViewController setViewControllers:@[self.willDisPlayVCS[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    return _pageViewController;
}


//- (void)addScrollViewForView{
//    //创建并添加scrollView
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (QYScreenW + 25.0), QYScreenH)];
//    [self.view addSubview:scrollView];
//    
//    //设置属性
//    scrollView.contentSize = CGSizeMake((QYScreenW + 25.0) * 3, QYScreenH);
//    
//    scrollView.pagingEnabled = YES;
//    
//    scrollView.delegate = self;
//    
//    scrollView.backgroundColor = [UIColor blackColor];
//    
//    scrollView.showsHorizontalScrollIndicator = NO;
//    
//    _homeScrollView = scrollView;
//    
//}
//
//-(void)addZoomScrollViewForScrollView{
//    for (int i = 0; i < 3; i++) {
//        //创建并添加zoomScrollView
//        QDScrollView *zoomScrollView = [[QDScrollView alloc] initWithFrame:CGRectMake((QYScreenW + 25.0) * i, 0, QYScreenW, QYScreenH)];
//        [_homeScrollView addSubview:zoomScrollView];
//        zoomScrollView.tag = 1000 + i;
//    }
//}
//
////配置ZoomScrollView的属性(图片和偏移量)
//-(void)configurationPropertyForZoomScrollViews{
//    QDScrollView *leftZoomSC = [_homeScrollView viewWithTag:1000];
//    QDScrollView *middleZoomSC = [_homeScrollView viewWithTag:1001];
//    QDScrollView *rightZoomSC = [_homeScrollView viewWithTag:1002];
//    
//    //设置模型
//    
//    
//    //设置内容的偏移量
//    _homeScrollView.contentOffset = CGPointMake((QYScreenW + 25.0), 0);
//}

#pragma mark - 数据库相关

- (void)homeScrollViewInit {
    
    
    
}

#pragma mark - 按钮事件处理
//上一天
- (IBAction)previousButtonClick:(UIBarButtonItem *)sender {
    
    
    
}

//下一天
- (IBAction)nextButtonClick:(UIBarButtonItem *)sender {
    
    
    
}

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
