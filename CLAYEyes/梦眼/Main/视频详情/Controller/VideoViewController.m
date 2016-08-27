//
//  VideoViewController.m
//  梦眼
//
//  Created by imac on 15/10/5.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0,kScreenHeight, kScreenWidth);
    self.view.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    [self.view setTransform:transform];
    
    NSString *url = _playUrl;
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *movieUrl = [[NSURL alloc] initWithString:urlString];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    float Height = [[self view] bounds].size.height;
    float width = [[self view] bounds].size.width;
    [[moviePlayer view] setFrame:CGRectMake(0, 0, width, Height)];

    moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    [[self view] addSubview:[moviePlayer view]];
    [moviePlayer play];

    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(-20, -20, 100, 100)];
    [back setImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
