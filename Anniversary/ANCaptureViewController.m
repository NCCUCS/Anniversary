//
//  ANCaptureViewController.m
//  Anniversary
//
//  Created by Devi Eddy on 03/28/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANCaptureViewController.h"
#import "ANTextViewController.h"

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController
@synthesize imageView, toolbar;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

#pragma mark - Private

-(void)cancelButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void)doneButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void)frameButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void)stickerButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

-(void)textButtonClicked:(id)sender {
  [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:[[ANTextViewController alloc] initWithNibName:nil bundle:nil]] animated:YES];
}

#pragma mark - UIViewController

-(void)loadView{
  [super loadView];
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Albums", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.alpha=0.90;
	actionSheet.tag = 1;
	[actionSheet showInView:self.view]; 
}

#pragma mark - UIActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	switch (actionSheet.tag){
		case 1:
			switch (buttonIndex){
			case 0:{				
#if TARGET_IPHONE_SIMULATOR
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saw Them" message:@"Camera not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
#elif TARGET_OS_IPHONE
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
				picker.delegate = self;  
				//picker.allowsEditing = YES;  
				[self presentModalViewController:picker animated:YES];
				[picker release];
#endif	
			}break;
			case 1:{
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  
				picker.delegate = self;  
				[self presentModalViewController:picker animated:YES];
			}break;
      case 2:{
        [self dismissModalViewControllerAnimated:YES];
      }break;
		}break;
		default:
			break;
	}	
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
	[picker dismissModalViewControllerAnimated:YES];
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 34, 250, 300)];
  imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  [self.view addSubview:imageView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];	
}

- (void)viewDidLoad{
  [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
  
  //navigation Item
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
  
  //UIToolbar
  CGRect rect = CGRectMake(0, self.view.frame.size.height-88, self.view.frame.size.width, 0);
  toolbar = [[UIToolbar alloc]initWithFrame:rect];
  toolbar.barStyle = UIBarStyleDefault;
  [toolbar sizeToFit];
  [self.view addSubview:toolbar];
  
  //UIBarButtonItem
  UIBarItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                      UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *frameButton = [[UIBarButtonItem alloc] initWithTitle:@"Frame" style:UIBarButtonItemStyleBordered target:self action:@selector(frameButtonClicked:)];
  UIBarButtonItem *stickerButton = [[UIBarButtonItem alloc] initWithTitle:@"Sticker" style:UIBarButtonItemStyleBordered target:self action:@selector(stickerButtonClicked:)];
  UIBarButtonItem *textButton = [[UIBarButtonItem alloc] initWithTitle:@"Text" style:UIBarButtonItemStyleBordered target:self action:@selector(textButtonClicked:)];
  NSArray *buttons = [NSArray arrayWithObjects: space, frameButton, space, stickerButton, space, textButton, space, nil];
  [toolbar setItems: buttons animated:NO];
}

- (void)viewDidUnload{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

@end
