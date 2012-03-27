//
// ANCaptureViewController.h
// Anniversary
//
// Created by Devi Eddy on 03/14/12.
// Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANCaptureViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) IBOutlet UIButton *personPicker;
@property (nonatomic, retain) IBOutlet UIButton *takePhoto;
@property (nonatomic, retain) IBOutlet UIButton *editText;

-(IBAction)newPerson:(id)sender;
-(IBAction)capture:(id)sender;
-(IBAction)textEditor:(id)sender;

@end