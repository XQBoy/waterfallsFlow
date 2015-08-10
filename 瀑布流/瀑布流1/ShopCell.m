//
//  ShopCell.m
//  瀑布流1
//
//  Created by 格式化油条 on 15/8/9.
//  Copyright (c) 2015年 格式化油条. All rights reserved.
//

#import "ShopCell.h"
#import "ShopModel.h"
#import "UIImageView+WebCache.h"
@interface ShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setShop:(ShopModel *)shop {
    
    _shop = shop;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img]];
}

@end
