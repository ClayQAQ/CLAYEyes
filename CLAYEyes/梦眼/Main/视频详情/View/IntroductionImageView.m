//
//  IntroductionImageView.m
//  梦眼
//
//  Created by imac on 15/10/3.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "IntroductionImageView.h"
#import "UIImageView+WebCache.h"

@implementation IntroductionImageView

- (instancetype)initWithFrame:(CGRect)frame VideoModel:(VideoModel *)videoModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _videoModel = videoModel;
        //设置背景图
        NSURL *imageUrl = [NSURL URLWithString:_videoModel.coverBlurred];
        [self sd_setImageWithURL:imageUrl];
        //添加一层半透明黑色图层，使文字更加清晰
        _blackBackground = [[UIView alloc] initWithFrame:self.bounds];
        _blackBackground.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:_blackBackground];
        //创建文字label
        [self _createLabel];
        //赋予标题文字
        _titleLabel.text = videoModel.title;
        [_titleLabel sizeToFit]; //调整label宽度，添加标题下划线的时候需要此宽度数据
        //标题下划线
        [self _createLines];
        //赋予分类与视频时长文字
        NSInteger time = [_videoModel.duration integerValue];
        NSString *timeString = [NSString stringWithFormat:@"%li'%li\"",time/60,time%60];
        NSString *string = [NSString stringWithFormat:@"#%@  /  %@",_videoModel.category,timeString];
        _videoTypeLabel.text = string;
        //赋予视频详情介绍文字
        _introductionLabel.text = videoModel.introduction;
        //调整label高度，使label文字往上靠拢
        [_introductionLabel sizeToFit];
        //刚开始透明度为0
        self.alpha = 0;
    }
    return self;
}


//创建视频介绍label
- (void)_createLabel
{
    //创建titleLabel
    _titleLabel = [[TyperLabel alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth, 20)];
    _titleLabel.textColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:16];
    _titleLabel.typewriteEffectColor = [UIColor whiteColor];
    [_blackBackground addSubview:_titleLabel];
    
    //创建videoTypeLabel
    _videoTypeLabel = [[TyperLabel alloc] initWithFrame:CGRectMake(15, 55, kScreenWidth, 15)];
    _videoTypeLabel.textColor = [UIColor clearColor];
    _videoTypeLabel.numberOfLines = 0;
    _videoTypeLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:12];
    _videoTypeLabel.typewriteEffectColor = [UIColor whiteColor];
    [_blackBackground addSubview:_videoTypeLabel];
    
    //创建introductionLabel
    _introductionLabel = [[TyperLabel alloc] initWithFrame:CGRectMake(15, 80, kScreenWidth-30, 150)];
    _introductionLabel.textColor = [UIColor clearColor];
    _introductionLabel.numberOfLines = 0;
    _introductionLabel.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:12];
    _introductionLabel.typewriteEffectColor = [UIColor whiteColor];
    [_blackBackground addSubview:_introductionLabel];
}

//打字动画开始
- (void)_startType
{
    [_titleLabel startTypewrite];
    [_videoTypeLabel startTypewrite];
    [_introductionLabel startTypewrite];
}

//覆写不透明度set方法，检测到不透明度为1时执行打字动画
- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    if (self.alpha == 1) {
        [self _startType];
    }
}

//添加标题下方分隔线
- (void)_createLines
{
    CGFloat width = _titleLabel.width - _titleLabel.font.pointSize * 2.5;
    UIView *viewLines = [[UIView alloc] initWithFrame:CGRectMake(15, 45, width, 0.6)];
    viewLines.backgroundColor = [UIColor whiteColor];
    [_blackBackground addSubview:viewLines];
}

@end
