//
//  TodayViewController.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "TodayViewController.h"
#import "DataService.h"
#import "VideoModel.h"
#import "DailyListModel.h"
#import "MJRefresh.h"
#import "LoadData.h"

@interface TodayViewController (){
    NSMutableArray *_dailyArray;
    NSString *_nextPageUrl;
}

@end

@implementation TodayViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"每日精选 销毁");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _creatTable];
    [self _loadVideoData];

    //导航栏标题
    [self createTitleLabel];
    //创建导航栏日期提示label
    [self createTodayLabel];
    //创建导航栏右边的菜单按钮的下拉菜单
    [self createMenuView];
    //创建导航栏按钮
    [self createNavigationBarButton];
    //创建导航栏右边白眼按钮，点击后可以跳转到视频详情页面
    [self createWhiteEyeButton];
    
    __weak UILabel *weakTodayLabel = self.todayLabel;
    _videoTable.selectMonthBlock = ^(NSString *string){
        weakTodayLabel.text = string;
    };
}

//根据返回的indexPath自动滑到相应的单元格
- (void)viewWillAppear:(BOOL)animated
{
    [self.videoTable scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//创建table
- (void) _creatTable{
    
    _videoTable = [[VideoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    _videoTable.navigationController = self.navigationController; //videoTable内部需要使用
    _videoTable.backgroundColor = [UIColor clearColor];
    _videoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _videoTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _videoTable.contentInset = UIEdgeInsetsMake(0, 0, -9, 0);
    _videoTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_videoTable];
    
}


//初次加载数据，采用异步网络请求，避免在软件启动时崩溃
- (void)_loadVideoData{
    _dailyArray = [[NSMutableArray alloc] init];
    [DataService requestAFUrl:@"http://baobab.wandoujia.com/api/v1/feed?num=10&date=20190929&vc=125&u=213367ae25cb8116060ddbd038303c56853d00ea&v=1.8.1&f=iphone" httpMethod:@"GET" params:nil data:nil block:^(id result) {
        _nextPageUrl = [result objectForKey:@"nextPageUrl"];
        NSArray *dicArray = [result objectForKey:@"dailyList"];
                
        for (NSDictionary *dataDic in dicArray) {
            DailyListModel *dailyModel = [[DailyListModel alloc] initWithDataDic:dataDic];
            [_dailyArray addObject:dailyModel];
        }
        self.videoTable.dailyListModelArray = _dailyArray;
        [self.videoTable reloadData];
    }];
}


//加载更多数据，采用同步网络请求，避免在视频详情界面因为加载数据过慢而导致数组越界，然后崩溃
- (NSMutableArray *)loadMoreData{
    NSMutableArray *loadResultArray = [[NSMutableArray alloc] init];

    NSDictionary *result = [LoadData requestWithUrl:_nextPageUrl httpMethod:@"GET" params:nil];
    NSArray *dicArray = [result objectForKey:@"dailyList"];
    
    for (NSDictionary *dataDic in dicArray) {
        DailyListModel *dailyModel = [[DailyListModel alloc] initWithDataDic:dataDic];
        [loadResultArray addObject:dailyModel];
    }
    
    [self.videoTable.dailyListModelArray addObjectsFromArray:loadResultArray];
    [self.videoTable reloadData];

    [_videoTable.footer endRefreshing];
    
    return loadResultArray;
}



//导航栏右边白眼按钮点击事件，点击后可以跳转到视频详情页面
- (void)_whiteEyeAction
{
    CGPoint selectedPoint = [self.view convertPoint:CGPointMake(100, 150) toView:self.videoTable];
    NSIndexPath *selectedIndexPath = [self.videoTable indexPathForRowAtPoint:selectedPoint];
    [self.videoTable.delegate tableView:self.videoTable didSelectRowAtIndexPath:selectedIndexPath];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
