//
//  DataService.m
//  04 weibo
//
//  Created by gj on 15/8/12.
//  Copyright (c) 2015年 www.huiwen.com 杭州汇文教育. All rights reserved.
//

#import "DataService.h"

@implementation DataService



+ (AFHTTPRequestOperation *)requestAFUrl:(NSString *)urlString
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)params //token  文本
              data:(NSMutableDictionary *)datas //文件
             block:(BlockType)block{
    
 
    
    //01 构建urlString
    NSString *fullUrlString = [BaseUrl stringByAppendingString:urlString];
    
    //02 构建manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
   // manager.responseSerializer
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if ([method isEqualToString:@"GET"]) {
          AFHTTPRequestOperation *operation =  [manager GET:fullUrlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"传输失败  %@",error);
        }];
        return  operation;
        
    }else if([method isEqualToString:@"POST"]){
        //datas存储图片 相关信息
        if (datas != nil) {
            
            AFHTTPRequestOperation *operation = [manager POST:fullUrlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                //图片添加到body 就由这个block来完成
                for (NSString *name in datas) {
                    NSData *data = [datas objectForKey:name];
                    [formData appendPartWithFileData:data name:name fileName:@"1.png" mimeType:@"image/jpeg"];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
                NSLog(@"上传成功");

                block(responseObject);
            
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"上传失败");
            }];
        
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"上传进度,已经上传 %lld",totalBytesWritten);
               
                
            }];
            return  operation;
        
        }else{//不带图片
            
            AFHTTPRequestOperation *operation =  [manager POST:fullUrlString parameters:params success:^void(AFHTTPRequestOperation *operation , id responseObject ) {
                NSLog(@"POST成功");
                
                block(responseObject);
                
            } failure:^void(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
            return  operation;
            
        }
        
    }
    return nil;
}



@end
