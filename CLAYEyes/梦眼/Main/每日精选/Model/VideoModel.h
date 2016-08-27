//
//  VideoModel.h
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel
@property(nonatomic,retain)NSNumber     *date;           //日期
@property(nonatomic,copy)NSString       *category;        //类别
@property(nonatomic,copy)NSString       *coverForDetail;    //图片地址
@property(nonatomic,copy)NSString       *coverBlurred;   //磨砂背景图 
@property(nonatomic,copy)NSString       *title;            //视频标题
@property(nonatomic,retain)NSNumber     *duration;         //视频时长
@property(nonatomic,retain)NSNumber       *collectionCount;     //收藏数
@property(nonatomic,retain)NSNumber       *shareCount;     //分享数
@property(nonatomic,copy)NSString       *playUrl;     //视频地址
@property(nonatomic,copy)NSString    *introduction; //视频介绍
@end
