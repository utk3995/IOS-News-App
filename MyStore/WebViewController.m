//
//  WebViewController.m
//  MyStore
//
//  Created by utkarsh.sri on 30/08/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.newsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [_webView loadRequest:request];
    _webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_webView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
