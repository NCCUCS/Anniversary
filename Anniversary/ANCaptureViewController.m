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
@synthesize toolbar = _toolbar;
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

- (void)cancelButtonClicked:(id)sender {
  __weak UIViewController *tempSelf = self;
  [UIAlertView showAlertViewWithTitle:@"放棄編輯" message:@"確定要離開此畫面？" cancelButtonTitle:@"取消" otherButtonTitles:@"確定" handler:^(UIAlertView *alertView, NSInteger index){
    [tempSelf dismissModalViewControllerAnimated:YES];
  }];
}

- (void)doneButtonClicked:(id)sender {
  UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, self.imageView.opaque, 0.0);
  [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  ANUploadViewController *uploadViewController = [ANUploadViewController uploadViewControllerWithImage:image];
  [self.navigationController pushViewController:uploadViewController animated:YES];
}

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
  
  // Buttons
  
  UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [zoomInButton setTitle:@"+" forState:UIControlStateNormal];
  zoomInButton.frame = CGRectMake(18.0, 325.0, 30.0, 30.0);
  [zoomInButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      self.selectedView.transform = CGAffineTransformScale(self.selectedView.transform, 1.1, 1.1);
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:zoomInButton];
  
  UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
  zoomOutButton.frame = CGRectMake(55.0, 325.0, 30.0, 30.0);
  [zoomOutButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      self.selectedView.transform = CGAffineTransformScale(self.selectedView.transform, 0.909, 0.909);
    }];

  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:zoomOutButton];
  
  UIButton *rotateRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [rotateRightButton setTitle:@"↷" forState:UIControlStateNormal];
  rotateRightButton.frame = CGRectMake(92.0, 325.0, 30.0, 30.0);
  [rotateRightButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformRotate(CGAffineTransformRotate(tempSelf.selectedView.transform, -degreesToRadians(45 * (tempSelf.selectedView.tag))), degreesToRadians(45 * (++tempSelf.selectedView.tag)));
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:rotateRightButton];
  
  UIButton *rotateLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [rotateLeftButton setTitle:@"↶" forState:UIControlStateNormal];
  rotateLeftButton.frame = CGRectMake(129.0, 325.0, 30.0, 30.0);
  [rotateLeftButton addEventHandler:^(id sender){
    [UIView animateWithDuration:0.1 animations:^{
      tempSelf.selectedView.transform = CGAffineTransformRotate(CGAffineTransformRotate(tempSelf.selectedView.transform, -degreesToRadians(-45 * (tempSelf.selectedView.tag))), degreesToRadians(-45 * (++tempSelf.selectedView.tag)));
    }];
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:rotateLeftButton];
  
  UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [trashButton setTitle:@"x" forState:UIControlStateNormal];
  trashButton.frame = CGRectMake(275.0, 325.0, 30.0, 30.0);
  [trashButton addEventHandler:^(id sender){
    [tempSelf.selectedView removeFromSuperview];
    tempSelf.selectedView = nil;
  } forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:trashButton];
  
  // Toolbar
  
  _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - NIToolbarHeightForOrientation(self.interfaceOrientation), 
                         self.view.bounds.size.width, NIToolbarHeightForOrientation(self.interfaceOrientation))];
  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self.view addSubview:_toolbar];
  
  UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIButton *frameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [frameButton setImage:[UIImage imageNamed:@"frameButton"] forState:UIControlStateNormal];
  [frameButton setImage:[UIImage imageNamed:@"frameButtonClicked"] forState:UIControlStateHighlighted];
  [frameButton sizeToFit];
  [frameButton addEventHandler:^(id sender){
    ANFramePickerViewController *viewController = [[ANFramePickerViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [tempSelf presentModalViewController:viewController animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *frameButtonItem = [[UIBarButtonItem alloc] initWithCustomView:frameButton];
  
  UIButton *stickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [stickerButton setImage:[UIImage imageNamed:@"stickerButton"] forState:UIControlStateNormal];
  [stickerButton setImage:[UIImage imageNamed:@"stickerButtonClicked"] forState:UIControlStateHighlighted];
  [stickerButton sizeToFit];
  [stickerButton addEventHandler:^(id sender){
    ANStickerPickerViewController *viewController = [[ANStickerPickerViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [tempSelf presentModalViewController:viewController animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *stickerButtonItem = [[UIBarButtonItem alloc] initWithCustomView:stickerButton];
  
  UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [textButton setImage:[UIImage imageNamed:@"textButton"] forState:UIControlStateNormal];
  [textButton setImage:[UIImage imageNamed:@"textButtonClicked"] forState:UIControlStateHighlighted];
  [textButton sizeToFit];
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
  
  UIBarButtonItem *textButtonItem = [[UIBarButtonItem alloc] initWithCustomView:textButton];
  
  _toolbar.items = [NSArray arrayWithObjects: space, frameButtonItem, space, stickerButtonItem, space, textButtonItem, space, nil];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
  
}

- (void)viewDidUnload{
  [super viewDidUnload];
  
  _imageView = nil;
  _frameImageView = nil;
  _toolbar = nil;
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
