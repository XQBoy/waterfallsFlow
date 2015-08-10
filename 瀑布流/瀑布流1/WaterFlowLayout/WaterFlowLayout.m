//
//  WaterFlowLayout.m
//  瀑布流1
//
//  Created by 格式化油条 on 15/8/9.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()
/** 字典存储的是每一列最大的Y值 */
@property (strong, nonatomic) NSMutableDictionary *maxYDictionary;
/** 存放所有的布局属性 */
@property (strong, nonatomic) NSMutableArray *attributesArray;
@end

@implementation WaterFlowLayout

- (instancetype)init {
    
    self = [super init];
    if (self) {
        /** 默认列间距 */
        self.columnMargin = 10;
        /** 默认行间距 */
        self.rowMargin = 10;
        /** 默认四周边距 */
        self.sectionInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        /** 默认列数 */
        self.columnsCount = 3;
        /** 默认高度 */
        self.cellHeight = 150;
    }
    return self;
}
#pragma mark - 懒加载
- (NSMutableDictionary *)maxYDictionary {
    
    if (!_maxYDictionary) {
        
        _maxYDictionary = [NSMutableDictionary dictionary];
    }
    return _maxYDictionary;
}

- (NSMutableArray *)attributesArray {
    
    if (!_attributesArray) {
        
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

#pragma mark - 每次布局前的准备
- (void)prepareLayout {
    
    [super prepareLayout];
    
    /** 清空最大的Y值 */
    for (NSInteger index = 0; index < self.columnsCount; index++) {
        
        NSString *column = [NSString stringWithFormat:@"%ld",index];
        
        /** 每次重新布局时最大的Y值为上边的边距 */
        self.maxYDictionary[column] = @(self.sectionInsets.top);
    }
    
    /** 计算所有cell的布局属性 */
    
    /** 清空数组数据 */
    [self.attributesArray removeAllObjects];
    
    /** 取出collectionView中有多少个items */
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger index = 0; index < count; index++) {
        
        /** 根据位置设置对应的布局 */
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        [self.attributesArray addObject:attributes];
    }
}

#pragma mark - 只要拖动就会重新刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

#pragma mark - 返回indexPath这个位置item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /** 假设最短的那一列为第0列 */
    __block NSString *minColumn = @"0";
    
    /** 遍历，找出最短的那一列 */
    [self.maxYDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        
        if ([maxY floatValue] < [self.maxYDictionary[minColumn] floatValue]) {
            
            minColumn = column;
        }
    }];
    
    /** 计算每个cell的 x、y、width、height */
    
    CGFloat width =(CGRectGetWidth(self.collectionView.frame) - self.sectionInsets.left - self.sectionInsets.right - (self.columnsCount - 1) * self.columnMargin) / self.columnsCount;
    
    CGFloat height = 0;
    
    /** 判断是否有实现代理方法，如果有就执行并返回计算好的高度,否就按照设置的高度 */
    if ([self.delegate respondsToSelector:@selector(wateFlowLayout:heightFowWidth:atIndexPath:)]) {
        
        height = [self.delegate wateFlowLayout:self heightFowWidth:width atIndexPath:indexPath];
    }
    else {
        
        height = self.cellHeight;
    }
    
    
    CGFloat x = self.sectionInsets.left + (width + self.columnMargin) * [minColumn intValue];
    
    CGFloat y = [self.maxYDictionary[minColumn] floatValue] + self.rowMargin;
    
    /** 更新这一列最大的Y值 */
    self.maxYDictionary[minColumn] = @(y + height);
    
    /** 设置indexPath位置对应的frame */
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.frame = CGRectMake(x, y, width, height);
    
    return attributes;
}

#pragma mark - 返回rect范围内的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributesArray;
}

#pragma mark - 返回能够滚动的范围
- (CGSize)collectionViewContentSize {
    
    /** 假设最长的那一列为第0列 */
    __block NSString *maxColumn = @"0";
    
    /** 遍历，找出最长的那一列 */
    [self.maxYDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        
        if ([maxY floatValue] > [self.maxYDictionary[maxColumn] floatValue]) {
            
            maxColumn = column;
        }
    }];
    
    /** 返回滚动范围，width为0说明不能左右滑动,上下滚动的范围为字典中最大的Y值加上下边的边距 */
    return CGSizeMake(0, [self.maxYDictionary[maxColumn] floatValue] + self.sectionInsets.bottom);
}

@end
