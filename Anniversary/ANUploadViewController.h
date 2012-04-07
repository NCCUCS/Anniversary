//
//  ANUploadViewController.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/7/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "QuickDialogController.h"

@interface ANUploadViewController : QuickDialogController

@property (nonatomic, strong) UIImage *image;

+ (ANUploadViewController *)uploadViewControllerWithImage:(UIImage *)image;

@end
