//
//  QDSettingTableViewController.m
//  
//
//  Created by iOSDeveloper on 2017/4/18.
//
//

#import "QDSettingTableViewController.h"
#import "QDSettingTableViewCell.h"
#import "QDSettingView.h"
#import "QDCommon.h"

@interface QDSettingTableViewController ()
//午休时间
@property (nonatomic, copy) NSString *lunchTime;
//工作时间
@property (nonatomic, copy) NSString *workTime;
//提示开启
@property (nonatomic) BOOL promptOn;
//步骤
@property (nonatomic) NSUInteger step;

//删除起始日期
@property (nonatomic, copy) NSString *startDate;
//删除终止日期
@property (nonatomic, copy) NSString *endDate;

@end

@implementation QDSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClick:)];
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick:)];
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClick:)];
    self.navigationItem.title = @"设置";
    
    [self userDefaultsInit];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDefaultsInit {
    
    self.lunchTime = [UserDefaultsManager lunchTime];
    self.workTime = [UserDefaultsManager workTime];
    self.promptOn = [UserDefaultsManager promptOn];
    self.step = 0;
    
}

#pragma mark - selector
- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)doneButtonClick:(UIBarButtonItem *)sender {
    
    [UserDefaultsManager setLunchTime:self.lunchTime];
    [UserDefaultsManager setWorkTime:self.workTime];
    [UserDefaultsManager setPromptOn:self.promptOn];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)switchClick:(UISwitch *)sender {
    
    self.promptOn = !sender.on;
    NSLog(@"%d",self.promptOn);
    
}

- (IBAction)datePickerChanged:(UIDatePicker *)sender {
    
    switch (sender.tag) {
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            
            if (self.step == 0) {
                
                
                
            } else if (self.step == 1) {
                
                
                
            }
            
        }
            break;
        default:
            break;
    }
    
}

- (IBAction)rightButtonClick:(UIButton *)sender {
    
    QDSettingView *settingView;
    
    if ([sender.superview isKindOfClass:[QDSettingView class]]) {
        settingView = (QDSettingView *)sender.superview;
    }

    switch (sender.tag) {
        case 1:{
            self.lunchTime = [NSString timeStringForTimeInterval:settingView.datePicker.countDownDuration];
            
            [settingView removeFromSuperview];
        }
            break;
        case 2:{
            self.workTime = [NSString timeStringForTimeInterval:settingView.datePicker.countDownDuration];
            
            [settingView removeFromSuperview];
        }
            break;
        case 3:{
            
            if (self.step == 0) {
                
                self.step = 1;
                settingView.titleLabel.text = @"终止日期";
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                dateFormat.dateFormat = @"YYYY-MM-dd";
                self.startDate = [dateFormat stringFromDate:settingView.datePicker.date];
                
                settingView.datePicker.minimumDate = settingView.datePicker.date;
                
                [settingView.rightButton setTitle:@"删除" forState:UIControlStateNormal];
                [settingView.leftButton setTitle:@"上一步" forState:UIControlStateNormal];
                
                
            } else if (self.step == 1) {
                
                self.step = 0;

                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                dateFormat.dateFormat = @"YYYY-MM-dd";
                self.endDate = [dateFormat stringFromDate:settingView.datePicker.date];
                
                [QDDataBaseTool updateStatementsSql:DELETE_SQL(self.startDate, self.endDate)
                                     withParsmeters:nil
                                              block:^(BOOL isOk, NSString *errorMsg) {
                                                  
                                                  if (isOk) {
                                                      
                                                      NSLog(@"YES");
                                                      
                                                  } else {
                                                      
                                                      NSLog(@"%@", errorMsg);
                                                      
                                                  }
                                                  
                                              }];
                
                [settingView removeFromSuperview];
                
            }
            
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)leftButtonClick:(UIButton *)sender {
    
    QDSettingView *settingView;
    
    if ([sender.superview isKindOfClass:[QDSettingView class]]) {
        settingView = (QDSettingView *)sender.superview;
    }
    
    if (self.step == 0) {
        
        [settingView removeFromSuperview];
        
    } else if (self.step == 1) {
        
        self.step = 0;
        settingView.titleLabel.text = @"起始日期";
    
        settingView.datePicker.date = [NSDate date];
        settingView.datePicker.minimumDate = nil;
        
        [settingView.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
        [settingView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"QDSettingTableViewCell" owner:self options:nil];
    QDSettingTableViewCell *cell = cellArray[indexPath.row ? indexPath.row - 1 : 0];
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"午休时长";
            cell.detailTextLabel.text = self.lunchTime;
        }
            break;
        case 1:{
            cell.textLabel.text = @"正常工作日时长";
            cell.detailTextLabel.text = self.workTime;
        }
            break;
        case 2:{
            if (!cell.signSwitch) {
                cell.translatesAutoresizingMaskIntoConstraints = NO;
                cell.signSwitch.translatesAutoresizingMaskIntoConstraints = NO;
                
                cell.signSwitch = [[UISwitch alloc] init];
                
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.signSwitch attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
                NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:cell.signSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
                
                [cell.signSwitch addConstraint:rightConstraint];
                [cell.signSwitch addConstraint:centerYConstraint];
            }
            
            cell.signSwitch.on = !self.promptOn;
            [cell.signSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case 3:{
            
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //背景
            QDSettingView *backgroundView = [[NSBundle mainBundle] loadNibNamed:@"QDSettingView" owner:self options:nil][0];
            backgroundView.frame = CGRectMake(0, 0, QYScreenW, QYScreenH);
            //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
            [backgroundView setBackgroundColor:colRGB(253, 250, 245, 0.95)];
            backgroundView.titleLabel.text = @"午休时长设置";
            
            backgroundView.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            [backgroundView.datePicker setCountDownDuration:[self.lunchTime timeStampWithDateFormat]];
            backgroundView.datePicker.tag = 1;
            
//            [backgroundView.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
            
            [backgroundView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
            backgroundView.rightButton.tag = 1;
            [backgroundView.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            [backgroundView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
            [backgroundView.leftButton addTarget:backgroundView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            
            backgroundView.userInteractionEnabled = YES;
            
            //将原始视图添加到背景视图中
            [window addSubview:backgroundView];
        }
            break;
        case 1:{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //背景
            QDSettingView *backgroundView = [[NSBundle mainBundle] loadNibNamed:@"QDSettingView" owner:self options:nil][0];
            backgroundView.frame = CGRectMake(0, 0, QYScreenW, QYScreenH);
            //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
            [backgroundView setBackgroundColor:colRGB(253, 250, 245, 0.95)];
            
            backgroundView.titleLabel.text = @"工作时长设置";
            
            backgroundView.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
            [backgroundView.datePicker setCountDownDuration:[self.workTime timeStampWithDateFormat]];
            backgroundView.datePicker.tag = 2;
            
//            [backgroundView.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
            
            [backgroundView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
            backgroundView.rightButton.tag = 2;
            [backgroundView.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [backgroundView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
            [backgroundView.leftButton addTarget:backgroundView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            
            backgroundView.userInteractionEnabled = YES;
            
            //将原始视图添加到背景视图中
            [window addSubview:backgroundView];
        }
            break;
        case 2:{
            return;
        }
            break;
        case 3:{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //背景
            QDSettingView *backgroundView = [[NSBundle mainBundle] loadNibNamed:@"QDSettingView" owner:self options:nil][0];
            backgroundView.frame = CGRectMake(0, 0, QYScreenW, QYScreenH);
            //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
            [backgroundView setBackgroundColor:colRGB(253, 250, 245, 0.95)];
            backgroundView.titleLabel.text = @"起始日期";
            
            backgroundView.datePicker.datePickerMode = UIDatePickerModeDate;
            backgroundView.datePicker.tag = 3;
            
            [backgroundView.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
            
            [backgroundView.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
            backgroundView.rightButton.tag = 3;
            [backgroundView.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [backgroundView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
            [backgroundView.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            backgroundView.userInteractionEnabled = YES;
            
            
            //将原始视图添加到背景视图中
            [window addSubview:backgroundView];
        }
            break;
        default:
            break;
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
