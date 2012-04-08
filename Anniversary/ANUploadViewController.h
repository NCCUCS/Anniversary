//
//  ANUploadViewController.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/7/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "QuickDialogController.h"

@interface ANUploadViewController : QuickDialogController <UIAlertViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isUploadingToFacebook;
@property (nonatomic, assign) BOOL isSavingToAlbum;

+ (ANUploadViewController *)uploadViewControllerWithImage:(UIImage *)image;

@end
