//
//  ANPhotosViewController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface ANPhotosViewController : UITableViewController <UIGestureRecognizerDelegate, PullToRefreshViewDelegate>

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) PullToRefreshView *pullToRefreshView;

@end
