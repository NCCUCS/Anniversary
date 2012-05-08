//
//  ANPersonPickerViewController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/13/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIPagingScrollView.h"
#import "NIPagingScrollViewDataSource.h"
#import "NIPagingScrollViewDelegate.h"

@interface ANPersonPickerViewController : UIViewController <
NIPagingScrollViewDataSource,
NIPagingScrollViewDelegate>

@property (nonatomic, strong) NIPagingScrollView *pageView;
@property (nonatomic, strong) UIButton *button;

@end
