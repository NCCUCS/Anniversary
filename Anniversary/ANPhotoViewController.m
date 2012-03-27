//
//  ANPhotoViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ANPhotoViewController ()
@property (nonatomic, strong) NSDictionary *singlePhotoInfo;
@end

@implementation ANPhotoViewController

@synthesize singlePhotoInfo = _singlePhotoInfo;

- (id)init {
	if (self = [super init]) {

	}
	return self;
}

- (id)initFromMapViewController:(NSDictionary *)singlePhotoInfo {
	if (self = [self init]) {
		
	}
	return self;
}

- (id)initFromPhotosViewController:(NSDictionary *)singlePhotoInfo {
	if (self = [self init]) {
		self.singlePhotoInfo = [NSDictionary dictionaryWithDictionary:singlePhotoInfo];
	}
	return self;
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.title = [self.singlePhotoInfo objectForKey:@"description"];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	NSURL *imageURL = [NSURL URLWithString:[[self.singlePhotoInfo objectForKey:@"image"] objectForKey:@"url"]];
	[imageView setImageWithURL:imageURL placeholderImage:nil];
	[self.view addSubview:imageView];
}

@end
