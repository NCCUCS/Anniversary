//
//  ANHTTPClient.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 3/18/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation ANHTTPClient

static ANHTTPClient *gShareClient;

+ (ANHTTPClient *)sharedClient {
  if (!gShareClient) {
    gShareClient = [[ANHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPI_BASE_URL]];
    [gShareClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  }
  return gShareClient;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
  NSDictionary *parametersWithAPIKey = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *accessToken = [defaults objectForKey:@"ANAccessTokenKey"];
  if (accessToken) {
    [parametersWithAPIKey setValue:accessToken forKey:@"access_token"];
  }
  
  return [super requestWithMethod:method path:path parameters:parametersWithAPIKey];
}


@end
