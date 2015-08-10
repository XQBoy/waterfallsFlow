//
//  WaterFlowLayout.h
//  瀑布流1
//
//  Created by 格式化油条 on 15/8/9.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

@optional;

/** 如果数据中有说明每个cell的高度与宽度，可用此方法计算indexPath对应的cell的高度 */
- (CGFloat)wateFlowLayout:(WaterFlowLayout *) wateFlowLayout heightFowWidth:(CGFloat) width atIndexPath:(NSIndexPath *) indexPath;

@end

@interface WaterFlowLayout : UICollectionViewLayout

/** 每一列的间距,默认为10 */
@property (assign, nonatomic) CGFloat columnMargin;
/** 每一行的间距,默认为10 */
@property (assign, nonatomic) CGFloat rowMargin;
/** 上下左右的间距,默认上下左右均为10 */
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
/** 显示多少列 */
@property (assign, nonatomic) NSInteger columnsCount;
/** 每个cell的高度,默认为150,如果有实现代理方法此属性无效 */
@property (assign, nonatomic) CGFloat cellHeight;
/** 代理对象 */
@property (weak, nonatomic) id<WaterFlowLayoutDelegate> delegate;
@end
