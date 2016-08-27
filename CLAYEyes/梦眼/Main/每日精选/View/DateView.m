//
//  DateView.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DateView.h"

@implementation DateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 10, 100, 30)];
        _dateLabel.text = @"Sep.29";
        _dateLabel.font = [UIFont fontWithName:@"Lobster 1.4" size:14];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }
    return self;
}

@end
