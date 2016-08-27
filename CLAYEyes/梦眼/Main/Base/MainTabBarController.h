//
//  MainTabBarController.h
//  梦眼
//
//  Created by imac on 15/9/29.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarBackgroundView.h"

@interface MainTabBarController : UITabBarController
{
    UIButton *_selectedButton; //当前选中的按钮
}

@property (nonatomic, strong) TabBarBackgroundView *mainTabBarView;

@end
