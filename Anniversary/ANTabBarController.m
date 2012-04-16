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

- (ANSettingsViewController *)settingsViewController;

@end

@implementation ANTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.viewControllers = [NSArray arrayWithObjects:
                            [[UINavigationController alloc] initWithRootViewController:[[ANPhotosViewController alloc] initWithStyle:UITableViewStylePlain]],
                            [[UINavigationController alloc] initWithRootViewController:[[ANMapViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UIViewController alloc] initWithNibName:nil bundle:nil], 
                            [[UINavigationController alloc] initWithRootViewController:[[ANNewsViewController alloc] initWithNibName:nil bundle:nil]],
                            [[UINavigationController alloc] initWithRootViewController:[self settingsViewController]], nil];
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

- (ANSettingsViewController *)settingsViewController {
  // Setting
  QRootElement *root = [[QRootElement alloc] init];
  root.title = @"設定選項";
  root.grouped = YES;
  
  QSection *section1 = [[QSection alloc] init];
  
  QLabelElement *version = [[QLabelElement alloc] initWithTitle:@"版本" Value:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
  [section1 addElement:version];
  QLabelElement *fansPage = [[QLabelElement alloc] initWithTitle:@"製作團隊" Value:@"政治大學資訊科學系"];
  fansPage.controllerAction = @"openWebsite:";
  [section1 addElement:fansPage];
  
  [root addSection:section1];
  
  QSection *section2 = [[QSection alloc] init];
  QButtonElement *button = [[QButtonElement alloc] initWithTitle:@"登出 Facebook"];
  button.enabled = [[ANAtlas sharedFacebook] isSessionValid];
  button.controllerAction = @"logoutButtonAction:";
  [section2 addElement:button];
  [root addSection:section2];
  
  return [[ANSettingsViewController alloc] initWithRoot:root];
}

- (void)captureButtonClicked:(id)sender {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Albums", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.alpha = 0.90;
    actionSheet.tag = 1;
    [actionSheet showFromTabBar:self.tabBar]; 
  } else {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
    picker.delegate = self;  
    picker.allowsEditing = YES;  
    [self presentModalViewController:picker animated:YES];
  }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  switch (buttonIndex){
    case 0:{				
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
      picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
      picker.delegate = self;  
      picker.allowsEditing = YES;  
      [self presentModalViewController:picker animated:YES];
      break;
    }
    case 1:{
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
      picker.delegate = self;  
      picker.allowsEditing = YES;  
      [self presentModalViewController:picker animated:YES];
      break;
    }
  }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
  [self dismissModalViewControllerAnimated:NO];
  ANCaptureViewController *viewController = [[ANCaptureViewController alloc] initWithNibName:nil bundle:nil];
  viewController.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
  [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];	
}

@end
