//
//  DetailVideoViewController.h
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChangeListScrollView.h"


@interface DetailVideoViewController : BaseViewController

@property (nonatomic, strong) ChangeListScrollView *changeListScrollView; //整个scrollView
@property (nonatomic, strong) UIBarButtonItem *eyeBarButtonItem; //导航栏右边眼睛按钮，点击后返回，设置按钮出现后需隐藏
@property (nonatomic, strong) NSIndexPath *currentIndex; //当前视频的索引，返回上一界面时用此定位当前视频在tableView的位置
@property (nonatomic, strong) NSTimer *timer; //控制视频视图缩放动画的定时器

//初始化方法，“每日精选”点进来时调用
- (instancetype)initWithDailyListModelArray:(NSArray *)dailyListModelArray
                          CurrentVideoIndex:(NSIndexPath *)currentVideoIndex;
//初始化方法，“往期分类”点进来时调用
- (instancetype)initWithVideoList:(NSArray *)videoList
                CurrentVideoIndex:(NSIndexPath *)currentVideoIndex;
@end
