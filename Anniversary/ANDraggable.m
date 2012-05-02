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
@synthesize rotationRecognizer = _rotationRecognizer;
@synthesize tapRecognizer = _tapRecognizer;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    _pinchRecognizer.delegate = self;
    [self addGestureRecognizer:_pinchRecognizer];
    _rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    _rotationRecognizer.delegate = self;
    [self addGestureRecognizer:_rotationRecognizer];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:_tapRecognizer];
  }
  return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  return YES;
}

#pragma mark - Private

- (void)handleRotation:(UIRotationGestureRecognizer *)recognizer {
	if(recognizer.state == UIGestureRecognizerStateEnded) {
		_lastRotation = 0.0;
		return;
	}
  
	CGFloat rotation = 0.0 - (_lastRotation - recognizer.rotation);
  
	recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, rotation);

	_lastRotation = recognizer.rotation;
}

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

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
  if ([self.delegate respondsToSelector:@selector(draggableObjectDidMove:)]) {
    [self.delegate draggableObjectDidMove:self];
  }
}

@end
