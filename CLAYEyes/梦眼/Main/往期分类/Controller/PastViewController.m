//
//  PastViewController.m
//  梦眼
//
//  Created by imac on 15/9/30.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "PastViewController.h"
#import "PastCell.h"
#import "DataService.h"
#import "PastModel.h"
#import "PastDetailViewController.h"

@interface PastViewController (){
    NSMutableArray *_dataArray;
}

@end

@implementation PastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatCollection];
    [self _loadPastData];
    //创建导航栏右边的菜单按钮的下拉菜单
    [self createMenuView];
    //创建导航栏按钮
    [self createNavigationBarButton];
    //导航栏标题
    [self createTitleLabel];
}

- (void) _creatCollection{
    //创建布局对象
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    //创建collectionView
    _pastCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    _pastCollectionView.backgroundColor = [UIColor clearColor];
    _pastCollectionView.bounces = NO;
    _pastCollectionView.delegate = self;
    _pastCollectionView.dataSource = self;
    _pastCollectionView.contentInset = UIEdgeInsetsMake(0, 0, -9, 0);
    _pastCollectionView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:_pastCollectionView];
    UINib *nib = [UINib nibWithNibName:@"PastCell" bundle:nil];
    [_pastCollectionView registerNib:nib forCellWithReuseIdentifier:@"PastCellId"];
    
}

- (void)_loadPastData{
    _dataArray = [[NSMutableArray alloc] init];
    [DataService requestAFUrl:@"http://baobab.wandoujia.com/api/v1/categories?vc=125&u=213367ae25cb8116060ddbd038303c56853d00ea&v=1.8.1&f=iphonehttp://baobab.wandoujia.com/api/v1/categories?vc=125&u=213367ae25cb8116060ddbd038303c56853d00ea&v=1.8.1&f=iphone" httpMethod:@"GET" params:nil data:nil block:^(id result) {
  
        for (NSDictionary *dataDic in result) {
            PastModel *model = [[PastModel alloc] initWithDataDic:dataDic];
            [_dataArray addObject:model];
        }
        [self.pastCollectionView reloadData];
    }];
    
    
}

#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PastCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PastCellId" forIndexPath:indexPath];
    PastModel *model = _dataArray[indexPath.row];
    cell.pastModel = model;
    cell.backgroundColor = [UIColor blackColor];
    cell.layer.contentsRect = CGRectMake(0, 0, 0, 0);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(kScreenWidth/2-1, kScreenWidth/2-1);
    return size;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PastModel *model = _dataArray[indexPath.row];
    NSString *name = model.name;
    NSData *data = [name dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str2 = [data description];
    
    NSString *str3 = [str2 substringFromIndex:1];
    NSString *str4 = [str3 substringToIndex:8];
    NSString *str5 = [str3 substringFromIndex:9];
    NSString *str6 = [str5 substringToIndex:4];
    NSString *string = [str4 stringByAppendingString:str6];
    NSString *string2 = [string uppercaseString];
    NSMutableString *parameterString = [[NSMutableString alloc] initWithString:string2];
    [parameterString insertString:@"%" atIndex:0];
    [parameterString insertString:@"%" atIndex:3];
    [parameterString insertString:@"%" atIndex:6];
    [parameterString insertString:@"%" atIndex:9];
    [parameterString insertString:@"%" atIndex:12];
    [parameterString insertString:@"%" atIndex:15];

    PastDetailViewController *vc = [[PastDetailViewController alloc] initWithParameterString:parameterString Title:name];
    [self.navigationController pushViewController:vc animated:NO];
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   return YES;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
