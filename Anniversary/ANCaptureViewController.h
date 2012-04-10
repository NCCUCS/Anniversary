//
//  ANCaptureViewController.h
//  Anniversary
//
//  Created by Devi Eddy on 03/28/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ANFramePickerViewController.h"

@interface ANCaptureViewController : UIViewController <ANFramePickerViewControllerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, retain) UIToolbar *toolbar;

@end
