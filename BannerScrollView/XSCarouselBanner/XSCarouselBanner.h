//
//  XSCarouselBanner.h
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSCarouselBanner : UIView

/**
 * 【使用须知】
 *  本轮播图图片加载，基于SDWebImage
 *  设置在设置图片数组( setBannerWithImageArr: )时必须调用( layoutWithWidth: andHeight: )，否则轮播图显示异常
 */

//初始化视图
/**
 * 设置布局
 * 在设置图片数组时设置 //- (void)setBannerWithImageArr:(NSArray *)imageArr;
 * width:当前视图宽度
 * height:轮播图高度
 */
- (void)layoutWithWidth:(CGFloat)width andHeight:(CGFloat)height;
//通过装载图片URL的数组实例化循环视图
- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr;

/**
 * 设置轮播图显示图片
 * imageArr: 图片数组,imageURL需单独取出来组合数组
 */
- (void)setBannerWithImageArr:(NSArray *)imageArr;
/**
 * 设置轮播图图片点击内容
 * 轮播图需要点击图片显示响应内容时，需使用此方法
 * dataDictArr: 数据字典数组
 */
- (void)setBannerWithDataArr:(NSArray *)dataDictArr;


//设置是否分页（默认YES）
- (void)setPagingEnabled:(BOOL)pagingEnabled;
//启动定时滑动模式
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval;
//停止定时器
- (void)stopTimer;
//设置图片模式
- (void)setImageMode:(UIViewContentMode) mode;

@end
