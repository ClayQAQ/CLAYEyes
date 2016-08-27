//
//  TabBarButton.h
//  梦眼
//
//  Created by imac on 15/9/29.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarButton : UIButton

@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@end
