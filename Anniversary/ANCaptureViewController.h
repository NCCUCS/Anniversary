//
//  ANCaptureViewController.h
//  Anniversary
//
//  Created by Devi Eddy on 03/28/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ANCaptureViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *textimageview;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *textimage;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *stickerArray;

@end
