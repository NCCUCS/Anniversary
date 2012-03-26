//
//  ANPhotosViewController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANPhotosViewController : UITableViewController

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSArray *responseDictionarys;

@end
