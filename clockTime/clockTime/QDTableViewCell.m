//
//  QDTableViewCell.m
//  clockTime
//
//  Created by iOSDeveloper on 2017/3/27.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "QDTableViewCell.h"

@interface QDTableViewCell ()

//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//签到时间
@property (weak, nonatomic) IBOutlet UILabel *signInTime;

//签退时间
@property (weak, nonatomic) IBOutlet UILabel *signOutTime;

//工作时长
@property (weak, nonatomic) IBOutlet UILabel *workDuration;

//超出时长(当日存休)
@property (weak, nonatomic) IBOutlet UILabel *overstepTime;

@end

@implementation QDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQdModel:(QDModel *)qdModel {
    
    _qdModel = qdModel;
    
}

@end
