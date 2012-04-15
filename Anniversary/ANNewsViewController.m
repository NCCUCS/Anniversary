//
//  ANNewsViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANNewsViewController.h"

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

- (void)loadView {
  [super loadView];
  
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/nccu85"]]];
  [self.view addSubview:_webView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:_webView action:@selector(reload)];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _webView = nil;
}

@end
