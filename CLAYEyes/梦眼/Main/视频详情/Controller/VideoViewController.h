//
//  VideoViewController.h
//  梦眼
//
//  Created by imac on 15/10/5.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : MPMoviePlayerViewController{
    MPMoviePlayerController *moviePlayer;
}
@property (nonatomic,copy) NSString *playUrl;


@end
