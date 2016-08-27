//
//  ChangeGroupScrollView.h
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailVideoScrollView.h"
#import "DailyListModel.h"
typedef void (^CurrentVideoBlock)(NSIndexPath *,VideoModel *);
typedef NSMutableArray* (^LoadMoreDataBlock)();

@interface ChangeListScrollView : UIScrollView <UIScrollViewDelegate,VideoIntroductionDelegate>

@property (nonatomic, strong) UIView *leftSubview; //左边子视图
@property (nonatomic, strong) UIView *middleSubview; //中间子视图
@property (nonatomic, strong) UIView *rightSubview; //右边子视图
@property (nonatomic, strong) DetailVideoScrollView *videoScrollView; //视频视图，为中间子视图的上半部分子视图

@property (nonatomic, strong) UIView *introductionSuperView; //视频介绍视图的父视图（为了固定显示优先级）
@property (nonatomic, strong) UIView *pageIndicatorSuperView; //页码指示条的父视图（为了固定显示优先级）
@property (nonatomic) BOOL isChange; //是否切换视频图片，为YES时创建一个视频介绍视图

@property (nonatomic, strong) NSMutableArray *videoList; //当前所显示的那一组视频
@property (nonatomic, strong) NSMutableArray *dailyListModelArray; //一组DailyListModel
@property (nonatomic, strong) NSIndexPath *currentVideoIndex; //索引，记录当前应该显示的第几组第几个视频
@property (nonatomic, copy) CurrentVideoBlock currentVideoBlock; //当前所看视频和其索引的相关操作
@property (nonatomic, copy) LoadMoreDataBlock loadMoreDataBlock; //用于加载更多数据时发送请求

- (void)createVideoScrollView;

@end
