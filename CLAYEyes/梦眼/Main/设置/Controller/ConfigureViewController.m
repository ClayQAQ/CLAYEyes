//
//  ConfigureViewController.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ConfigureViewController.h"

@interface ConfigureViewController ()

@end

@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏左边返回按钮
    [self _createBackButton];
    //创建导航栏标题
    [self _createTitleLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏标签栏
    MainTabBarController *mainTabBarController = (MainTabBarController *)self.navigationController.tabBarController;
    mainTabBarController.mainTabBarView.hidden = YES;
    //隐藏系统的返回按钮
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - 创建子视图
//创建导航栏左边返回按钮
- (void)_createBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(_backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

//创建导航栏标题
- (void)_createTitleLabel
{
    //创建导航栏中间标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    titleLabel.text = @"设置";
    titleLabel.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 按钮点击事件
//导航栏左边返回按钮
- (void)_backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
