//
//  TyperLabel.h
//  梦眼
//
//  Created by imac on 15/10/3.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TyperLabel : UILabel

//开始打印的位置索引，默认为0，即从头开始
@property (nonatomic) int currentIndex;

//输入字体的颜色
@property (nonatomic, strong) UIColor *typewriteEffectColor;

//开始打印
-(void)startTypewrite;

@end
