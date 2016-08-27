//
//  MainTabBarController.m
//  梦眼
//
//  Created by imac on 15/9/29.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "MainTabBarController.h"
#import "TodayViewController.h"
#import "PastViewController.h"
#import "TabBarButton.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏系统标签栏
    self.tabBar.hidden = YES;
    //创建自定义标签栏
    [self _createTabBar];
}


#pragma mark - 创建子视图
//创建自定义TabBar
- (void)_createTabBar
{
    //创建背景
    _mainTabBarView = [[TabBarBackgroundView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
    [self.view addSubview:_mainTabBarView];
    
    //创建按钮
    //左边按钮
    TabBarButton *leftButton = [[TabBarButton alloc] initWithFrame:CGRectMake(2, 2, kScreenWidth / 2 - 4, 40 - 4) Title:@"每日精选"];
    leftButton.tag = 0;
    [leftButton addTarget:self action:@selector(_tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainTabBarView addSubview:leftButton];
    
    
    //右边按钮
    TabBarButton *rightButton = [[TabBarButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 + 2, 2, kScreenWidth / 2 - 4, 40 - 4) Title:@"往期分类"];
    rightButton.tag = 1;
    _selectedButton = rightButton;
    self.selectedIndex = 1;
    rightButton.selected = YES;
    [rightButton addTarget:self action:@selector(_tabBarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainTabBarView addSubview:rightButton];
    
}


#pragma mark - 按钮点击事件
//标签栏按钮点击事件
- (void)_tabBarAction:(UIButton *)button
{
    _selectedButton.selected = NO;
    _selectedButton = button;
    self.selectedIndex = button.tag;
    button.selected = !button.selected;
}




#pragma mark - 其它
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
