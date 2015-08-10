//
//  ShopModel.h
//  瀑布流1
//
//  Created by 格式化油条 on 15/8/9.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopModel : NSObject
@property (assign, nonatomic) CGFloat w;
@property (assign, nonatomic) CGFloat h;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *price;
@end
