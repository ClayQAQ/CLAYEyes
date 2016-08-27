//
//  PastDetailViewController.h
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"

@interface PastDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *videoTable; //视频的列表
@property (nonatomic, copy) NSString *parameterString; //视频的网络请求参数
@property (nonatomic, strong) NSIndexPath *currentIndex; //当前视频的索引，由视频详情界面返回到此界面时使用

- (instancetype)initWithParameterString:(NSString *)parameterString Title:(NSString *)title;
- (NSMutableArray *)loadMoreData;

@end
