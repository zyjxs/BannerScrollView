//
//  XSCarouselBanner.m
//  轮播图
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 zyj. All rights reserved.
//

#import "XSCarouselBanner.h"
#import "XSCarouselBannerCell.h"

#define PAGECONTROL_HEIGHT 10
#define PAGEINDICATOR_WIDTH 20

@interface XSCarouselBanner () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat time;   //定时器时间
@property (nonatomic, assign) BOOL isStartTimer;   //是否开始定时器
@property (nonatomic, copy) NSMutableArray *dataArr;   //图片URL数组
@property (nonatomic, copy) NSMutableArray *detailArr;   //内容数组
@property (nonatomic, strong) NSMutableDictionary *dict;   //图片数组中元素的字典，用于设置currentPage
@property (nonatomic, assign) UIViewContentMode mode;
@property (nonatomic, assign) BOOL isChangeMode;


@end

@implementation XSCarouselBanner

//懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        self.layout.itemSize = CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册cell
        [_collectionView registerClass:[XSCarouselBannerCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
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
- (NSMutableArray *)detailArr {
    if (!_detailArr) {
        _detailArr = [[NSMutableArray alloc] init];
    }
    return _detailArr;
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
        //添加视图
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArr {
    self = [super initWithFrame:frame];
    if (self) {
        if (imageArr.count >= 3) {            [self.dataArr addObjectsFromArray:imageArr];
            [self addSubview:self.collectionView];
        }else{
            NSLog(@"_____【%@】_Error : 图片少于三张!",[self class]);
        }
    }
    return self;
}

/**
 * 重点：必须调用此方法，否则UI会出现问题
 */
- (void)layoutWithWidth:(CGFloat)width andHeight:(CGFloat)height {
    //重新布置视图大小
    if (width > 375) {  //5.5
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width - 0.25, height + 10);
    }else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width - 0.5, height + 10);
    }
    
    self.collectionView.frame = CGRectMake( 0, 0, width, height);
    self.layout.itemSize = CGSizeMake(width, height);
    //设置pageControl的位置
    self.pageControl.frame = CGRectMake(width - PAGEINDICATOR_WIDTH * self.dataArr.count, self.collectionView.frame.size.height - 20, PAGEINDICATOR_WIDTH * self.dataArr.count, PAGECONTROL_HEIGHT);
    //刷新UI
    [self.collectionView reloadData];
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
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width+0.5, 0) animated:YES] ;
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

#pragma mark - 数据相关

//设置图片数据
- (void)setBannerWithImageArr:(NSArray *)imageArr {
    /**
     *  图片数组,数据加载以及pageController相关设置
     */
    //清空数组
    if (self.dataArr.count != 0 )
       [self.dataArr removeAllObjects];
    //设置图片数组
    [self.dataArr addObjectsFromArray:imageArr];
    
    //当图片数组只有一个元素时，停止定时器
    if (self.dataArr.count == 1) {
        [self stopTimer];
    }
    //将数组中得数据赋予key,方便设置pageControl.currentPage
    for (NSInteger i = 0; i< self.dataArr.count ; i++)
        [self.dict setValue:self.dataArr[i] forKey:[NSString stringWithFormat:@"%zd",i]];
    
    //设置最大的图片的个数
    self.pageControl.numberOfPages = self.dataArr.count;
    //设置pageControl的位置
    self.pageControl.frame = CGRectMake(self.collectionView.frame.size.width/2 - (20 * self.dataArr.count/2), self.collectionView.frame.size.height - 10, 20 * self.dataArr.count, 10);
    
    //刷新UI
    [self.collectionView reloadData];
}

- (void)setBannerWithDataArr:(NSArray *)dataDictArr {
    //设置点击图片的内容链接数组
    if (self.detailArr.count != 0) {
        [self.detailArr removeAllObjects];
    }
    [self.detailArr addObjectsFromArray:dataDictArr];
    //刷新UI
    [self.collectionView reloadData];
}


#pragma mark - 滑动相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

//只要有滚动，就会调整函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataArr.count != 0) {
        
        if (scrollView == self.collectionView) {
            
            //向左滑动
            if (_collectionView.contentOffset.x > self.frame.size.width ) {
                //先保存数组的第一张图片
                NSArray *tempArr = @[self.dataArr[0]];
                
                for (NSInteger i = 0; i < self.dataArr.count; i++ ) {
                    if(i == self.dataArr.count -1){
                        self.dataArr[i] = tempArr[0];
                    }else{
                        self.dataArr[i] = self.dataArr[i+1];
                    }
                }
                
                //立即跳回第一页
                scrollView.contentOffset = CGPointZero;
                //刷新UI
                [_collectionView reloadData];
                
            }
            //向右滑动
            else if(_collectionView.contentOffset.x < 0){
                
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
                scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
                //刷新UI
                [_collectionView reloadData];
                
            }
        }
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
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isStartTimer) {
        [self startTimerWithTimeInterval:self.time];
    }
}


#pragma mark - UICollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XSCarouselBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell refreshUI:self.dataArr[indexPath.item]];
    if (self.isChangeMode) {
        [cell setImageMode:self.mode];
    }
    return cell;
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr != nil && self.dataArr.count > 0) {
        NSString *index = [NSString stringWithFormat:@"%zd",self.pageControl.currentPage];
        //通知中心
        [[NSNotificationCenter defaultCenter] postNotificationName:@"banner" object:index];
    }
}


@end
