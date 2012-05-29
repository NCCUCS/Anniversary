//
//  ANPhotoViewController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANPhoto;

@interface ANPhotoViewController : UIViewController

@property (nonatomic, strong) ANPhoto *photo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

- (id)initWithPhoto:(ANPhoto *)photo;

@end
