//
//  PastViewController.h
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"

@interface PastViewController : BaseViewController<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView      *pastCollectionView;    //往期分类

@end
