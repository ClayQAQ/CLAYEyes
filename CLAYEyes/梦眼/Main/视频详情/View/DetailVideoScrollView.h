//
//  DetailVideoScrollView.h
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@protocol VideoIntroductionDelegate <NSObject>

- (void)changeVideoIntroductionViewWithRelativeOffset:(CGFloat)relativeOffset CurrentPage:(NSInteger)currentPage;

@end


@interface DetailVideoScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *videoList; //当前所显示的那一组视频VideoModel
@property (nonatomic,strong) UIView *pageIndicator; //页码指示条，放在视图底部
@property (nonatomic,assign) id<VideoIntroductionDelegate> introductionDelegate; //介绍视图设置代理
@property (nonatomic) NSInteger currentPage; //当前显示第几个视频（此处不用考虑第几组，故不用NSIndexPath）

- (instancetype)initWithFrame:(CGRect)frame VideoList:(NSArray *)videoList CurrentPage:(NSInteger)currentPage;
- (void)createPageIndicator;
- (void)zoomVideoView;

@end
