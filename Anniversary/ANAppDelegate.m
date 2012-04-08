//
//  ANAppDelegate.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANAppDelegate.h"
#import "ANTabBarController.h"
#import "Facebook.h"

@implementation ANAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize facebook = _facebook;

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // Setup UIAppearance
  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
  [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.541 green:0.710 blue:0.882 alpha:1.000]];
  
  // Setup Facebook
  _facebook = [[Facebook alloc] initWithAppId:kAPI_KEY_FACEBOOK andDelegate:self];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"] 
      && [defaults objectForKey:@"FBExpirationDateKey"]) {
    _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
  }
  
  // Setup view controllers
  _tabBarController = [[ANTabBarController alloc] initWithNibName:nil bundle:nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [_facebook extendAccessTokenIfNeeded];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [_facebook handleOpenURL:url]; 
}

#pragma mark - FBSessionDelegate

- (void)fbDidLogin {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:_facebook.accessToken forKey:@"FBAccessTokenKey"];
  [defaults setObject:_facebook.expirationDate forKey:@"FBExpirationDateKey"];
  [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {

}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
  [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
  [defaults synchronize];
}

- (void)fbDidLogout {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"]) {
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
  }
}

- (void)fbSessionInvalidated {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:@"FBAccessTokenKey"]) {
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
  }
}

@end
