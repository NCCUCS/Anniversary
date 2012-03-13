//
//  ANAppDelegate.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANAppDelegate.h"

#import "ANTabBarController.h"

@implementation ANAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.098 green:0.200 blue:0.561 alpha:1.000]];
  
  _tabBarController = [[ANTabBarController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
