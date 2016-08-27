//
//  DetailVideoScrollView.m
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DetailVideoScrollView.h"
#import "UIImageView+WebCache.h"
#import "ChangeListScrollView.h"
#import "IntroductionImageView.h"
#import "VideoViewController.h"
#import "UIView+UIViewController.h"
#define offsetRatio 3/4  //翻页时的图片偏移比例

@implementation DetailVideoScrollView
{
    UILabel *_pageIndicatorLabel; //指示条上面的页码
    NSString *_playUrl;//视频地址
}


- (instancetype)initWithFrame:(CGRect)frame VideoList:(NSArray *)videoList CurrentPage:(NSInteger)currentPage
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = currentPage;
        _videoList = videoList;
        [self _createSubScrollView];
        
        //设置自己的一些属性
        self.contentSize = CGSizeMake(_videoList.count * self.width, 0);
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        //定位到点击的视频
        self.contentOffset = CGPointMake(self.width * _currentPage, 0);
    }
    return self;
}

#pragma mark - 子视图创建
//根据videoList创建subScrollView，每一个subScrollView显示一个视频的图片
- (void)_createSubScrollView
{
    CGFloat width = self.width;
    CGFloat height = self.height/2;
    for (int i = 0; i < _videoList.count; i++) {
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        subScrollView.tag = i+100;
        subScrollView.clipsToBounds = YES;
        [self addSubview:subScrollView];
        
        //图片加载
        VideoModel *model = _videoList[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, subScrollView.width, subScrollView.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail]];
        [subScrollView addSubview:imageView];
        
        //播放按钮
        UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, subScrollView.width, subScrollView.height)];
        playButton.backgroundColor = [UIColor clearColor];
        [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        subScrollView.userInteractionEnabled = YES;
        [subScrollView addSubview:playButton];

        //播放按钮图片
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(subScrollView.width/2-40, subScrollView.height/2-40, 80, 80)];
        playImageView.alpha = 0.6;
        [playImageView setImage:[UIImage imageNamed:@"play.png"]];
//        playImageView.userInteractionEnabled = YES;
        [playButton addSubview:playImageView];
    }
}

//创建页码指示条pageIndicator，要等父视图创建出来才能添加，故此方法由父视图调用
- (void)createPageIndicator
{
    _pageIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 64)/2-20, kScreenWidth / _videoList.count, 20)];
    _pageIndicator.tag = 666;
    ChangeListScrollView *selfSuperView = (ChangeListScrollView *)self.superview.superview;
    [selfSuperView.pageIndicatorSuperView addSubview:_pageIndicator];
    
    //创建指示条上面的页码
    _pageIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pageIndicator.width/2-15, 0, 30, 18)];
    _pageIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    _pageIndicatorLabel.textColor = [UIColor whiteColor];
    _pageIndicatorLabel.text = [NSString stringWithFormat:@"%li - %li",_currentPage + 1,_videoList.count];
    _pageIndicatorLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:10];
    [_pageIndicator addSubview:_pageIndicatorLabel];
    
    //创建指示条
    UIView *pageTrack = [[UIView alloc] initWithFrame:CGRectMake(0, 18, kScreenWidth / _videoList.count, 2)];
    pageTrack.backgroundColor = [UIColor whiteColor];
    [_pageIndicator addSubview:pageTrack];
    
    //设置页码指示条位置
    CGFloat pageIndicatorLocation = (self.contentOffset.x / self.contentSize.width) * kScreenWidth;
    _pageIndicator.left = pageIndicatorLocation;
}

- (void)playVideo{
    VideoModel *model = _videoList[_currentPage];
    
    VideoViewController *vc = [[VideoViewController alloc] init];
    _playUrl = model.playUrl;
    vc.playUrl = _playUrl;
    [self.viewController presentMoviePlayerViewControllerAnimated:vc];
}


#pragma mark - scrollView代理方法

//即将放手时，在一次滑动动作中只会执行一次
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //设置当前页码
    _currentPage = targetContentOffset->x / self.width;
    //改变页码指示条上面的label
    _pageIndicatorLabel.text = [NSString stringWithFormat:@"%li - %li",_currentPage + 1,_videoList.count];
    //设置页码指示条位置
    CGFloat pageIndicatorLocation = (scrollView.contentOffset.x / scrollView.contentSize.width) * kScreenWidth;
    _pageIndicator.left = pageIndicatorLocation;
    
    //执行代理方法，设置视频介绍视图，传入相对偏移量和当前页码
    [self.introductionDelegate changeVideoIntroductionViewWithRelativeOffset:self.width CurrentPage:_currentPage];
}

//滑动过程，在一次滑动动作中会执行多次，滑动越慢，执行次数越多
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //相对于当前页码的偏移量
    CGFloat relativeOffset = scrollView.contentOffset.x - _currentPage * self.width;

    UIScrollView *subScrollView = (UIScrollView *)[self viewWithTag:_currentPage + 100];
    //子视图里面的图片以一定比例的偏移速度向反方向偏移
    subScrollView.contentOffset = CGPointMake(-relativeOffset*offsetRatio, 0);
    //判断，如果相对偏移量是正数，说明是往左移动，则此时即将出现的图片视图是后面一个
    if (relativeOffset > 0) {
        UIScrollView *latterSubScrollView = (UIScrollView *)[self viewWithTag:_currentPage + 1 + 100];
        //即将出现的视图的图片偏移方向为负，偏移量跟着父视图的偏移量变化
        latterSubScrollView.contentOffset = CGPointMake(self.width*offsetRatio - relativeOffset*offsetRatio, 0);
    }
    //否则即将出现的图片视图是前面一个
    else {
        UIScrollView *frontSubScrollView = (UIScrollView *)[self viewWithTag:_currentPage - 1 + 100];
        //即将出现的视图的图片偏移方向为正，偏移量跟着父视图的偏移量变化
        frontSubScrollView.contentOffset = CGPointMake(-self.width*offsetRatio-relativeOffset*offsetRatio, 0);
    }
    
    //设置页码指示条位置
    CGFloat pageIndicatorLocation = scrollView.contentOffset.x / scrollView.contentSize.width * kScreenWidth;
    _pageIndicator.left = pageIndicatorLocation;
    
    //执行代理方法，设置视频介绍视图，传入相对偏移量和当前页码
    [self.introductionDelegate changeVideoIntroductionViewWithRelativeOffset:relativeOffset CurrentPage:_currentPage];
}

#pragma mark - 视频视图的缩放动画
- (void)zoomVideoView
{
    UIScrollView *subScrollView = (UIScrollView *)[self viewWithTag:_currentPage + 100];
    UIImageView *imageView = subScrollView.subviews[0];
    [UIView animateWithDuration:5 animations:^{
        imageView.transform = CGAffineTransformScale(imageView.transform, 1.3, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            }];
    }];
}

@end
