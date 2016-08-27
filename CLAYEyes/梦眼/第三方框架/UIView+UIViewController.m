//
//  UIView+UIViewController.m
//  XSWeiBo
//
//  Created by imac on 15/9/26.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController{
    
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }else{
            next = next.nextResponder;
        }
    } while (next != nil);
    return nil;
}

@end
