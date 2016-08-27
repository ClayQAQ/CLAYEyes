//
//  DailyListModel.m
//  梦眼
//
//  Created by imac on 15/10/1.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DailyListModel.h"
#import "VideoModel.h"

@implementation DailyListModel

- (id)initWithDataDic:(NSDictionary *)dataDic{
    self = [super initWithDataDic:dataDic];
    if (self) {
        [self _loadVideoModel:dataDic];
    }
    return self;
}

- (void)_loadVideoModel:(NSDictionary *)dic{
    NSArray *array = [dic objectForKey:@"videoList"];
    _videoList = [[NSMutableArray alloc] init];
    for (NSDictionary *videoListDic in array) {
        VideoModel *model = [[VideoModel alloc] initWithDataDic:videoListDic];
        [_videoList addObject:model];
    }
}

@end
