//
//  ANStickerPickerViewController.h
//  Anniversary
//
//  Created by Lee Chih-Wei on 4/10/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANStickerPickerViewControllerDelegate;

@interface ANStickerPickerViewController : UITableViewController

@property (nonatomic, strong) NSArray *stickers;
@property (nonatomic, weak) id<ANStickerPickerViewControllerDelegate> delegate;

@end

@protocol ANStickerPickerViewControllerDelegate <NSObject>

@optional

- (void)stickerPickerController:(ANStickerPickerViewController *)picker didFinishPickingFrame:(UIImage *)image;

@end