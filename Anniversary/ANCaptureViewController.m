//
// ANCaptureViewController.m
// Anniversary
//
// Created by Devi Eddy on 03/14/12.
// Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANCaptureViewController.h"
#import "ANPersonPickerViewController.h"

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController
@synthesize imageView, personPicker, takePhoto, editText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

-(IBAction)newPerson:(id)sender{
  ANPersonPickerViewController *personPickerView = [[ANPersonPickerViewController alloc] initWithNibName:nil bundle:nil];
  personPickerView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
  [self.navigationController pushViewController:personPickerView animated:YES];
}

-(IBAction)capture:(id)sender{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  //picker.delegate = self;
  picker.allowsEditing = YES;
  //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  [self presentModalViewController:picker animated:YES];
}

- (IBAction)textEditor:(id)sender{
  // UIAlertView
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
  
  
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  [picker dismissModalViewControllerAnimated:YES];
  imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
  //imageView.image = [imageView imageByScalingAndCroppingForSize:CGSizeMake(10, 10)];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"Index %d", buttonIndex);
  
  UITextField *field = [alertView textFieldAtIndex:0];
  NSLog(@"Field %@", field.text);
}

#pragma mark - Private

- (void)doneButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
}

@end