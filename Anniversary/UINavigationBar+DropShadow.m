//
//  UINavigationBar+DropShadow.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/26/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "UINavigationBar+DropShadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (DropShadow)

- (void)willMoveToWindow:(UIWindow *)newWindow{
  [super willMoveToWindow:newWindow];
  [self applyDefaultStyle];
}

- (void)applyDefaultStyle {
  // add the drop shadow
  self.layer.shadowColor = [[UIColor blackColor] CGColor];
  self.layer.shadowOffset = CGSizeMake(0.0, 2.5);
  self.layer.shadowOpacity = 0.25;
  self.layer.masksToBounds = NO;
  self.layer.shouldRasterize = YES;
}


@end
