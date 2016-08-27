//
//  VideoTableView.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "VideoTableView.h"
#import "VideoCell.h"
#import "DateView.h"
#import "VideoModel.h"
#import "DailyListModel.h"
#import "DetailVideoViewController.h"
#import "MainTabBarController.h"
#import "TodayViewController.h"

@implementation VideoTableView{
    NSString *dtstring;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initTable];
    }
    return self;
}



- (void)_initTable{
    self.dataSource = self;
    self.delegate = self;

    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:@"VideoCellId"];
}

#pragma mark  - table代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dailyListModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    DailyListModel *model = _dailyListModelArray[section];
    NSInteger total = [model.total integerValue];
    return total;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCellId" forIndexPath:indexPath];
    DailyListModel *model = _dailyListModelArray[indexPath.section];
    VideoModel *videoModel = model.videoList[indexPath.row];
    cell.VideoModel = videoModel;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight / 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    //取得model里的data数据
    DailyListModel *model = _dailyListModelArray[section];
    NSNumber *time = model.date;
    //时间戳转换成时间
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dateString = [dateFormatter stringFromDate:d];
    [dateFormatter setDateFormat:@"MM"];
    NSString *dateMonthString = [dateFormatter stringFromDate:d];
    int intString = [dateMonthString intValue];
    //创建月份数组
    NSArray *month = @[@"Jan.",@"Feb.",@"Mar.",@"Apr.",@"May.",@"Jun.",@"Jul.",@"Aug.",@"Sep.",@"Oct.",@"Nov.",@"Dec."];
    DateView *dateView = [[DateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    //获取对应的月份
    NSString *data = month[intString - 1];
    dtstring = [data stringByAppendingString:dateString];
    dateView.dateLabel.text = dtstring;
    return dateView;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section != 0) {
        CGPoint rect = [self convertPoint:view.frame.origin toView:self.window];
        if (rect.y < 100) {
            if (section == 1) {
                if (self.selectMonthBlock) {
                    //调用block
                    self.selectMonthBlock(@"Today");
                }
            }else{
                DailyListModel *model = _dailyListModelArray[section-1];
                NSNumber *time = model.date;
                //时间戳转换成时间
                NSDate *d = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd"];
                NSString *dateString = [dateFormatter stringFromDate:d];
                [dateFormatter setDateFormat:@"MM"];
                NSString *dateMonthString = [dateFormatter stringFromDate:d];
                int intString = [dateMonthString intValue];
                //创建月份数组
                NSArray *month = @[@"Jan.",@"Feb.",@"Mar.",@"Apr.",@"May.",@"Jun.",@"Jul.",@"Aug.",@"Sep.",@"Oct.",@"Nov.",@"Dec."];
                //获取对应的月份
                NSString *data = month[intString - 1];
                NSString *_dtstring = [data stringByAppendingString:dateString];

                if (self.selectMonthBlock) {
                    //调用block
                    self.selectMonthBlock(_dtstring);
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section != 0) {
        CGPoint rect = [self convertPoint:view.frame.origin toView:self.window];
        if (rect.y < 100) {
            if (self.selectMonthBlock) {
                //调用block
                self.selectMonthBlock(dtstring);
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



//点击单元格，跳转到该视频的详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建视频详情视图控制器，初始化时顺便把数据传过去
    DetailVideoViewController *detailController = [[DetailVideoViewController alloc] initWithDailyListModelArray:_dailyListModelArray CurrentVideoIndex:indexPath];
    DailyListModel *dailyListModel = self.dailyListModelArray[indexPath.section];
    NSArray *videoList = dailyListModel.videoList;
    detailController.changeListScrollView.currentVideoBlock(indexPath,videoList[indexPath.row]);
    [self.navigationController pushViewController:detailController animated:NO];

    //取消选择状态
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;

    
    //实现DetailVideoViewController的数据请求block
    detailController.changeListScrollView.loadMoreDataBlock = ^{
        TodayViewController *todayViewController = (TodayViewController *)self.viewController;
        NSMutableArray *loadResultArray = [todayViewController loadMoreData];
        return loadResultArray;
    };
}



@end
