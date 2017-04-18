//
//  QDSettingTableViewCell.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/18.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QDSettingTableViewCell.h"
#import "QDSettingTableViewController.h"

@implementation QDSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (__kindof UIViewController *)viewController{
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (__kindof UIViewController *)nextResponder;
        }
    }
    return nil;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
