//
//  WebViewController.h
//  MyStore
//
//  Created by utkarsh.sri on 30/08/18.
//  Copyright © 2018 utkarsh.sri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController <WKNavigationDelegate>

@property(strong,nonatomic) WKWebView *webView;

@property (strong, nonatomic) NSString *newsURL;

@end
