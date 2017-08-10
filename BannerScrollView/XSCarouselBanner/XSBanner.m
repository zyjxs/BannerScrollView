//
//  XSBanner.m
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import "XSBanner.h"
#import "XSBannerCell.h"

#define PAGECONTROL_HEIGHT 10
#define PAGEINDICATOR_WIDTH 20

@interface XSBanner () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat time;   //定时器时间
@property (nonatomic, assign) BOOL isStartTimer;   //是否开始定时器
@property (nonatomic, copy) NSMutableArray *dataArr;   //图片URL数组
@property (nonatomic, strong) NSMutableDictionary *dict;   //图片数组中元素的字典，用于设置currentPage
@property (nonatomic, assign) UIViewContentMode mode;
@property (nonatomic, assign) BOOL isChangeMode;
@property (nonatomic, assign) BOOL isRepeat;

@end

@implementation XSBanner

//懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //实例化一个系统的瀑布流布局对象
        _layout = [[UICollectionViewFlowLayout alloc] init];
        //修改滑动方向
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置行间距
        _layout.minimumLineSpacing = 0;
        
        //实例化一个UICollectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        //设置背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        //以整页的方式切换
        _collectionView.pagingEnabled = YES;
        //隐藏滑动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //修改cell的大小
        _layout.itemSize = CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册cell
        [_collectionView registerClass:[XSBannerCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        //创建UIPageControl
        _pageControl = [[UIPageControl alloc] init];
        //设置每一个点得颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //设置选中点得颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        //设置初始的选项,索引从0开始
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

#pragma mark - UI相关

//初始化视图
- (instancetype)init {
    self = [super init];
    if (self) {
        //默认重复滚动
        self.isRepeat = YES;
        //默认切换时间
        [self startTimerWithTimeInterval:2.0f];
        //添加视图
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //默认重复滚动
        self.isRepeat = YES;
        //默认切换时间
        [self startTimerWithTimeInterval:2.0f];
        //添加视图
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self layoutWithWidth:frame.size.width andHeight:frame.size.height];
    }
    return self;
}

/**
 * 重点：必须调用此方法，否则UI会出现问题
 */
- (void)layoutWithWidth:(CGFloat)width andHeight:(CGFloat)height {
    //重新布置视图大小
    //防止pageControl.currentPage无法对上，宽度减去对应长度
    if (width > 375)   //5.5
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width-0.25, height);
    else
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width-0.5, height);
    
    self.collectionView.frame = CGRectMake( 0, 0, width, height);
    self.layout.itemSize = CGSizeMake(width, height);
    //设置pageControl的位置
    self.pageControl.frame = CGRectMake(width-PAGEINDICATOR_WIDTH*self.dataArr.count, height-20, PAGEINDICATOR_WIDTH*self.dataArr.count, PAGECONTROL_HEIGHT);
    //刷新UI
    [self.collectionView reloadData];
}

#pragma mark - 数据相关

//设置图片数据
- (void)setBannerWithImageArr:(NSArray *)imageArr {
    /**
     *  图片数组,数据加载以及pageController相关设置
     */
    //清空数组
    if (self.dataArr.count != 0)
        [self.dataArr removeAllObjects];
    //设置图片数组
    if (imageArr.count != 0) {
        [self.dataArr addObjectsFromArray:imageArr];
        
        //当图片数组只有一个元素时，停止定时器
        if (self.dataArr.count == 1)
            [self stopTimer];
        
        //将数组中得数据赋予key,方便设置pageControl.currentPage
        for (NSInteger i = 0; i< self.dataArr.count ; i++)
            [self.dict setValue:self.dataArr[i] forKey:[NSString stringWithFormat:@"%zd",i]];
        
        //设置最大的图片的个数
        self.pageControl.numberOfPages = self.dataArr.count;
        //设置pageControl的位置
        CGRect rect = self.pageControl.frame;
        rect.origin.x = self.collectionView.frame.size.width/2-(PAGEINDICATOR_WIDTH*self.dataArr.count/2);
        rect.size.width =  PAGEINDICATOR_WIDTH*self.dataArr.count;
        self.pageControl.frame = rect;
        if (self.dataArr.count == 1)
            self.pageControl.hidden = YES;
        
        //刷新UI
        [self.collectionView reloadData];
    }
}


#pragma mark - 定时器

//启动定时器
-(void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    self.isStartTimer = YES;
    self.time = timeInterval; //记录定时器切换时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    //防止定时器与主线程阻塞
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerClick {
    //当执行此代码时，第二张图片已经调到图片数组中第一个位置，偏移量也变为CGPointZero
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width+0.5, 0) animated:YES];
}

//停止定时器
- (void)stopTimer {
    self.isStartTimer = NO;
    [self.timer invalidate];
}

#pragma mark - 其他设置

//设置是否分页
-(void)setPagingEnabled:(BOOL)pagingEnabled {
    self.collectionView.pagingEnabled = pagingEnabled;
}

- (void)setImageMode:(UIViewContentMode) mode {
    self.mode = mode;
    self.isChangeMode = YES;
}

//设置是否显示pageController
- (void)setPageControlHidden:(BOOL)isHidden {
    self.pageControl.hidden = isHidden;
}

- (void)setRepeatScroll:(BOOL)isRepeat {
    self.isRepeat = isRepeat;
}

#pragma mark - 滑动相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

//主要逻辑
//只要有滚动，就会调整函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataArr.count != 0 ) {
        if (scrollView == self.collectionView) {
            if (self.isRepeat) {
                //向左滑动
                //当_collectionView.contentOffset.x > 375，即indexPath.item=1的图片已经全部显示完
                if (_collectionView.contentOffset.x > self.frame.size.width ) {
                    //先保存数组的第一张图片
                    NSArray *tempArr = @[self.dataArr[0]];
                    for (NSInteger i = 0; i < self.dataArr.count; i++ ) {
                        //把数组中得元素向前移1位
                        //每次只移一位，保证控制修改self.dataArr[indexPath.item == 1]前的图片跟 修改后self.dataArr[0]的图片一样
                        //最后两位存入事先保存的1张图片
                        if(i == self.dataArr.count -1){
                            self.dataArr[i] = tempArr[0];
                        }else{
                            self.dataArr[i] = self.dataArr[i+1];
                        }
                    }
                    //当_collectionView.contentOffset.x > 375，即indexPath.item=1的图片已经全部显示完
                    //立即跳回第一页
                    scrollView.contentOffset = CGPointZero;
                    //刷新UI
                    [_collectionView reloadData];
                }
                //向右滑动
                //当_collectionView.contentOffset.x < 0时，立即显示数组中得最后一张图片
                else if(_collectionView.contentOffset.x < 0) {
                    //先保存最后一张图片
                    NSArray *tempArr = @[[self.dataArr lastObject]];
                    for (NSInteger i = self.dataArr.count - 1; i >= 0 ; i-- ) {
                        //把事先保存的最后两张图放到，前两位:数组中第一张，设置为最后一张
                        if(i == 0){
                            self.dataArr[i] = tempArr[0];
                        }else{
                            //元素全部往后移1位
                            self.dataArr[i] = self.dataArr[i-1];
                        }
                    }
                    //当_collectionView.contentOffset.x < 0时，立即跳到第二张图片显示的位置
                    //此时数组已经被修改该，CGPointMake(375, 0)的图片已经被修改该成,数组修改后的self.dataArr[1];即被向后移了一位的1.jpg
                    scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
                    //刷新UI
                    [_collectionView reloadData];
                }
            }
        }
        if (self.isRepeat) {
            //设置pageControl.currentPage
            for (NSString *value in self.dict.allValues) {
                if ([self.dataArr[0] isEqualToString:value]) {
                    for (NSString *key in self.dict.allKeys) {
                        if ([self.dict[key] isEqualToString:self.dataArr[0]]) {
                            self.pageControl.currentPage = key.integerValue;
                        }
                    }
                }
            }
        }else {
            self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isStartTimer)
        [self startTimerWithTimeInterval:self.time];
}

#pragma mark - UICollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell refreshUI:self.dataArr[indexPath.item]];
    if (self.isChangeMode)
        [cell setImageMode:self.mode];
    return cell;
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"banner" object:@(self.pageControl.currentPage)];
}


@end
