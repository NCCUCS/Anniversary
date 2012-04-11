//
//  ANPhotoViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPhotoViewController.h"
#import "ANPhoto.h"
#import "UIImageView+AFNetworking.h"

@interface ANPhotoViewController ()

@end

@implementation ANPhotoViewController

@synthesize photo = _photo;
@synthesize imageView = _imageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize userNameLabel = _userNameLabel;

- (id)initWithPhoto:(ANPhoto *)photo {
  if (self = [self initWithNibName:nil bundle:nil]) {
    _photo = photo;
  }
  
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  [_imageView setImageWithURL:self.photo.imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
  [self.view addSubview:_imageView];
  
  _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 323, 40, 40)];
  [_avatarImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%lld/picture", self.photo.userFid]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
  [self.view addSubview:_avatarImageView];
  
  _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 323, 272, 45)];
  _userNameLabel.backgroundColor = [UIColor clearColor];
  _userNameLabel.text = self.photo.userName;
  [self.view addSubview:_userNameLabel];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _imageView = nil;
  _avatarImageView = nil;
}

@end
