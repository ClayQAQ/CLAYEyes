//
//  TyperLabel.m
//  梦眼
//
//  Created by imac on 15/10/3.
//  Copyright (c) 2015年 imac. All rights reserved.
//


#import "TyperLabel.h"

@implementation TyperLabel

-(void)startTypewrite
{
    self.currentIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(outPutWord:) userInfo:nil repeats:YES];
}

-(void)outPutWord:(id)atimer
{
    if (self.text.length == self.currentIndex) {
        [atimer invalidate];
    }
    else{
        self.currentIndex++;
        NSDictionary *dic = @{NSForegroundColorAttributeName: self.typewriteEffectColor};
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:self.text];
        [mutStr addAttributes:dic range:NSMakeRange(0, self.currentIndex)];
        [self setAttributedText:mutStr];
    }
}



@end
