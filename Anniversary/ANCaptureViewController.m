//
//  ANCaptureViewController.m
//  Anniversary
//
//  Created by Devi Eddy on 03/28/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ANPersonPickerViewController.h"
#import "ANCaptureViewController.h"
#import "ANStickerPickerViewController.h"
#import "ANTextViewController.h"
#import "ANUploadViewController.h"
#import "SEDraggable.h"

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController

@synthesize imageView = _imageView;
@synthesize frameImageView = _frameImageView;
@synthesize image = _image;
@synthesize selectedView = _selectedView;

#define kMaxStickerWidth 100
#define degreesToRadians(x) (M_PI * x / 180.0)

float angle = 0, size=14;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"照片編輯";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleView"]];
  }
  return self;
}

#pragma mark - Private

- (void)frameButtonClicked:(id)sender {
  [self presentModalViewController:[[ANPersonPickerViewController alloc] initWithNibName:nil bundle:nil] animated:YES];
}

- (void)stickerButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)textButtonClicked:(id)sender {
  [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANTextViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
}

#pragma mark - UIViewController

- (void)loadView{
  [super loadView];
  
  __weak ANCaptureViewController *tempSelf = self;
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
  
  // Images
  
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  _imageView.image = self.image;
  _imageView.userInteractionEnabled = YES;
  _imageView.clipsToBounds = YES;
  [self.view addSubview:_imageView];
  
  _frameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  [self.imageView addSubview:_frameImageView];
  
  UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frameShadow"]];
  shadowImageView.frame = CGRectOffset(shadowImageView.frame, 0, 320);
  [self.view addSubview:shadowImageView];
  
  // Buttons
  UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [zoomInButton setImage:[UIImage imageNamed:@"plusButton"] forState:UIControlStateNormal];
  zoomInButton.frame = CGRectMake(9, 332, 31, 31);
  [zoomInButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformScale(tempSelf.selectedView.transform, 1.1, 1.1);
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:zoomInButton];
  
  UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [zoomOutButton setImage:[UIImage imageNamed:@"minusButton"] forState:UIControlStateNormal];
  zoomOutButton.frame = CGRectMake(51, 332, 31, 31);
  [zoomOutButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformScale(tempSelf.selectedView.transform, 0.909, 0.909);
    }];

  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:zoomOutButton];
  
  UIButton *rotateRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [rotateRightButton setImage:[UIImage imageNamed:@"leftButton"] forState:UIControlStateNormal];
  rotateRightButton.frame = CGRectMake(91, 332, 32, 31);
  [rotateRightButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformRotate(CGAffineTransformRotate(tempSelf.selectedView.transform, -degreesToRadians(45 * (tempSelf.selectedView.tag))), degreesToRadians(45 * (++tempSelf.selectedView.tag)));
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:rotateRightButton];
  
  UIButton *rotateLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [rotateLeftButton setImage:[UIImage imageNamed:@"rightButton"] forState:UIControlStateNormal];
  rotateLeftButton.frame = CGRectMake(133, 332, 32, 31);
  [rotateLeftButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformRotate(CGAffineTransformRotate(tempSelf.selectedView.transform, -degreesToRadians(-45 * (tempSelf.selectedView.tag))), degreesToRadians(-45 * (++tempSelf.selectedView.tag)));
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:rotateLeftButton];
  
  UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [trashButton setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
  trashButton.frame = CGRectMake(280, 332, 32, 31);
  [trashButton addEventHandler:^(id sender){
    [tempSelf.selectedView removeFromSuperview];
    tempSelf.selectedView = nil;
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:trashButton];
  
  // Toolbar  
  UIButton *frameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  frameButton.frame = CGRectMake(24, 374, 87, 33);
  [frameButton setImage:[UIImage imageNamed:@"frameButton"] forState:UIControlStateNormal];
  [frameButton addEventHandler:^(id sender){
    ANFramePickerViewController *viewController = [[ANFramePickerViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [tempSelf presentModalViewController:viewController animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:frameButton];
  
  UIButton *stickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  stickerButton.frame = CGRectMake(117, 374, 87, 33);
  [stickerButton setImage:[UIImage imageNamed:@"stickerButton"] forState:UIControlStateNormal];
  [stickerButton addEventHandler:^(id sender){
    ANStickerPickerViewController *viewController = [[ANStickerPickerViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [tempSelf presentModalViewController:viewController animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:stickerButton];
  
  UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
  textButton.frame = CGRectMake(209, 374, 87, 33);
  [textButton setImage:[UIImage imageNamed:@"textButton"] forState:UIControlStateNormal];
  [textButton addEventHandler:^(id sender){
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"請輸入文字" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.willDismissBlock = ^(UIAlertView *alertView, NSInteger index){
      if (index != alertView.cancelButtonIndex) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [[alertView textFieldAtIndex:0] text];
        label.textColor = [UIColor colorWithRed:0.541 green:0.710 blue:0.882 alpha:1.000];
        label.font = [UIFont boldSystemFontOfSize:30];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [label sizeToFit];
        
        SEDraggable *draggable = [[SEDraggable alloc] initWithFrame:label.frame];
        draggable.delegate = tempSelf;
        [draggable addSubview:label];
        [tempSelf.imageView insertSubview:draggable belowSubview:tempSelf.frameImageView];
        
        if (!tempSelf.selectedView) {
          tempSelf.selectedView = draggable;
        }
      }
    };
    [alertView show];
    
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:textButton];
  
  UIImageView *bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar"]];
  bottomImageView.frame = CGRectOffset(bottomImageView.frame, 0, 372);
  [self.view addSubview:bottomImageView];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  
  __weak ANCaptureViewController *tempSelf = self;
  
  UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
  [cancelButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
  [cancelButton addEventHandler:^(id sender){
    [UIAlertView showAlertViewWithTitle:@"放棄編輯" message:@"確定要離開此畫面？" cancelButtonTitle:@"取消" otherButtonTitles:[NSArray arrayWithObject:@"確定"] handler:^(UIAlertView *alertView, NSInteger index){
      if (alertView.cancelButtonIndex != index) {
        [tempSelf dismissModalViewControllerAnimated:YES];
      }
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
  [doneButton setImage:[UIImage imageNamed:@"doneButton"] forState:UIControlStateNormal];
  [doneButton addEventHandler:^(id sender){
    UIGraphicsBeginImageContextWithOptions(tempSelf.imageView.bounds.size, tempSelf.imageView.opaque, 0.0);
    [tempSelf.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    ANUploadViewController *uploadViewController = [ANUploadViewController uploadViewControllerWithImage:image];
    [tempSelf.navigationController pushViewController:uploadViewController animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  
}

- (void)viewDidUnload{
  [super viewDidUnload];
  
  _imageView = nil;
  _frameImageView = nil;
  _selectedView = nil;
}

#pragma mark - ANFramePickerViewControllerDelegate

- (void)framePickerController:(ANFramePickerViewController *)picker didFinishPickingFrame:(UIImage *)image {
  _frameImageView.image = image;
}

#pragma mark - ANStickerPickerViewControllerDelegate

- (void)stickerPickerController:(ANStickerPickerViewController *)picker didFinishPickingFrame:(UIImage *)image {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  CGFloat ratio = kMaxStickerWidth / image.size.width;
  imageView.frame = CGRectMake(0, 0, image.size.width * ratio, image.size.height * ratio);
  
  SEDraggable *dragView = [[SEDraggable alloc] initWithImageView:imageView];
  dragView.delegate = self;
  [self.imageView addSubview:dragView];
  
  if (!self.selectedView) {
    self.selectedView = dragView;
  }
}

#pragma mark - SEDraggableEventResponder

- (void)draggableObjectDidMove:(SEDraggable *)object {
  self.selectedView = object;
  [self.imageView bringSubviewToFront:object];
}


@end
