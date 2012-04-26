//
//  ANPhotosTableViewCell.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPhotosTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ANPhotosTableViewCell

@synthesize imageView1 = _imageView1;
@synthesize imageView2 = _imageView2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 130, 130)];
    _imageView1.layer.borderColor = [[UIColor grayColor] CGColor];
    _imageView1.layer.borderWidth = 2;
    [self.contentView addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 10, 130, 130)];
    _imageView2.layer.borderColor = [[UIColor grayColor] CGColor];
    _imageView2.layer.borderWidth = 2;
    [self.contentView addSubview:_imageView2];
    
    _imageView1.contentMode = _imageView2.contentMode = UIViewContentModeScaleAspectFit;
  }
  return self;
}

@end
