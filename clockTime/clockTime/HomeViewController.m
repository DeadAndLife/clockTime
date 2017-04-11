//
//  HomeViewController.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/11.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "HomeViewController.h"
#import "NSString+timeStamp.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@property (weak, nonatomic) IBOutlet UILabel *vacationTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *workDuration;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSourceModel:(QDModel *)sourceModel {
    
    _sourceModel = sourceModel;
    
    if (_sourceModel.workDuration.doubleValue) {
        
        self.workDuration.text = [_sourceModel.workDuration durationString];
        
    } else {
        
        self.workDuration.text = @"暂无记录";
        
    }
    
    if (self.signInButton.titleLabel.numberOfLines != 2 || self.signOutButton.titleLabel.numberOfLines != 2) {
        
        [self.signInButton.titleLabel setNumberOfLines:2];
        [self.signOutButton.titleLabel setNumberOfLines:2];
        
    }
    
    if (_sourceModel.signInTime.doubleValue) {//签过到
        
        self.signInButton.enabled = NO;
        
        [self.signInButton setTitle:[NSString stringWithFormat:@"已签到\n%@", [_sourceModel.signInTime stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateDisabled];
        [self.signInButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        
        
    } else {
        
        self.signInButton.enabled = YES;
        
        [self.signInButton setTitle:@"签到" forState:UIControlStateDisabled];
        [self.signInButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
    }
    
    if (_sourceModel.signOutTime.doubleValue) {//签过退
        
        [self.signOutButton setTitle:[NSString stringWithFormat:@"已签到\n%@", [_sourceModel.signOutTime stringByTimeStamp:@"HH:mm:ss"]] forState:UIControlStateNormal];
        [self.signOutButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        
    } else {
        
        [self.signInButton setTitle:@"签退" forState:UIControlStateDisabled];
        [self.signInButton.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
    }
    
    if ([self.todayDate isEqualToString:[NSString stringForTimeStamp:@"YYYY-MM-dd"]]) {//是今天
        
        self.signOutButton.enabled = YES;
        
    } else {
        
        self.signInButton.enabled = NO;
        self.signOutButton.enabled = NO;
        
    }
    
    [self vacationTimeInit];
    
}

- (void)vacationTimeInit {
    
    if (_sourceModel.vacationTime.doubleValue) {
        
        if (_sourceModel.vacationTime.doubleValue <= 0) {
            self.vacationTimeLabel.textColor = [UIColor redColor];
        } else {
            self.vacationTimeLabel.textColor = [UIColor greenColor];
        }
        self.vacationTimeLabel.text = [_sourceModel.vacationTime durationString];
        
    } else {
        
        self.vacationTimeLabel.textColor = [UIColor blackColor];
        self.vacationTimeLabel.text = @"0:00:00";
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
