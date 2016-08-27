//
//  PastCell.h
//  梦眼
//
//  Created by imac on 15/10/2.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastModel.h"
@interface PastCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, strong) PastModel *pastModel;

@end
