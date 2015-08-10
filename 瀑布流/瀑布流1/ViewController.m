//
//  ViewController.m
//  瀑布流1
//
//  Created by 格式化油条 on 15/8/9.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"
#import "ShopCell.h"
#import "MJExtension.h"
#import "ShopModel.h"
#import "MJRefresh.h"
@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *shops;
@end

@implementation ViewController
static NSString *const cellIdentifier = @"shop";

- (NSMutableArray *)shops {
    
    if (!_shops) {
        
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *shopArray = [ShopModel objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shopArray];
    
    /** 创建自定义的流水布局 */
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    
    /** 如果数据中没有说明详细数据(宽度与高度),既可以用此属性设置每个cell的高度 */
//    layout.cellHeight = 130;
    
    layout.delegate = self;
    
    /** 创建collectionView */
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor grayColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    /** 下拉刷新 */
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    /** 上拉刷新 */
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

#pragma mark - 加载更多数据
- (void)loadMoreData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *shopArray = [ShopModel objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shopArray];
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    });
}


#pragma mark - WaterFlowLayoutDelegate 

/** 在此方法内根据模型中的数据计算比例后与传入的宽度求出对应的高度 */
- (CGFloat)wateFlowLayout:(WaterFlowLayout *)wateFlowLayout heightFowWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    
    ShopModel *shop = self.shops[indexPath.item];
    
    return shop.h / shop.w * width;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",indexPath.item);
}

@end
