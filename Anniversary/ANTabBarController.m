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
#import "ANCaptureViewController.h"

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

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImage *buttonImage = [UIImage imageNamed:@"capture-button"];
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button addTarget:self action:@selector(captureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0) {
    button.center = self.tabBar.center;
  } else {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  
  [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private

- (void)captureButtonClicked:(id)sender {
  [self.selectedViewController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANCaptureViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
}

@end
