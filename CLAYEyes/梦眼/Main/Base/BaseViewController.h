//
//  BaseViewController.h
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "ConfigureViewController.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel; //导航栏中间标题
@property (nonatomic, strong) UIView *menuView; //菜单视图，左边按钮点击后放下
@property (nonatomic, strong) UIBarButtonItem *configureBarButton; //导航栏右边设置按钮，点击菜单后出现
@property (nonatomic, strong) UILabel *todayLabel; //导航栏左边日期显示
@property (nonatomic, strong) UIBarButtonItem *whiteEyeBarButton; //导航栏右边白眼按钮，点击后可以跳转到视频详情页面

//创建menuView菜单视图
- (void)createMenuView;
//创建导航栏按钮
- (void)createNavigationBarButton;
//菜单按钮点击事件
- (void)menuAction:(UIButton *)button;
//创建导航栏日期提示label
- (void)createTodayLabel;
//创建导航栏右边白眼按钮，点击后可以跳转到视频详情页面
- (void)createWhiteEyeButton;
//创建titleLabel
- (void)createTitleLabel;

@end
