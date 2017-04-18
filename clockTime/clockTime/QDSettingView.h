//
//  QDSettingView.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/18.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QDSettingView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end
