//
//  ANPersonPickerViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/13/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPersonPickerViewController.h"

@interface ANPersonPickerViewController ()

@end

@implementation ANPersonPickerViewController

@synthesize button = _button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

#pragma mark - Private

- (void)backButtonClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  // Frame means where it is
  self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
  self.button.backgroundColor = [UIColor redColor];
  [self.button setTitle:@"Haha" forState:UIControlStateNormal];
  [self.view addSubview:self.button];
  
  [self.button addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
