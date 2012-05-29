//
//  ANDraggable.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 5/2/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import "SEDraggable.h"

@interface ANDraggable : SEDraggable {
  CGFloat _lastScale;
  CGFloat _lastRotation;
}

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end
