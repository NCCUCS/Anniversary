//
//  ANTextViewController.m
//  Anniversary
//
//  Created by Devi Eddy on 03/28/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANTextViewController.h"

@interface ANTextViewController ()

@end

@implementation ANTextViewController
@synthesize messageField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

- (void)setViewMovedUp:(BOOL)movedUp{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  // Make changes to the view's frame inside the animation block. They will be animated instead
  // of taking place immediately.
  CGRect rect = self.view.frame;
  if (movedUp){        
		if(rect.origin.y == 0)
			rect.origin.y = self.view.frame.origin.y - 216;
  }
	else{        
		if(rect.origin.y < 0)
			rect.origin.y = self.view.frame.origin.y + 216;
  }	
	self.view.frame = rect;    
  [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	// The keyboard will be shown. If the user is editing the comments, adjust the display so that the
	// comments field will not be covered by the keyboard.
	[self setViewMovedUp:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{	
	[textField resignFirstResponder];
	[self setViewMovedUp:NO];
	return NO;
}

#pragma mark - UIViewController

-(void)loadView{
  [super loadView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
  
  //navigation Item
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked:)];
  
  //UITextField
  messageField = [[UITextField alloc] initWithFrame:CGRectMake(94, 333, 206, 31)];
  messageField.borderStyle = UITextBorderStyleRoundedRect;
  messageField.delegate = self;
  [self.view addSubview:messageField];
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
