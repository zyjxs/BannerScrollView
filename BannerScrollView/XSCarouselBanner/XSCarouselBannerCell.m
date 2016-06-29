//
//  XSCarouselBannerCell.m
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import "XSCarouselBannerCell.h"
#import "UIImageView+WebCache.h"

@interface XSCarouselBannerCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation XSCarouselBannerCell

//懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)refreshUI:(NSString *)imageURL
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

- (void)setImageMode:(UIViewContentMode) mode
{
    self.imageView.contentMode = mode;
}

@end
