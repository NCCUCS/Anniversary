//
//  ANPhoto.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import "ANPhoto.h"

@implementation ANPhoto

@synthesize objectID = _objectID;
@synthesize photoDescription = _photoDescription;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;
@synthesize imageURL = _imageURL;
@synthesize thumbURL = _thumbURL;
@synthesize userName = _userName;
@synthesize userFid = _userFid;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ - %d %@ %@ (%l %d)", [super description], _objectID, _photoDescription, _imageURL, _userFid, _userName];
}

- (NSString *)title {
  return self.userName;
}

- (CLLocationCoordinate2D)coordinate {
  return (0 != _longitude && 0 != _latitude) ? CLLocationCoordinate2DMake(_latitude, _longitude) : kCLLocationCoordinate2DInvalid;
}

@end
