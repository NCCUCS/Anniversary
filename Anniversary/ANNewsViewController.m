//
//  ANNewsViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANNewsViewController.h"
#import "SVProgressHUD.h"

@interface ANNewsViewController ()

@end

@implementation ANNewsViewController

@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"最新消息";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleView"]];
    self.tabBarItem.image = [UIImage imageNamed:@"32-speechbubble"];
  }
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://touch.facebook.com/nccu85?v=feed"]]];
  _webView.delegate = self;
  
  _webView.shouldStartLoadBlock = ^(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType type){
    if (type == UIWebViewNavigationTypeReload) {
      webView.tag = 0;
    }
    
    return YES;
  };
  
  _webView.didStartLoadBlock = ^(UIWebView *webView){
    webView.tag++;
    if (webView.tag == 1) {
      [SVProgressHUD showWithStatus:@"讀取中"];
    }
  };
  
  _webView.didFinishLoadBlock = ^(UIWebView *webView){
    webView.tag--;
    if (webView.tag <= 0) {
      [SVProgressHUD dismiss];
      webView.tag = 100; // Make it not shown again.
    }
  };
  
  _webView.didFinishWithErrorBlock = ^(UIWebView *webView, NSError *error){
    [SVProgressHUD dismissWithError:@"連線錯誤"];
  };
  
  [self.view addSubview:_webView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:_webView action:@selector(reload)];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _webView.delegate = nil;
  _webView = nil;
}


@end
