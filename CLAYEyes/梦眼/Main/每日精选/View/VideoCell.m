//
//  VideoCell.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
@implementation VideoCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor blackColor];
}


- (void)setVideoModel:(VideoModel *)VideoModel{
    _VideoModel = VideoModel;
    _title.text = _VideoModel.title;
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont fontWithName:@"FZLTZCHJW--GB1-0" size:16];
    NSInteger time = [_VideoModel.duration integerValue];
    NSString *timeString = [NSString stringWithFormat:@"%li'%li\"",time/60,time%60];
    NSString *string = [NSString stringWithFormat:@"#%@  /  %@",_VideoModel.category,timeString];
    _categoryAndTime.text = string;
    _categoryAndTime.textColor = [UIColor whiteColor];
    _categoryAndTime.font = [UIFont fontWithName:@"FZLTXIHJW--GB1-0" size:12];

    NSURL *url = [NSURL URLWithString:_VideoModel.coverForDetail];
    
    // 通过一个URL自动加载网络图片
    _videoImageView.alpha = 0.7;
    _videoImageView.layer.masksToBounds = YES;
    [_videoImageView sd_setImageWithURL:url];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
