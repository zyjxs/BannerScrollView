//
//  FLBanner.h
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBanner : UIView

/**
 * 【使用须知】
 *  本轮播图图片加载，基于SDWebImage
 *  建议使用 initWithFrame:(CGRect)frame；方法初始化视图
 *  如果是init方法初始化视图必须调用- (void)layoutWithWidth:(CGFloat)width andHeight:(CGFloat)height，否则轮播图显示异常
 */


/**
 * 设置布局（重点 : 否则无法正常显示效果）
 * width:当前视图宽度
 * height:轮播图高度
 */
- (void)layoutWithWidth:(CGFloat)width andHeight:(CGFloat)height;

/**
 * 设置轮播图显示图片
 * imageArr: 图片数组,imageURL需单独取出来组合数组
 */
- (void)setBannerWithImageArr:(NSArray *)imageArr;


//设置是否隐藏pageController（默认NO）
- (void)setPageControlHidden:(BOOL)isHidden;
//设置是否重复滚动（默认YES）
- (void)setRepeatScroll:(BOOL)isRepeat;
//启动定时滑动模式 (默认2秒)
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval;
//停止定时器
- (void)stopTimer;


@end
