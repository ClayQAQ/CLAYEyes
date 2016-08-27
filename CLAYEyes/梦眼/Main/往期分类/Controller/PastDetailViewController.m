//
//  PastDetailViewController.m
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "PastDetailViewController.h"
#import "VideoCell.h"
#import "DataService.h"
#import "PastModel.h"
#import "MJRefresh.h"
#import "DetailVideoViewController.h"
#import "LoadData.h"

@interface PastDetailViewController (){
    NSMutableArray *_videoList;
    NSString *_nextPageUrl;
}

@end

@implementation PastDetailViewController

- (instancetype)initWithParameterString:(NSString *)parameterString Title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.parameterString = parameterString;
        //创建导航栏中间标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        titleLabel.text = title;
        titleLabel.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self _creatTable];
    [self _loadVideoData];

    //创建导航栏右边白眼按钮，点击后可以跳转到视频详情页面
    [self createWhiteEyeButton];
    //创建导航栏左边返回按钮
    [self _createBackButton];
}

//根据返回的indexPath自动滑到相应的单元格
- (void)viewWillAppear:(BOOL)animated
{
    [self.videoTable scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//创建导航栏左边返回按钮
- (void)_createBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(_backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
}

//创建tableView
- (void) _creatTable{
    _videoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _videoTable.backgroundColor = [UIColor clearColor];
    _videoTable.dataSource = self;
    _videoTable.delegate = self;
    _videoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [_videoTable registerNib:nib forCellReuseIdentifier:@"VideoCellId"];
    
    _videoTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _videoTable.contentInset = UIEdgeInsetsMake(0, 0, -9, 0);
    [self.view addSubview:_videoTable];
}


//初次加载数据，采用异步网络请求，避免在软件启动时崩溃
- (void)_loadVideoData{
    _videoList = [[NSMutableArray alloc] init];
    NSString *string = @"http://baobab.wandoujia.com/api/v1/videos?num=10&strategy=date&vc=125&t=MjAxNTA5MjkxNDM2NDQ5MTMsOTY4MQ%3D%3D&u=213367ae25cb8116060ddbd038303c56853d00ea&net=wifi&v=1.8.1&f=iphone&categoryName=";
    NSString *url = [string stringByAppendingString:self.parameterString];
    [DataService requestAFUrl:url httpMethod:@"GET" params:nil data:nil block:^(id result) {
        _nextPageUrl = [result objectForKey:@"nextPageUrl"];
        NSArray *dicArray = [result objectForKey:@"videoList"];
        
        for (NSDictionary *dataDic in dicArray) {
            VideoModel *model = [[VideoModel alloc] initWithDataDic:dataDic];
            [_videoList addObject:model];
        }
        [self.videoTable reloadData];
    }];
}


//加载更多数据，采用同步网络请求，避免在视频详情界面因为加载数据过慢而导致数组越界，然后崩溃
- (NSMutableArray *)loadMoreData{
    if (_nextPageUrl == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已没有更多视频！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    if ([_nextPageUrl isKindOfClass:[NSNull class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已没有更多视频！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    NSMutableArray *loadResultArray = [[NSMutableArray alloc] init];
    NSDictionary *result = [LoadData requestWithUrl:_nextPageUrl httpMethod:@"GET" params:nil];
    _nextPageUrl = [result objectForKey:@"nextPageUrl"];
    NSArray *dicArray = [result objectForKey:@"videoList"];;
    
    for (NSDictionary *dataDic in dicArray) {
        VideoModel *model = [[VideoModel alloc] initWithDataDic:dataDic];
        [loadResultArray addObject:model];
    }
    [_videoList addObjectsFromArray:loadResultArray];
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

//导航栏左边返回按钮
- (void)_backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark  - table代理

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoList.count;
}

//生成单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellId" forIndexPath:indexPath];
    VideoModel *videoModel = _videoList[indexPath.row];
    cell.VideoModel = videoModel;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight / 3;
}


//点击单元格，跳转到视频详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建视频详情视图控制器，初始化时顺便把数据传过去
    DetailVideoViewController *detailController = [[DetailVideoViewController alloc] initWithVideoList:_videoList CurrentVideoIndex:indexPath];
    [self.navigationController pushViewController:detailController animated:NO];
    
    //取消选择状态
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    //实现detailController的更多数据请求
    detailController.changeListScrollView.loadMoreDataBlock = ^{
        return [self loadMoreData];
    };
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
