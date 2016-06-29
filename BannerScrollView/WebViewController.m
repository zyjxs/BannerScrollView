//
//  WebViewController.m
//  BannerScrollView
//
//  Created by zyj on 16/6/29.
//  Copyright © 2016年 UIView. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    NSURL *url2 = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url2];
    [webView loadRequest:request];
    
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 50, 60, 30)];
    returnButton.layer.cornerRadius = 15;
    [returnButton setBackgroundColor:[UIColor purpleColor]];
    [returnButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setTitle:@"return" forState:UIControlStateNormal];
    [webView addSubview:returnButton];
}

- (void)returnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
