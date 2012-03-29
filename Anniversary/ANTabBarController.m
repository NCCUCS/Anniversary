//
//  ANTabBarController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANTabBarController.h"
#import "ANPhotosViewController.h"
#import "ANSettingsViewController.h"
#import "ANNewsViewController.h"
#import "ANMapViewController.h"
#import "ANCaptureViewController.h"

@interface ANTabBarController ()

@end

@implementation ANTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.viewControllers = [NSArray arrayWithObjects:
                            [[UINavigationController alloc] initWithRootViewController:[[ANPhotosViewController alloc] initWithStyle:UITableViewStylePlain]],
                            [[UINavigationController alloc] initWithRootViewController:[[ANMapViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UIViewController alloc] initWithNibName:nil bundle:nil], 
                            [[UINavigationController alloc] initWithRootViewController:[[ANNewsViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UINavigationController alloc] initWithRootViewController:[[ANSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]], nil];
  }
  return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIImage *buttonImage = [UIImage imageNamed:@"capture-button"];
  
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button addTarget:self action:@selector(captureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0) {
    button.center = self.tabBar.center;
  } else {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  
  [self.view addSubview:button];
}


#pragma mark - Private

- (void)captureButtonClicked:(id)sender {
//  [self.selectedViewController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANCaptureViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Albums", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.alpha=0.90;
	actionSheet.tag = 1;
	[actionSheet showFromTabBar:self.tabBar]; 
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  switch (buttonIndex){
    case 0:{				
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
      picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
      picker.delegate = self;  
      //picker.allowsEditing = YES;  
      [self presentModalViewController:picker animated:YES];
      break;
    }
    case 1:{
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
      picker.delegate = self;  
      [self presentModalViewController:picker animated:YES];
      break;
    }
  }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
	[picker dismissModalViewControllerAnimated:YES];
  
  ANCaptureViewController *viewController = [[ANCaptureViewController alloc] initWithNibName:@"ANCaptureViewController" bundle:nil];
  viewController.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  [self.selectedViewController presentModalViewController:viewController animated:YES];
//  [self.navigationController pushViewController:viewController animated:YES];
//  [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:viewController ]animated:YES];
//  [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANCaptureViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
  
//  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 34, 250, 300)];
//  imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//  [self.view addSubview:imageView];
  
  NSLog(@"hi");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];	
}

@end
