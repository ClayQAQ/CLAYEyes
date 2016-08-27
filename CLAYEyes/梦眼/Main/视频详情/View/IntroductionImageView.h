//
//  IntroductionImageView.h
//  梦眼
//
//  Created by imac on 15/10/3.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TyperLabel.h"
#import "VideoModel.h"

@interface IntroductionImageView : UIImageView

@property (nonatomic,strong) TyperLabel *titleLabel; //上面label，标题
@property (nonatomic,strong) TyperLabel *videoTypeLabel; //中间label，视频类型
@property (nonatomic,strong) TyperLabel *introductionLabel; //下面label，展示介绍文字
@property (nonatomic,strong) VideoModel *videoModel; //视频数据
@property (nonatomic,strong) UIView *blackBackground; //添加一层半透明黑色图层，使文字更加清晰

- (instancetype)initWithFrame:(CGRect)frame VideoModel:(VideoModel *)videoModel;

@end
