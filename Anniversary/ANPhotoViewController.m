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

- (id)initWithPhoto:(ANPhoto *)photo {
  if (self = [self initWithNibName:nil bundle:nil]) {
    _photo = photo;
  }
  
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 310)];
  [_imageView setImageWithURL:_photo.imageURL];
  [self.view addSubview:_imageView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
   
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _imageView = nil;
}

@end
