//
//  LoadData.h
//  梦眼
//
//  Created by imac on 15/10/8.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadData : NSObject

+ (NSDictionary *)requestWithUrl:(NSString *)Url httpMethod:(NSString *)httpMethod params:(NSDictionary *)params;

@end
