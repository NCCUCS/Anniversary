//
//  main.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ANAppDelegate.h"
#import "QTouchposeApplication.h"

int main(int argc, char *argv[])
{
  @autoreleasepool {
      return UIApplicationMain(argc, argv,
                               NSStringFromClass([QTouchposeApplication class]),
                               NSStringFromClass([ANAppDelegate class]));
  }
}
