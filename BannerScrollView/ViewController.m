//
//  ViewController.m
//  BannerScrollView
//
//  Created by zyj on 16/6/29.
//  Copyright © 2016年 UIView. All rights reserved.
//

#import "ViewController.h"
#import "FLBanner.h"

@interface ViewController ()

@property (nonatomic, strong) FLBanner *bannerView;
@property (nonatomic, copy) NSDictionary *dict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //------------------------------------------初始化轮播视图----------------------------------------
    self.bannerView = [[FLBanner alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    [self.view addSubview:self.bannerView];
    
    //相关设置
    /*
     //设置是否隐藏pageController（默认NO）
     - (void)setPageControlHidden:(BOOL)isHidden;
     //设置是否重复滚动（默认YES）
     - (void)setRepeatScroll:(BOOL)isRepeat;
     //启动定时滑动模式 (默认2秒)
     - (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval;
     //停止定时器
     - (void)stopTimer;
     */
    
    
    //------------------------------------------请求网络图片----------------------------------------
    //控制台：negative or zero item sizes are not supported in the flow layout
    //为方便，此处使用同步请求数据，数据加载较慢
    NSURL *url = [NSURL URLWithString:@"http://api.hboffice.cn/v1/advert/with/position/1002/group/10001"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    
    //------------------------------------------设置图片数组----------------------------------------
    //将接口中的轮播图片的字段单独获取出来
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *temp in self.dict[@"list"]) {
        [imageArr addObject:temp[@"content"]];
    }
    //设置轮播图图片
    [self.bannerView setBannerWithImageArr:imageArr];
    
    
    //监听banner图的点击通知
    //【 *** 配合XSBanner里的UICollectionView代理方法：didSelectItemAtIndexPath 一起用 *** 】
    //用于点击图片跳转操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(banner:) name:@"banner" object:nil];
}


- (void)banner:(NSNotification *)not{
    //此处可根据项目需求，编写点击图片后需要执行的代码
    //如跳转网页，APP内部跳转等
    NSLog(@"-当前点击图片对应的数据-：%@",self.dict[@"list"][not.object]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
