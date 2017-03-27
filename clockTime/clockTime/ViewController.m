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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@property (weak, nonatomic) IBOutlet UILabel *vacationTimeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signInButton addTarget:self action:@selector(signInButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.signOutButton addTarget:self action:@selector(signOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据库相关
- (void)dataBaseInit {
    
    NSDate *now = [NSDate date];
    
    //NSString *minValue = ;
    //
    //[QDDataBaseTool selectStatementsSql:SELECT_ALL(<#minValue#>, <#maxValue#>)
    //                     withParsmeters:nil
    //                            forMode:@"QDModel"
    //                              block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
    //
    //}];
    
}


#pragma mark - 按钮事件处理
//签到
- (IBAction)signInButtonClick:(UIButton *)sender {
    
    
}

//签退
- (IBAction)signOutButtonClick:(UIButton *)sender {
    
}

//上月历史
- (IBAction)precedingMonthButtonClick:(UIButton *)sender {
    
    
}

//当前月历史
- (IBAction)currentMonthButtonClick:(UIButton *)sender {
    
}

@end
