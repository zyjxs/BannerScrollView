//
//  ViewController.m
//  BannerScrollView
//
//  Created by zyj on 16/6/29.
//  Copyright © 2016年 UIView. All rights reserved.
//

#import "ViewController.h"
#import "XSCarouselBanner.h"
#import "WebViewController.h"

@interface ViewController ()

@property (nonatomic, strong) XSCarouselBanner *bannerView;
@property (nonatomic, copy) NSDictionary *dict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化轮播视图
    self.bannerView = [[XSCarouselBanner alloc] init];
    //设置切换时间
    [self.bannerView startTimerWithTimeInterval:4.0f];
    [self.view addSubview:self.bannerView];
    
    //请求网络图片
    //控制台：negative or zero item sizes are not supported in the flow layout
    //为方便，此处使用同步请求数据，数据加载较慢
    NSURL *url = [NSURL URLWithString:@"http://182.254.231.237/interface/banner.php?action=getBanner"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //设置图片数组
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *d in self.dict[@"data"]) {
        [imageArr addObject:d[@"out_url"]];
    }
    
    //设置轮播图图片
    [self.bannerView setBannerWithImageArr:imageArr];
    //设置轮播图大小
    [self.bannerView layoutWithWidth:self.view.frame.size.width andHeight:180];
    
    
    //监听banner图的点击通知
    //用于使用点击图片跳转操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNot:) name:@"banner" object:nil];
    
}


- (void)receiveNot:(NSNotification *)not{
    NSInteger index = [[NSString stringWithFormat:@"%@",not.object] integerValue];
    NSDictionary *dict = self.dict[@"data"][index];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.url = dict[@"link_url"];
    [self presentViewController:webVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
