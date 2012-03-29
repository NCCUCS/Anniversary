//
//  ANPhotosViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPhotosViewController.h"
#import "ANHTTPClient.h"
#import "ANPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ANPhotosViewController ()
- (void)handleImageTap:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)reloadTableData;
@end

@implementation ANPhotosViewController

@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;
@synthesize responseDictionarys = _responseDictionarys;
@synthesize pullToRefreshView = _pullToRefreshView;

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    self.title = @"最新照片";
    self.tabBarItem.image = [UIImage imageNamed:@"42-photos"];
  }
  return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addObserver:self forKeyPath:@"responseDictionarys" options:NSKeyValueObservingOptionOld context:nil];
	if (self.pullToRefreshView == nil) {
		self.pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)self.tableView];	
		self.pullToRefreshView.delegate = self;
		[self.tableView addSubview:self.pullToRefreshView];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[self removeObserver:self forKeyPath:@"responseDictionarys" context:nil];
	self.pullToRefreshView = nil;
}
	

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
	[self reloadTableData];
}

#pragma mark - Downloading Table Data

- (void)reloadTableData {
  if (!self.isLoaded && !self.isLoading) {
    self.isLoading = YES;
    
    [[ANHTTPClient sharedClient] getPath:@"/photos.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
      // No need to parse JSON again, AFNetworking will do that for you.		
			// NSLog(@"Response Object %@", responseObject);
			self.responseDictionarys = (NSArray *)responseObject;
      self.isLoading = NO;
      self.isLoaded = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      self.isLoading = NO;
    }];
  }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NIDPRINT(@"self.responseDictionarys has been updated.");
	NIDPRINT(@"self.responseDictionarys: %@", self.responseDictionarys);
	[self.tableView reloadData];
	[self.pullToRefreshView finishedLoading];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[NSNumber numberWithFloat:ceil([self.responseDictionarys count]/2.0)] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *PhotosCellIdentifier = @"PhotosCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PhotosCellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
  
	for (UIView *subview in [cell.contentView subviews]) {
    [subview removeFromSuperview];
	}
	
	NSUInteger row = indexPath.row;
	for (int i = row * 2; i <= row * 2 + 1 && i < [self.responseDictionarys count]; i++) {
		NSDictionary *singlePhotoInfo;
		if (i < [self.responseDictionarys count]) {
			singlePhotoInfo = [self.responseDictionarys objectAtIndex:i];	
		}
		NSURL *thumbURL = [NSURL URLWithString:[[[singlePhotoInfo objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"]];
		
		CGRect frame;
		if (i % 2 == 0) {
			frame = CGRectMake(0.0f, 0.0f, kThumbPhotoWidth, kThumbPhotoHeight);
		} else {
			frame = CGRectMake(165.0f, 0.0f, kThumbPhotoWidth, kThumbPhotoHeight);
		}
		
		UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:frame];
		photoImageView.tag = i;
		[photoImageView setUserInteractionEnabled:YES];
		[photoImageView setImageWithURL:thumbURL placeholderImage:nil];	
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
		tap.cancelsTouchesInView = YES;
		tap.numberOfTapsRequired = 1;
		tap.delegate = self;
		[photoImageView addGestureRecognizer:tap];
		
		[cell.contentView addSubview:photoImageView];
	}
	
  return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kThumbPhotoHeight;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

#pragma mark - Tap Gesture Recognizer 

- (void)handleImageTap:(UITapGestureRecognizer *)tapGestureRecognizer {
	CGPoint tappedImagePoint = [tapGestureRecognizer locationInView:self.tableView];
	UIView *view = [self.tableView hitTest:tappedImagePoint withEvent:nil];
	if ([view isMemberOfClass:[UIImageView class]]) {
		//TODO: Push child view controller to display detail information about the tapped image	
		
		UITableViewCell *selectedCell = (UITableViewCell *)[[view superview] superview];
		NSInteger selectedImageCellRow = [self.tableView indexPathForCell:selectedCell].row;
		NSInteger selectedImageInfoIndex = view.tag % 2 == 0 ? selectedImageCellRow * 2 : selectedImageCellRow * 2 + 1;
		NIDPRINT(@"tag: %d", view.tag);
		NSDictionary *selectedImageInfo = [self.responseDictionarys objectAtIndex:selectedImageInfoIndex];
		ANPhotoViewController *photoViewController = [[ANPhotoViewController alloc] initFromPhotosViewController:selectedImageInfo];
		[self.navigationController pushViewController:photoViewController animated:YES];
	}
}

#pragma mark - Pull To Refresh View Delegate 

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
	self.isLoaded = NO;
	[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}


@end
