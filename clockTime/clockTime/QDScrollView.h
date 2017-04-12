//
//  QDScrollView.h
//  clockTime
//
//  Created by iOSDeveloper on 2017/4/11.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDModel.h"

@interface QDScrollView : UIView

@property (nonatomic, strong) QDModel *sourceModel;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@end
