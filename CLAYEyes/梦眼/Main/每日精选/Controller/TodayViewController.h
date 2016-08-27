//
//  TodayViewController.h
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoTableView.h"

@interface TodayViewController : BaseViewController

@property (nonatomic, strong) VideoTableView *videoTable; //视频的列表
@property (nonatomic, strong) NSIndexPath *currentIndex; //当前视频的索引，由视频详情界面返回到此界面时使用

- (NSMutableArray *)loadMoreData;

@end
