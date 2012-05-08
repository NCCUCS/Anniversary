//
//  ANHTTPClient.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 3/18/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ANHTTPClient : AFHTTPClient

+ (ANHTTPClient *)sharedClient;

@end
