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

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController
@synthesize imageView = _imageView;
@synthesize toolbar = _toolbar;
@synthesize image, label, textArray, stickerArray;
@synthesize textimage,textimageview;

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
  [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonClicked:(id)sender {
  ANUploadViewController *uploadViewController = [ANUploadViewController uploadViewControllerWithImage:self.image];
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

#pragma mark - UIButton

-(void)zoomIn:(id)sender {
  [UIImageView beginAnimations:nil context:NULL];
  [UIImageView setAnimationDuration:0.5];
  [UIImageView setAnimationBeginsFromCurrentState:YES];
  textimageview.frame = CGRectMake(textimageview.frame.origin.x,textimageview.frame.origin.y, textimageview.frame.size.width+9, textimageview.frame.size.height+6);
  [UIImageView commitAnimations];
  
  size += 1;
  label.font=[UIFont systemFontOfSize:size];
}

-(void)zoomOut:(id)sender {
  [UIImageView beginAnimations:nil context:NULL];
  [UIImageView setAnimationDuration:0.5];
  [UIImageView setAnimationBeginsFromCurrentState:YES];
  textimageview.frame = CGRectMake(textimageview.frame.origin.x, textimageview.frame.origin.y, textimageview.frame.size.width-9 , textimageview.frame.size.height-6);
  [UIImageView commitAnimations];
  
  size -= 1;
  label.font=[UIFont systemFontOfSize:size];
}

-(void)rotateRight:(id)sender {
  [UIImageView beginAnimations:nil context:NULL];
  [UIImageView setAnimationDuration:0.5];
  [UIImageView setAnimationBeginsFromCurrentState:YES];
  angle += M_PI/4;
  CGAffineTransform transform =CGAffineTransformMakeRotation(angle);
  textimageview.transform = transform;
  [UIImageView commitAnimations];
  
  label.transform=transform;
}

-(void)rotateLeft:(id)sender {
  [UIImageView beginAnimations:nil context:NULL];
  [UIImageView setAnimationDuration:0.5];
  [UIImageView setAnimationBeginsFromCurrentState:YES];
  angle -= M_PI/4;
  CGAffineTransform transform =CGAffineTransformMakeRotation(angle);
  textimageview.transform = transform;
  [UIImageView commitAnimations];
  
  label.transform=transform;
}

-(void)trash:(id)sender {
  textimageview.removeFromSuperview;
}

#pragma mark - UIViewController

- (void)loadView{
  [super loadView];
  
  __weak UIViewController *tempSelf = self;
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
  _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  _imageView.image = image;
  [self.view addSubview:_imageView];
  
  _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - NIToolbarHeightForOrientation(self.interfaceOrientation), 
                         self.view.bounds.size.width, NIToolbarHeightForOrientation(self.interfaceOrientation))];
  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [self.view addSubview:_toolbar];
  
  UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIButton *frameButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [frameButton setImage:[UIImage imageNamed:@"frameButton"] forState:UIControlStateNormal];
  [frameButton setImage:[UIImage imageNamed:@"frameButtonClicked"] forState:UIControlStateHighlighted];
  [frameButton sizeToFit];
  
  UIBarButtonItem *frameButtonItem = [[UIBarButtonItem alloc] initWithCustomView:frameButton];
  
  UIButton *stickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [stickerButton setImage:[UIImage imageNamed:@"stickerButton"] forState:UIControlStateNormal];
  [stickerButton setImage:[UIImage imageNamed:@"stickerButtonClicked"] forState:UIControlStateHighlighted];
  [stickerButton sizeToFit];
  [stickerButton addEventHandler:^(id sender){
    [tempSelf presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANStickerPickerViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
  } forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *stickerButtonItem = [[UIBarButtonItem alloc] initWithCustomView:stickerButton];
  
  UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [textButton setImage:[UIImage imageNamed:@"textButton"] forState:UIControlStateNormal];
  [textButton setImage:[UIImage imageNamed:@"textButtonClicked"] forState:UIControlStateHighlighted];
  [textButton sizeToFit];
  
  UIBarButtonItem *textButtonItem = [[UIBarButtonItem alloc] initWithCustomView:textButton];
  
  _toolbar.items = [NSArray arrayWithObjects: space, frameButtonItem, space, stickerButtonItem, space, textButtonItem, space, nil];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
  
  //UIButton
  UIButton *zoomInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [zoomInButton addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside];
  [zoomInButton setTitle:@"+" forState:UIControlStateNormal];
  zoomInButton.frame = CGRectMake(18.0, 325.0, 30.0, 30.0);
  [self.view addSubview:zoomInButton];
  
  UIButton *zoomOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [zoomOutButton addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
  [zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
  zoomOutButton.frame = CGRectMake(55.0, 325.0, 30.0, 30.0);
  [self.view addSubview:zoomOutButton];
  
  UIButton *rotateRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [rotateRightButton addTarget:self action:@selector(rotateRight:) forControlEvents:UIControlEventTouchUpInside];
  [rotateRightButton setTitle:@"↷" forState:UIControlStateNormal];
  rotateRightButton.frame = CGRectMake(92.0, 325.0, 30.0, 30.0);
  [self.view addSubview:rotateRightButton];
  
  UIButton *rotateLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [rotateLeftButton addTarget:self action:@selector(rotateLeft:) forControlEvents:UIControlEventTouchUpInside];
  [rotateLeftButton setTitle:@"↶" forState:UIControlStateNormal];
  rotateLeftButton.frame = CGRectMake(129.0, 325.0, 30.0, 30.0);
  [self.view addSubview:rotateLeftButton];
  
  UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [trashButton addTarget:self action:@selector(trash:) forControlEvents:UIControlEventTouchUpInside];
  [trashButton setTitle:@"x" forState:UIControlStateNormal];
  trashButton.frame = CGRectMake(275.0, 325.0, 30.0, 30.0);
  [self.view addSubview:trashButton];
  
  //UILabel
  label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 50, 20)];
  label.text = @"test"; 
  label.backgroundColor=[UIColor clearColor];
  label.font=[UIFont systemFontOfSize:size];
  [self.view addSubview:label];
  
  //textimageview
  textimageview = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, 20.0, 60.0, 40.0)];
  [textimageview setImage:[UIImage imageNamed:@"capture-button.png"]];
  [self.view addSubview:textimageview];
  
}

- (void)viewDidUnload{
  [super viewDidUnload];
  
  _imageView = nil;
  _toolbar = nil;
}

@end
