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
#import "ANTextViewController.h"
#import "ANUploadViewController.h"

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController
@synthesize imageView, toolbar, image, label, textArray, stickerArray;
@synthesize textimage,textimageview;

float angle = 0, size=14;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
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
  [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANPersonPickerViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
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

-(void)loadView{
  [super loadView];
}

- (void)viewDidLoad{
  [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
  
  //navigation Item
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
  
  //UIImage
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 20, 240, 280)];
  imageView.image = image;
  [self.view addSubview:imageView];
  
  //UIToolbar
  CGRect rect = CGRectMake(0, self.view.frame.size.height-88, self.view.frame.size.width, 0);
  toolbar = [[UIToolbar alloc]initWithFrame:rect];
  toolbar.barStyle = UIBarStyleDefault;
  [toolbar sizeToFit];
  [self.view addSubview:toolbar];
  
  //UIBarButtonItem
  UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *frameButton = [[UIBarButtonItem alloc] initWithTitle:@"Frame" style:UIBarButtonItemStyleBordered target:self action:@selector(frameButtonClicked:)];
  UIBarButtonItem *stickerButton = [[UIBarButtonItem alloc] initWithTitle:@"Sticker" style:UIBarButtonItemStyleBordered target:self action:@selector(stickerButtonClicked:)];
  UIBarButtonItem *textButton = [[UIBarButtonItem alloc] initWithTitle:@"Text" style:UIBarButtonItemStyleBordered target:self action:@selector(textButtonClicked:)];
  NSArray *buttons = [NSArray arrayWithObjects: space, frameButton, space, stickerButton, space, textButton, space, nil];
  [toolbar setItems: buttons animated:NO];
  
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
  // Release any retained subviews of the main view.
}

@end
