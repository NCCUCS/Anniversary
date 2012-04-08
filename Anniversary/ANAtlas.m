//
//  ANAtlas.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 3/18/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANAtlas.h"
#import "ANAppDelegate.h"

@implementation ANAtlas

+ (Facebook *)sharedFacebook {
  return [(ANAppDelegate *)[[UIApplication sharedApplication] delegate] facebook];
}

@end
