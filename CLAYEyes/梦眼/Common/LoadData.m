//
//  LoadData.m
//  梦眼
//
//  Created by imac on 15/10/8.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "LoadData.h"

@implementation LoadData

+ (NSDictionary *)requestWithUrl:(NSString *)Url httpMethod:(NSString *)httpMethod params:(NSDictionary *)params
{
    //构造URL
    NSURL *url = [NSURL URLWithString:Url];
    //构造网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求方式
    request.HTTPMethod = httpMethod;
    //超时时间
    request.timeoutInterval = 5;
    //构造响应
    NSHTTPURLResponse *response = nil;
    //错误
    NSError *error = nil;
    //发送同步请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //处理返回数据
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dataDictionary;
}

@end
