//
//  TabBarBackgroundView.m
//  梦眼
//
//  Created by imac on 15/9/29.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "TabBarBackgroundView.h"

@implementation TabBarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self _drawLine:context];
}

//在view上面正中间画一道竖杠
- (void)_drawLine:(CGContextRef)context
{
    //创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 0.5);
    //绘制
    CGPathMoveToPoint(path, NULL, self.width / 2, self.height / 4);
    CGPathAddLineToPoint(path, NULL, self.width / 2, self.height * 3 / 4);
    CGContextAddPath(context, path);
    [[UIColor grayColor] setStroke];
    //在上下文中绘制线条
    CGContextDrawPath(context, kCGPathStroke);
    //释放
    CGPathRelease(path);
}

@end
