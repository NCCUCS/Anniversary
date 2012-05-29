//
//  ANFramePickerViewController.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANFramePickerViewControllerDelegate;

@interface ANFramePickerViewController : UITableViewController

@property (nonatomic, strong) NSArray *frames;
@property (nonatomic, weak) id<ANFramePickerViewControllerDelegate> delegate;

@end

@protocol ANFramePickerViewControllerDelegate <NSObject>

@optional

- (void)framePickerController:(ANFramePickerViewController *)picker didFinishPickingFrame:(UIImage *)image;

@end