//
//  ANFramePickerViewController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ANFramePickerViewController.h"
#import "ANPhotosTableViewCell.h"

@interface ANFramePickerViewController ()

@end

@implementation ANFramePickerViewController

@synthesize frames = _frames;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"選擇相框";
    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    _frames = [NSArray arrayWithContentsOfFile:NIPathForBundleResource([NSBundle mainBundle], @"frames.plist")];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  self.tableView.allowsSelection = NO;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drawer-background"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return ceil(self.frames.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *PhotosCellIdentifier = @"PhotosCellIdentifier";
  ANPhotosTableViewCell *cell = (ANPhotosTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PhotosCellIdentifier];
	
	if (!cell) {
    __weak ANFramePickerViewController *tempSelf = self;
    
		cell = [[ANPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosCellIdentifier];
    UIGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){      
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.frames.count && [self.delegate respondsToSelector:@selector(framePickerController:didFinishPickingFrame:)]) {
          UIImageView *imageView = (UIImageView *)sender.view;
          [tempSelf.delegate framePickerController:tempSelf didFinishPickingFrame:imageView.image];
          [tempSelf dismissModalViewControllerAnimated:YES];
        }
      }
    }];
    [cell.imageView1 addGestureRecognizer:recognizer1];
    cell.imageView1.userInteractionEnabled = YES;
    
    cell.imageView1.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.imageView1.layer.shadowRadius = 2;
    cell.imageView1.layer.shouldRasterize = YES;
    cell.imageView1.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.imageView1.layer.shadowOpacity = 0.5;
    
    UIGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.frames.count && [self.delegate respondsToSelector:@selector(framePickerController:didFinishPickingFrame:)]) {
          UIImageView *imageView = (UIImageView *)sender.view;
          [tempSelf.delegate framePickerController:tempSelf didFinishPickingFrame:imageView.image];
          [tempSelf dismissModalViewControllerAnimated:YES];
        }
      }
    }];
    [cell.imageView2 addGestureRecognizer:recognizer2];
    cell.imageView2.userInteractionEnabled = YES;
    
    cell.imageView2.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.imageView2.layer.shadowRadius = 2;
    cell.imageView2.layer.shouldRasterize = YES;
    cell.imageView2.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.imageView2.layer.shadowOpacity = 0.5;
	}
  
  NSUInteger index1 = 2 * indexPath.row;
  
  NSString *imageName1 = [self.frames objectAtIndex:index1];
  cell.imageView1.tag = index1;
  NSString *imageName2 = nil; 
  
  NSUInteger index2 = 2 * indexPath.row + 1;
  
  if (index2 < self.frames.count) {
    imageName2 = [self.frames objectAtIndex:index2];
    cell.imageView2.tag = index2;
  };
  
  cell.imageView1.image = [UIImage imageNamed:imageName1];
  cell.imageView2.image = [UIImage imageNamed:imageName2];
  
	
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kThumbPhotoHeight + 20;
}

@end
