//
//  ANNewsController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 5/14/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import "ANNewsController.h"

@interface ANNewsController ()

@end

@implementation ANNewsController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self openURL:[NSURL URLWithString:@"https://touch.facebook.com/nccu85?v=feed"]];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh handler:^(id sender){
    [self openURL:[NSURL URLWithString:@"https://touch.facebook.com/nccu85?v=feed"]];
  }];
}

@end
