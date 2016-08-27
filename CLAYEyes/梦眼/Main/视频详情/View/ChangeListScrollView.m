//
//  ChangeGroupScrollView.m
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ChangeListScrollView.h"
#import "IntroductionImageView.h"

@implementation ChangeListScrollView
{
    UIImageView *_leftEyeBall;
    UIImageView *_rightEyeBall; //转动眼珠视图
    IntroductionImageView *_nowIntroductionImageView; //现在正在显示的视频介绍视图
    //每次翻页过程，相对偏移量的正负号会有一次改变，用i、j进行判断
    int i; //记录刚开始滑动时相对偏移量的正负
    int j; //记录当前时刻相对偏移量的正负
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建三个子视图，和两个固定显示优先级的父视图
        [self _createSubview];
        //左右两边眼睛动画视图
        [self _createEyeView];
        self.delegate = self;
        //取消回弹效果
        self.bounces = NO;
        //分页效果
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.isChange = YES;
    }
    return self;
}

#pragma mark - 创建子视图
//创建三个子视图，和两个固定显示优先级的父视图
- (void)_createSubview
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    _leftSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [self addSubview:_leftSubview];
    
    _middleSubview = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    [self addSubview:_middleSubview];
    
    _rightSubview = [[UIView alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
    [self addSubview:_rightSubview];
    
    self.contentSize = CGSizeMake(width * 3, 0);
    //中间视图首先显示
    self.contentOffset = CGPointMake(width, 0);

    //创建两个固定显示优先级的父视图
    _introductionSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 64) / 2, self.width, (self.height - 64) / 2)];
    [_middleSubview addSubview:_introductionSuperView];
    
    _pageIndicatorSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 64) / 2, self.width, (self.height - 64) / 2)];
    _pageIndicatorSuperView.backgroundColor = [UIColor clearColor];
    [_middleSubview addSubview:_pageIndicatorSuperView];
}

//创建视频视图
- (void)createVideoScrollView
{
    //创建视频图片视图，并加在整个scrollView的中间视图上
    DetailVideoScrollView *detailVideoScrollView = [[DetailVideoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 64) VideoList:self.videoList CurrentPage:self.currentVideoIndex.row];
    detailVideoScrollView.introductionDelegate = self;
    self.videoScrollView = detailVideoScrollView;
    
    //创建detailVideoScrollView的页码指示条，要加在父视图上，故在此创建
    UIView *lastPageIndicator = [_pageIndicatorSuperView viewWithTag:666];
    if (lastPageIndicator != nil) {
        [lastPageIndicator removeFromSuperview]; //移除旧的
    }
    [detailVideoScrollView createPageIndicator];
    
    //创建视频介绍视图
    _nowIntroductionImageView = [[IntroductionImageView alloc] initWithFrame:_introductionSuperView.bounds VideoModel:self.videoList[self.currentVideoIndex.row]];
    [_introductionSuperView addSubview:_nowIntroductionImageView];
    _nowIntroductionImageView.alpha = 1;
}

//中间视图添加子视图
- (void)setVideoScrollView:(DetailVideoScrollView *)videoScrollView
{
    if (_videoScrollView != videoScrollView) {
        //把旧的先移除，节省内存
        [_videoScrollView removeFromSuperview];
        _videoScrollView = videoScrollView;
        [_middleSubview addSubview:_videoScrollView];
    }
}

//左右两边眼睛动画视图
- (void)_createEyeView
{
    CGPoint centerPoint = CGPointMake(kScreenWidth/2, 250);
    //添加左视图的眼睛
    UIImageView *leftEyeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    leftEyeView.image = [UIImage imageNamed:@"eyesocket"];
    leftEyeView.center = centerPoint;
    [_leftSubview addSubview:leftEyeView];
    _leftEyeBall = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _leftEyeBall.image = [UIImage imageNamed:@"eyeball"];
    [leftEyeView addSubview:_leftEyeBall];
    
    //添加左视图的眼睛
    UIImageView *rightEyeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    rightEyeView.image = [UIImage imageNamed:@"eyesocket"];
    rightEyeView.center = centerPoint;
    [_rightSubview addSubview:rightEyeView];
    _rightEyeBall = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _rightEyeBall.image = [UIImage imageNamed:@"eyeball"];
    [rightEyeView addSubview:_rightEyeBall];
}


//代理方法，创建视频介绍视图
- (void)changeVideoIntroductionViewWithRelativeOffset:(CGFloat)relativeOffset CurrentPage:(NSInteger)currentPage
{
    //相对偏移量大于0，则为滑到下一视图，需要创建下一视频介绍视图
    if (relativeOffset > 0) {
        j = 1;
        if (_isChange) {
            i = 1;
            if (currentPage < _videoList.count-1) {
                _nowIntroductionImageView = [[IntroductionImageView alloc] initWithFrame:_introductionSuperView.bounds VideoModel:_videoList[currentPage+1]];
                [_introductionSuperView addSubview:_nowIntroductionImageView];
                //当前显示的介绍视图标记上当前页码信息，用于滑动停止后校对
                _nowIntroductionImageView.tag = currentPage+1+777;
                _isChange = NO; //改成NO，防止重复创建
            }
        }
    }

    
    //相对偏移量小于0，则为滑到上一视图，需要创建上一视频介绍视图
    else if (relativeOffset < 0) {
        j = -1;
        if (_isChange) {
            i = -1;
            if (currentPage > 0) {
                _nowIntroductionImageView = [[IntroductionImageView alloc] initWithFrame:_introductionSuperView.bounds VideoModel:_videoList[currentPage-1]];
                [_introductionSuperView addSubview:_nowIntroductionImageView];
                //当前显示的介绍视图标记上当前页码信息，用于滑动停止后校对
                _nowIntroductionImageView.tag = currentPage-1+777;
                _isChange = NO; //改成NO，防止重复创建
            }
        }
    }
    
    
    //页码没有改变的时候，只是新视图的透明度改变
    if (self.currentVideoIndex.row == currentPage) {
        if (i == j) {
            //不透明度的改变
            _nowIntroductionImageView.alpha = fabs(relativeOffset) / self.width;
        }
    }
    //页码改变后
    else {
        //由于前面介绍视图的创建时机是在srollView由静止变成滑动状态的一瞬间，所以如果用户滑动速度太快，则会出现滑动很多页的过程中没有创建时机，也就是说滑动很多页只创建了最初刚开始滑动那一页的介绍视图，导致介绍视图与视频图片不匹配。在此，根据当前视图的tag值判断介绍视图是否与视频图片匹配，如果不匹配，则需要再次创建
        [self _checkNowIntroductionImageView:currentPage];
        
        if (_nowIntroductionImageView.alpha != 1) {
            //alpha设为1，打字效果开始出现
            _nowIntroductionImageView.alpha = 1;
        }
        
        if (i != j && relativeOffset == 0) {
            //再次检查
            [self _checkNowIntroductionImageView:currentPage];
            //改变当前索引
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPage inSection:self.currentVideoIndex.section];
            self.currentVideoIndex = indexPath;
            self.currentVideoBlock(indexPath, self.videoList[indexPath.row]);
            
            if (_introductionSuperView.subviews.count > 1) {
                //移除已经滑过去的视频介绍视图
                IntroductionImageView *lastIntroductionImageView = _introductionSuperView.subviews[0];
                if (lastIntroductionImageView.tag != currentPage+777) {
                    [lastIntroductionImageView removeFromSuperview];
                }
            }
            //已经滑到下一个视频，改成YES，准备下一次滑动时候判断
            _isChange = YES;
            i=j=0;
        }
    }
}

//检查当前的介绍视图是否是对应视频图片视图的
- (void)_checkNowIntroductionImageView:(NSInteger)currentPage
{
    if (_nowIntroductionImageView.tag != currentPage+777) {
        //先移除不匹配的
        [_nowIntroductionImageView removeFromSuperview];
        //创建
        _nowIntroductionImageView = [[IntroductionImageView alloc] initWithFrame:_introductionSuperView.bounds VideoModel:_videoList[currentPage]];
        [_introductionSuperView addSubview:_nowIntroductionImageView];
        _nowIntroductionImageView.alpha = 1;
    }
}


#pragma mark - 事件处理
//scrollView代理方法
//滑动到左、右子视图时，切换一组视频内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.width;
    //切换视频组，此时不准滑动
    if (self.contentOffset.x != width) {
        self.scrollEnabled = NO;
    }
    
    //判断是已经滑到左边还是右边，然后执行相应的方法
    if (self.contentOffset.x < width/2) {
        [self _changeToPreviousVideoList];
    }
    else if (self.contentOffset.x > width*3/2) {
        [self _changeToNextVideoList];
    }
}


//切换到上一组视频内容
- (void)_changeToPreviousVideoList
{
    //先判断当前需求的数据有没有超出数组，如果超出了，先向上一视图控制器请求数据
    if (self.currentVideoIndex.section == 0) {
        //中间视图显示
        self.contentOffset = CGPointMake(self.width, 0);
        //恢复滑动允许
        self.scrollEnabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已没有更多视频！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //改变索引记录
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentVideoIndex.section-1];
    self.currentVideoIndex = indexPath;
    DailyListModel *dailyListModel = _dailyListModelArray[self.currentVideoIndex.section];
    self.videoList = dailyListModel.videoList;
    self.currentVideoBlock(indexPath, self.videoList[indexPath.row]);
    //根据videoList重新创建视频视图
    [self createVideoScrollView];
    //动画
    [UIView animateWithDuration:1 animations:^{
        //眼珠转动
        CGAffineTransform transform = CGAffineTransformRotate(_leftEyeBall.transform, M_PI);
        _leftEyeBall.transform = transform;
        _leftEyeBall.transform = CGAffineTransformIdentity;
    }];
    //回到中间视图
    [self performSelector:@selector(_recover) withObject:nil afterDelay:1];
}


//切换到下一组视频内容
- (void)_changeToNextVideoList
{
    //self.dailyListModelArray不为空，说明是“每日精选”界面的视频，否则是“往期分类”
    if (self.dailyListModelArray != nil) {
        //先判断当前需求的数据有没有超出数组，如果超出了，先向上一视图控制器请求数据
        if (self.currentVideoIndex.section == self.dailyListModelArray.count-1) {
            //加载数据，并添加到数组中
            NSMutableArray *loadResultArray = self.loadMoreDataBlock();
            //如果请求不成功
            if (loadResultArray == 0) {
                //中间视图显示
                self.contentOffset = CGPointMake(self.width, 0);
                //恢复滑动允许
                self.scrollEnabled = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已没有更多视频！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        //改变索引记录
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentVideoIndex.section+1];
        self.currentVideoIndex = indexPath;
        DailyListModel *dailyListModel = _dailyListModelArray[self.currentVideoIndex.section];
        self.videoList = dailyListModel.videoList;
        self.currentVideoBlock(indexPath, self.videoList[indexPath.row]);
    }
    
    //“往期分类”时
    else
    {
        //先判断当前需求的数据有没有超出数组，如果超出了，先向上一视图控制器请求数据
        if (self.currentVideoIndex.row == self.videoList.count-1) {
            //请求数据，并添加到数组中
            NSMutableArray *loadResultArray = self.loadMoreDataBlock();
            //如果请求不成功
            if (loadResultArray.count == 0) {
                //中间视图显示
                self.contentOffset = CGPointMake(self.width, 0);
                //恢复滑动允许
                self.scrollEnabled = YES;
                return;
            }
        }
        //改变索引记录
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentVideoIndex.row+1 inSection:0];
        self.currentVideoIndex = indexPath;
        self.currentVideoBlock(indexPath, self.videoList[indexPath.row]);
    }

    //转动眼睛
    [UIView animateWithDuration:1 animations:^{
        //眼珠转动
        CGAffineTransform transform = CGAffineTransformRotate(_rightEyeBall.transform, M_PI);
        _rightEyeBall.transform = transform;
        _rightEyeBall.transform = CGAffineTransformIdentity;
    }];
    //根据当前已经变过的videoList重新创建视频视图
    [self createVideoScrollView];
    //视频组切换完成，回到中间视图
    [self performSelector:@selector(_recover) withObject:nil afterDelay:1];
}

//视频组切换完成，回到中间视图
- (void)_recover
{
    //移除已经滑过去的视频介绍视图
    if (_introductionSuperView.subviews.count > 1) {
        //移除已经滑过去的视频介绍视图
        IntroductionImageView *lastIntroductionImageView = _introductionSuperView.subviews[0];
        [lastIntroductionImageView removeFromSuperview];
    }
    //恢复滑动允许
    self.scrollEnabled = YES;
    //中间视图显示
    self.contentOffset = CGPointMake(self.width, 0);
}




@end
