//
//  ANPhoto.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ANPhoto : NSObject <MKAnnotation>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSString *photoDescription;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *thumbURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) long long userFid;

@end
