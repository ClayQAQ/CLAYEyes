//
//  BaseViewController.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 创建子视图
//创建titleLabel
- (void)createTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 10, 100, 30)];
    _titleLabel.text = @"DreamEyes";
    _titleLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:20];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
}

//创建导航栏按钮
- (void)createNavigationBarButton
{
    //左边菜单按钮
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarButton;
    
    //创建导航栏右边设置按钮（齿轮图案）
    UIButton *configureButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-36, 12, 20, 20)];
    [configureButton setImage:[UIImage imageNamed:@"configure"] forState:UIControlStateNormal];
    [configureButton addTarget:self action:@selector(_configureAction:) forControlEvents:UIControlEventTouchUpInside];
    _configureBarButton = [[UIBarButtonItem alloc] initWithCustomView:configureButton];
}

//创建导航栏右边白眼按钮，点击后可以跳转到视频详情页面
- (void)createWhiteEyeButton
{
    UIButton *whiteEyeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 25, 25)];
    [whiteEyeButton setImage:[UIImage imageNamed:@"whiteeye"] forState:UIControlStateNormal];
    [whiteEyeButton addTarget:self action:@selector(_whiteEyeAction) forControlEvents:UIControlEventTouchUpInside];
    self.whiteEyeBarButton = [[UIBarButtonItem alloc] initWithCustomView:whiteEyeButton];
    self.navigationItem.rightBarButtonItem = self.whiteEyeBarButton;
}

//创建导航栏日期提示label
- (void)createTodayLabel
{
    _todayLabel = [[UILabel alloc] initWithFrame:CGRectMake(-kScreenWidth*7/32, 5, 40, 20)];
    _todayLabel.text = @"Today";
    _todayLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:14];
    [self.navigationItem.titleView addSubview:_todayLabel];
}


//创建menuView菜单视图
- (void)createMenuView
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, -kScreenHeight+64, kScreenWidth, kScreenHeight-64)];
    self.menuView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    [self.view addSubview:self.menuView];
    
    //创建视图里面的按钮
    UIButton *button0 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 50, 100, 30)];
    [button0 setTitle:@"我的收藏" forState:UIControlStateNormal];
    [button0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button0.titleLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:15];
    [_menuView addSubview:button0];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 130, 100, 30)];
    [button1 setTitle:@"我的缓存" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:15];
    [_menuView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 210, 100, 30)];
    [button2 setTitle:@"意见反馈" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:15];
    [_menuView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 290, 100, 30)];
    [button3 setTitle:@"我要投稿" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:15];
    [_menuView addSubview:button3];
}


#pragma mark - 按钮点击事件
//菜单按钮点击事件
- (void)menuAction:(UIButton *)button
{
    button.selected = !button.selected;
    MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
    tabBarController.mainTabBarView.hidden = button.selected;
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
            //配置按钮隐藏
            self.navigationItem.rightBarButtonItem = nil;
            //白眼按钮出现
            self.navigationItem.rightBarButtonItem = _whiteEyeBarButton;
            if (self.todayLabel) {
                self.todayLabel.hidden = NO;
            }
        }];
    }
}

//配置按钮点击事件
- (void)_configureAction:(UIButton *)button
{
    ConfigureViewController *configureViewController = [[ConfigureViewController alloc] init];
    [self.navigationController pushViewController:configureViewController animated:YES];
}

//导航栏右边白眼按钮点击事件，点击后可以跳转到视频详情页面
- (void)_whiteEyeAction
{
    NSLog(@"此方法由子类覆写");
}


#pragma mark - 其它
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
