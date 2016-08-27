//
//  VideoModel.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

-(id)initWithDataDic:(NSDictionary*)dataDic
{
    self = [super initWithDataDic:dataDic];
    if (self) {
        self.introduction = dataDic[@"description"];
    }
    return self;
}

@end
