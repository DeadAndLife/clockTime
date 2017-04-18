//
//  QDSettingTableViewController.h
//  
//
//  Created by iOSDeveloper on 2017/4/18.
//
//

#import <UIKit/UIKit.h>

@interface QDSettingTableViewController : UITableViewController

@end

@protocol QDSettingTableViewController <NSObject>

- (IBAction)switchClick:(UISwitch *)sender;

@end
