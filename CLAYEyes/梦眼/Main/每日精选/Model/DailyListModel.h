//
//  DailyListModel.h
//  梦眼
//
//  Created by imac on 15/10/1.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseModel.h"
#import "VideoModel.h"

@interface DailyListModel : BaseModel
@property(nonatomic,strong)NSMutableArray      *videoList;    //视频列表数组
@property(nonatomic,retain)NSNumber     *total;       //每天视频总数
@property(nonatomic,retain)NSNumber     *date;           //日期

@end
