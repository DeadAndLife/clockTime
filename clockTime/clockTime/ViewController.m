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

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *nextBarButton;

@property (nonatomic, strong) UIBarButtonItem *previousBarButton;

@property (nonatomic, strong) QDModel *yesterdayModel;

@property (nonatomic, strong) QDModel *todayModel;

@property (nonatomic, strong) QDModel *tomorrowModel;

@property (nonatomic)         NSInteger currentPage;        //当前页

@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;

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
    
    [self yesterdayModelInit];
    [self todayModelInit];
    [self tommorrowModelInit];
    
    [self navigationInit];

    //1.在self.view上添加一个底部滚动的scrollView
    [self addScrollViewForView];
    //2.在scrollView上添加缩放的zoomScrollView
    [self addZoomScrollViewForScrollView];
    
    //3.配置zoomScrollView的属性
    [self configurationPropertyForZoomScrollViews];
    

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
    self.previousBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"previous"] style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonClick:)];
    
    UIBarButtonItem *right01 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] landscapeImagePhone:[UIImage imageNamed:@"calender"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.nextBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
    self.nextBarButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItems = @[left01, self.previousBarButton];
    self.navigationItem.rightBarButtonItems = @[right01, self.nextBarButton];
    
    self.navigationItem.title = [self.todayDate goalFormat:@"EEE MM-dd" sourceFormat:@"YYYY-MM-dd"];
    
}

- (void)addScrollViewForView{
    
    //设置属性
    _homeScrollView.pagingEnabled = YES;
    
    _homeScrollView.delegate = self;
    
    _homeScrollView.backgroundColor = [UIColor blackColor];
    
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    
}

-(void)addZoomScrollViewForScrollView{
    for (int i = 0; i < 3; i++) {
        //创建并添加zoomScrollView
        QDScrollView *zoomScrollView = [[NSBundle mainBundle] loadNibNamed:@"QDScrollView" owner:self options:nil][0];
        zoomScrollView.frame = CGRectMake((QYScreenW + 25.0) * i, 0, QYScreenW, QYScreenH - 64);
        
        [_homeScrollView addSubview:zoomScrollView];
        zoomScrollView.tag = 1000 + i;
    }
}

//配置ZoomScrollView的属性(图片和偏移量)
-(void)configurationPropertyForZoomScrollViews{
    QDScrollView *leftZoomSC = [_homeScrollView viewWithTag:1000];
    QDScrollView *middleZoomSC = [_homeScrollView viewWithTag:1001];
    QDScrollView *rightZoomSC = [_homeScrollView viewWithTag:1002];
    
    //设置模型
    middleZoomSC.sourceModel = self.todayModel;
    leftZoomSC.sourceModel = self.yesterdayModel;
    rightZoomSC.sourceModel = self.tomorrowModel;
    
    middleZoomSC.backgroundColor = [UIColor blueColor];
    leftZoomSC.backgroundColor = [UIColor darkGrayColor];
    rightZoomSC.backgroundColor = [UIColor lightGrayColor];
    
    //设置内容的偏移量
//    if (!self.yesterdayModel) {//表示第一条数据
//        
//        _homeScrollView.contentOffset = CGPointMake(0, 0);
//        
//    } else if (!self.tomorrowModel) {//表示最后一条数据(今天)
//        
//        _homeScrollView.contentOffset = CGPointMake((QYScreenW + 25.0) * 2, 0);
//        
//    } else {
    
        _homeScrollView.contentOffset = CGPointMake((QYScreenW + 25.0), 0);
        
//    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _currentPage = scrollView.contentOffset.x / (QYScreenW + 25);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.userInteractionEnabled = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    scrollView.userInteractionEnabled = YES;
    if (_currentPage == scrollView.contentOffset.x / (QYScreenW + 25)) {
        return;
    }
    
    //判断左右滑动
    if (scrollView.contentOffset.x == 0) {
        if (!self.yesterdayModel) {
            return;
        }
        //右滑
        [self previousButtonClick:self.previousBarButton];
        
    }else if (scrollView.contentOffset.x == (QYScreenW + 25.0) * 2){
        if (!self.tomorrowModel) {
            return;
        }
        //左滑
        [self nextButtonClick:self.nextBarButton];
        
    }
    
    [self configurationPropertyForZoomScrollViews];
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
                                          weakSelf.nextBarButton.enabled = YES;
                                          
                                      } else {
                                          
                                          weakSelf.yesterdayModel = nil;
                                          weakSelf.previousBarButton.enabled = NO;
                                          
                                      }
                                      
                                      [weakSelf configurationPropertyForZoomScrollViews];
                                      
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
                                          weakSelf.previousBarButton.enabled = YES;
                                          
                                      } else {
                                          
                                          if ([weakSelf.todayModel.todayDate isEqualToString:[NSString stringForTimeStamp:@"YYYY-MM-dd"]]) {//
                                              
                                              weakSelf.tomorrowModel = nil;
                                              weakSelf.nextBarButton.enabled = NO;
                                              
                                          } else {
                                              
                                              weakSelf.tomorrowModel = [QDModel todayModelForNullAttributes];
                                              
                                          }
                                          
                                          
                                      }
                                      
                                      [weakSelf configurationPropertyForZoomScrollViews];
                                      
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

//签到
- (IBAction)signInButtonClick:(UIButton *)sender {
    

    
}

//签退
- (IBAction)signOutButtonClick:(UIButton *)sender {
    
//    __weak typeof(self) weakSelf = self;
    
 
    
}

//上月历史
- (IBAction)precedingMonthButtonClick:(UIButton *)sender {
    
    
}

//当前月历史
- (IBAction)currentMonthButtonClick:(UIButton *)sender {
    
}

@end
