//
//  ANPhoto.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPhoto : NSObject

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, strong) NSString *photoDescription;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *thumbURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) long long userFid;

@end
