//
//  ANPhotosViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANPhotosViewController.h"
#import "ANHTTPClient.h"
#import "UIImageView+AFNetworking.h"

@interface ANPhotosViewController ()

@end

@implementation ANPhotosViewController

@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;
@synthesize responseDictionarys = _responseDictionarys;


- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    self.title = @"最新照片";
    self.tabBarItem.image = [UIImage imageNamed:@"42-photos"];
  }
  return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NIDPRINT(@"self.responseDictionarys has been updated.");
	NIDPRINT(@"self.responseDictionarys: %@", self.responseDictionarys);
	[self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
	[self addObserver:self forKeyPath:@"responseDictionarys" options:NSKeyValueObservingOptionOld context:nil];
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
  
	NSUInteger row = indexPath.row;
	NSLog(@"row: %d", row);
	for (int i = row * 2; i <= row * 2 + 1; i++) {
		NSLog(@"index: %d", i);
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
			[photoImageView setImageWithURL:thumbURL placeholderImage:nil];	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

@end
