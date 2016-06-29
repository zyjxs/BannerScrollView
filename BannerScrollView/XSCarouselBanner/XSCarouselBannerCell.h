//
//  XSCarouselBannerCell.h
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSCarouselBannerCell : UICollectionViewCell

- (void)refreshUI:(NSString *)imageURL;
- (void)setImageMode:(UIViewContentMode) mode;

@end
