//
//  ANAppDelegate.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANTabBarController;

@interface ANAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ANTabBarController *tabBarController;

@property (strong, nonatomic) Facebook *facebook;

@end
