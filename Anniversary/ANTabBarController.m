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

@synthesize tabBarImageView = _tabBarImageView;

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
  
  _tabBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBarBackground"]];
  _tabBarImageView.userInteractionEnabled = YES;
  _tabBarImageView.frame = CGRectOffset(_tabBarImageView.frame, 0, self.view.bounds.size.height - _tabBarImageView.bounds.size.height);
  _tabBarImageView.tag = -1;
  [self.view addSubview:_tabBarImageView];
  
  UIButton* photosButton = [UIButton buttonWithType:UIButtonTypeCustom];
  photosButton.frame = CGRectMake(10, 4, 40, 44);
  [photosButton setBackgroundImage:[UIImage imageNamed:@"photosTab"] forState:UIControlStateNormal];
  [photosButton setBackgroundImage:[UIImage imageNamed:@"photosTabSelected"] forState:UIControlStateSelected];
  [photosButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  photosButton.tag = 0;
  photosButton.selected = YES;
  [_tabBarImageView addSubview:photosButton];
  
  UIButton* mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  mapButton.frame = CGRectMake(70, 4, 40, 44);
  [mapButton setBackgroundImage:[UIImage imageNamed:@"mapTab"] forState:UIControlStateNormal];
  [mapButton setBackgroundImage:[UIImage imageNamed:@"mapTabSelected"] forState:UIControlStateSelected];
  [mapButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  mapButton.tag = 1;
  [_tabBarImageView addSubview:mapButton];
  
  UIButton* newsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  newsButton.frame = CGRectMake(210, 4, 40, 44);
  [newsButton setBackgroundImage:[UIImage imageNamed:@"newsTab"] forState:UIControlStateNormal];
  [newsButton setBackgroundImage:[UIImage imageNamed:@"newsTabSelected"] forState:UIControlStateSelected];
  [newsButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  newsButton.tag = 3;
  [_tabBarImageView addSubview:newsButton];
  
  UIButton* settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
  settingsButton.frame = CGRectMake(270, 4, 40, 44);
  [settingsButton setBackgroundImage:[UIImage imageNamed:@"settingsTab"] forState:UIControlStateNormal];
  [settingsButton setBackgroundImage:[UIImage imageNamed:@"settingsTabSelected"] forState:UIControlStateSelected];
  [settingsButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  settingsButton.tag = 4;
  [_tabBarImageView addSubview:settingsButton];
  
  UIButton* captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
  captureButton.frame = CGRectMake(0.0, 0.0, 92, 55);
  [captureButton setBackgroundImage:[UIImage imageNamed:@"capture-button"] forState:UIControlStateNormal];
  [captureButton addTarget:self action:@selector(captureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  CGFloat heightDifference = 55 - self.tabBar.frame.size.height;
  CGPoint center = self.tabBar.center;
  center.y = center.y - heightDifference / 2.0;
  captureButton.center = center;
  
  [self.view addSubview:captureButton];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _tabBarImageView = nil;
}


#pragma mark - Private

- (void)tabButtonClicked:(id)sender {
  UIButton *selectedButton = (UIButton *)[_tabBarImageView viewWithTag:self.selectedIndex];
  selectedButton.selected = NO;
  
  UIButton *button = (UIButton *)sender;
  button.selected = YES;
  self.selectedIndex = button.tag;
}

- (ANSettingsViewController *)settingsViewController {
  // Setting
  QRootElement *root = [[QRootElement alloc] init];
  root.title = @"設定選項";
  root.grouped = YES;
  
  QSection *section1 = [[QSection alloc] init];
  
  QLabelElement *version = [[QLabelElement alloc] initWithTitle:@"版本" Value:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
  [section1 addElement:version];
  QLabelElement *fansPage = [[QLabelElement alloc] initWithTitle:@"製作團隊" Value:nil];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"選擇照片來源..." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"攝影鏡頭", @"相片圖庫", nil];
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
