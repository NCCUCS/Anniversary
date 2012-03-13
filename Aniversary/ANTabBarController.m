//
//  ANTabBarController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANTabBarController.h"
#import "ANPhotosViewController.h"
#import "ANSettingsViewController.h"
#import "ANNewsViewController.h"
#import "ANMapViewController.h"

@interface ANTabBarController ()

@end

@implementation ANTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.viewControllers = [NSArray arrayWithObjects:
                            [[UINavigationController alloc] initWithRootViewController:[[ANPhotosViewController alloc] initWithStyle:UITableViewStylePlain]],
                            [[UINavigationController alloc] initWithRootViewController:[[ANMapViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UIViewController alloc] initWithNibName:nil bundle:nil], 
                            [[UINavigationController alloc] initWithRootViewController:[[ANNewsViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UINavigationController alloc] initWithRootViewController:[[ANSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]], nil];
  }
  return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
