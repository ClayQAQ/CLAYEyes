//
//  VideoTableView.h
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIViewController.h"
typedef void(^SelectMonthBlock)(NSString *);
#define kSectionDidChangeNotificationName @"kSectionDidChangeNotificationName"

@interface VideoTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray  *dailyListModelArray;    //存储dailyListModel的数组
@property (nonatomic,copy) SelectMonthBlock selectMonthBlock;    //block用于传回日期字符
@property (nonatomic,strong) UINavigationController *navigationController; //当前所在视图控制器的导航控制器

@end
