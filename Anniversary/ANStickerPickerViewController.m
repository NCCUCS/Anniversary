//
//  ANStickerPickerViewController.m
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANStickerPickerViewController.h"
#import "ANPhotosTableViewCell.h"

@interface ANStickerPickerViewController ()

@end

@implementation ANStickerPickerViewController

@synthesize stickers = _stickers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"選擇貼紙";
    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    _stickers = [NSArray arrayWithContentsOfFile:NIPathForBundleResource([NSBundle mainBundle], @"stickers.plist")];
  }
  return self;
}

- (void)loadView {
  [super loadView];
  
  self.tableView.allowsSelection = NO;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return ceil(self.stickers.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *PhotosCellIdentifier = @"PhotosCellIdentifier";
  ANPhotosTableViewCell *cell = (ANPhotosTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PhotosCellIdentifier];
	
	if (!cell) {
    __weak ANStickerPickerViewController *tempSelf = self;
    
		cell = [[ANPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosCellIdentifier];
    UIGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){      
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.stickers.count) {
          
        }
      }
    }];
    [cell.imageView1 addGestureRecognizer:recognizer1];
    cell.imageView1.userInteractionEnabled = YES;
    
    UIGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.stickers.count) {
          
        }
      }
    }];
    [cell.imageView2 addGestureRecognizer:recognizer2];
    cell.imageView2.userInteractionEnabled = YES;
	}
  
  NSUInteger index1 = 2 * indexPath.row;
  
  NSString *imageName1 = [self.stickers objectAtIndex:index1];
  cell.imageView1.tag = index1;
  NSString *imageName2 = nil; 
  
  NSUInteger index2 = 2 * indexPath.row + 1;
  
  if (index2 < self.stickers.count) {
    imageName2 = [self.stickers objectAtIndex:index2];
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
