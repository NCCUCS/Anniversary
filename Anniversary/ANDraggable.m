//
//  ANDraggable.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 5/2/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANDraggable.h"
#import <QuartzCore/QuartzCore.h>

@implementation ANDraggable

@synthesize pinchRecognizer = _pinchRecognizer;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self addGestureRecognizer:_pinchRecognizer];
  }
  return self;
}

#pragma mark - Private

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
  if(recognizer.state == UIGestureRecognizerStateBegan) {
    // Reset the last scale, necessary if there are multiple objects with different scales
    _lastScale = recognizer.scale;
  } else {
    CGFloat currentScale = [[recognizer.view.layer valueForKeyPath:@"transform.scale"] floatValue];
    
    // Constants to adjust the max/min values of zoom
    const CGFloat kMaxScale = 3;
    const CGFloat kMinScale = 0.5;
    
    CGFloat newScale = 1 -  (_lastScale - recognizer.scale); // new scale is in the range (0-1)
    newScale = MIN(newScale, kMaxScale / currentScale);
    newScale = MAX(newScale, kMinScale / currentScale);
    CGAffineTransform transform = CGAffineTransformScale(recognizer.view.transform, newScale, newScale);
    recognizer.view.transform = transform;
    
    _lastScale = recognizer.scale;  // Store the previous scale factor for the next pinch gesture call
  }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
