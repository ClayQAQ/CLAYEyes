//
//  DetailVideoViewController.m
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DetailVideoViewController.h"
#import "ChangeListScrollView.h"
#import "DetailVideoScrollView.h"
#import "DailyListModel.h"
#import "TodayViewController.h"

@interface DetailVideoViewController ()

@end

@implementation DetailVideoViewController

//init方法在viewDidLoad之后才调用
//“每日精选”点进来时调用
- (instancetype)initWithDailyListModelArray:(NSMutableArray *)dailyListModelArray
                          CurrentVideoIndex:(NSIndexPath *)currentVideoIndex
{
    self = [super init];
    if (self) {
        //创建整个scrollView，包括眼睛视图
        self.changeListScrollView = [[ChangeListScrollView alloc] initWithFrame:self.view.bounds];
        //传入数据
        self.changeListScrollView.dailyListModelArray = dailyListModelArray;
        self.changeListScrollView.currentVideoIndex = currentVideoIndex;
        DailyListModel *dailyListModel = dailyListModelArray[currentVideoIndex.section];
        self.changeListScrollView.videoList = dailyListModel.videoList;
        //创建视频图片视图
        [self.changeListScrollView createVideoScrollView];
        [self.view addSubview:self.changeListScrollView];

        //创建导航栏右边的菜单按钮的下拉菜单
        [self createMenuView];
        //创建导航栏按钮
        [self createNavigationBarButton];
        //创建导航栏日期提示label
        [self createTodayLabel];
        
        __weak DetailVideoViewController *weakSelf = self;
        //实现block
        self.changeListScrollView.currentVideoBlock = ^(NSIndexPath *currentIndex,VideoModel *model) {
            //设置TodayLabel的日期文字
            if (weakSelf.todayLabel) {
                if (currentIndex.section == 0) {
                    weakSelf.todayLabel.text = @"Today";
                }
                else {
                    NSNumber *dateNumber = model.date;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateNumber doubleValue]/1000];
                    //创建日期格式对象，用于读取日期对象
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"MMM.dd";
                    //获取字符串形式的日期
                    NSString *dateString = [dateFormatter stringFromDate:date];
                    weakSelf.todayLabel.text = dateString;
                }
            }
            //索引
            weakSelf.currentIndex = currentIndex;
        };
    }
    return self;
}

//“往期分类”点进来时调用
- (instancetype)initWithVideoList:(NSMutableArray *)videoList
                          CurrentVideoIndex:(NSIndexPath *)currentVideoIndex
{
    self = [super init];
    if (self) {
        //创建整个scrollView，包括眼睛视图
        self.changeListScrollView = [[ChangeListScrollView alloc] initWithFrame:self.view.bounds];
        //传入数据
        self.changeListScrollView.currentVideoIndex = currentVideoIndex;
        self.changeListScrollView.videoList = videoList;
        //创建视频图片视图
        [self.changeListScrollView createVideoScrollView];
        [self.view addSubview:self.changeListScrollView];
        
        __weak DetailVideoViewController *weakSelf = self;
        //实现block
        self.changeListScrollView.currentVideoBlock = ^(NSIndexPath *currentIndex,VideoModel *model) {
            //索引
            weakSelf.currentIndex = currentIndex;
        };
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //导航栏标题
    [self createTitleLabel];
    //导航栏右边眼睛按钮，点击后返回
    [self _createEyeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏标签栏
    MainTabBarController *mainTabBarController = (MainTabBarController *)self.navigationController.tabBarController;
    mainTabBarController.mainTabBarView.hidden = YES;
    //隐藏系统的返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    //定时器开启，开始视频视图缩放动画
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self.changeListScrollView.videoScrollView selector:@selector(zoomVideoView) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //标签栏出现
    MainTabBarController *mainTabBarController = (MainTabBarController *)self.navigationController.tabBarController;
    mainTabBarController.mainTabBarView.hidden = NO;
    //停止定时器
    [self.timer invalidate];
}

//导航栏右边眼睛按钮，点击后返回
- (void)_createEyeButton
{
    UIButton *eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 15, 30, 30)];
    [eyeButton setImage:[UIImage imageNamed:@"blackeyebutton"] forState:UIControlStateNormal];
    [eyeButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    _eyeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:eyeButton];
    self.navigationItem.rightBarButtonItem = _eyeBarButtonItem;
}

//返回按钮点击事件（导航栏右边眼睛按钮）
- (void)backAction
{
    NSInteger controllerIndex = self.navigationController.viewControllers.count - 2;
    TodayViewController *todayViewController = self.navigationController.viewControllers[controllerIndex];
    todayViewController.currentIndex = self.currentIndex;

    [self.navigationController popViewControllerAnimated:NO];
}

//菜单按钮点击事件（覆写父类方法）
- (void)menuAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            //菜单按钮图案旋转动画
            button.transform = CGAffineTransformMakeRotation(M_PI_2);
            //菜单视图放下
            self.menuView.bottom = kScreenHeight-64;
            //配置按钮出现
            self.navigationItem.rightBarButtonItem = self.configureBarButton;
            if (self.todayLabel) {
                self.todayLabel.hidden = YES;
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            //恢复按钮图案方向
            button.transform = CGAffineTransformIdentity;
            //菜单视图收起
            self.menuView.bottom = 0;
            //配置按钮隐藏，黑色眼镜按钮出现         
            self.navigationItem.rightBarButtonItem = self.eyeBarButtonItem;
            if (self.todayLabel) {
                self.todayLabel.hidden = NO;
            }
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
