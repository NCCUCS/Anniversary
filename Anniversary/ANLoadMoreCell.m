//
//  ANLoadMoreCell.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/23/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import "ANLoadMoreCell.h"

@implementation ANLoadMoreCell

@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = self.center;
    [self addSubview:_activityIndicatorView];
  }
  return self;
}

@end
