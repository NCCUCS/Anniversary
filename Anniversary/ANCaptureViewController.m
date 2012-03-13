//
//  ANCaptureViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/13/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANCaptureViewController.h"

@interface ANCaptureViewController ()

@end

@implementation ANCaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

#pragma mark - Private

- (void)doneButtonClicked:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

@end
