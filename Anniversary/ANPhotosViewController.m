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
#import "ANPhotosTableViewCell.h"
#import "ANPhotoViewController.h"
#import "ANPhoto.h"

@interface ANPhotosViewController ()
- (void)handleImageTap:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)reloadTableData;
@end

@implementation ANPhotosViewController

@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;
@synthesize photos = _photos;
@synthesize pullToRefreshView = _pullToRefreshView;

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    self.title = @"最新照片";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleView"]];
    self.tabBarItem.image = [UIImage imageNamed:@"42-photos"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:kNotificationPhotosNeedsRefresh object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  _pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *)self.tableView];	
  _pullToRefreshView.delegate = self;
  [self.tableView addSubview:_pullToRefreshView];
  
  self.tableView.allowsSelection = NO;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	_pullToRefreshView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!self.isLoaded) {
    [self reloadTableData];
  }
}

#pragma mark - Downloading Table Data

- (void)reloadTableData {
  if (!self.isLoading) {
    self.isLoading = YES;
    
    [[ANHTTPClient sharedClient] getPath:@"/photos.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
      NSMutableArray *photos = [NSMutableArray array];
      for (NSDictionary *dictioanry in responseObject) {
        ANPhoto *photo = [[ANPhoto alloc] init];
        photo.objectID = [[dictioanry objectForKey:@"id"] integerValue];
        photo.photoDescription = [dictioanry objectForKey:@"description"];
        photo.createdAt = [dictioanry objectForKey:@"created_at"];
        photo.updatedAt = [dictioanry objectForKey:@"updated_at"];
        photo.imageURL = [NSURL URLWithString:[[dictioanry objectForKey:@"image"] objectForKey:@"url"]];
        photo.thumbURL = [NSURL URLWithString:[[[dictioanry objectForKey:@"image"] objectForKey:@"thumb"] objectForKey:@"url"]];
        photo.userFid = [[[dictioanry objectForKey:@"user"] objectForKey:@"fid"] longLongValue];
        photo.userName = [[dictioanry objectForKey:@"user"] objectForKey:@"name"];
        photo.longitude = [[dictioanry objectForKey:@"longitude"] doubleValue];
        photo.latitude = [[dictioanry objectForKey:@"latitude"] doubleValue];
        
        [photos addObject:photo];
      }
      self.photos = photos;
      self.isLoading = NO;
      self.isLoaded = YES;
      
      [self.tableView reloadData];
      [self.pullToRefreshView finishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      self.isLoading = NO;
      
      [self.pullToRefreshView finishedLoading];
    }];
  }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ceil(self.photos.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *PhotosCellIdentifier = @"PhotosCellIdentifier";
  ANPhotosTableViewCell *cell = (ANPhotosTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PhotosCellIdentifier];
	
	if (!cell) {
    __weak ANPhotosViewController *tempSelf = self;
    
		cell = [[ANPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PhotosCellIdentifier];
    UIGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){      
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.photos.count) {
          ANPhoto *photo = [tempSelf.photos objectAtIndex:sender.view.tag];
          ANPhotoViewController *viewController = [[ANPhotoViewController alloc] initWithPhoto:photo];
          [tempSelf.navigationController pushViewController:viewController animated:YES];
        }
      }
    }];
    [cell.imageView1 addGestureRecognizer:recognizer1];
    cell.imageView1.userInteractionEnabled = YES;
    
    UIGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
      if (UIGestureRecognizerStateRecognized == state) {
        if (sender.view.tag < tempSelf.photos.count) {
          ANPhoto *photo = [tempSelf.photos objectAtIndex:sender.view.tag];
          ANPhotoViewController *viewController = [[ANPhotoViewController alloc] initWithPhoto:photo];
          [tempSelf.navigationController pushViewController:viewController animated:YES];
        }
      }
    }];
    [cell.imageView2 addGestureRecognizer:recognizer2];
    cell.imageView2.userInteractionEnabled = YES;
	}
  
  NSUInteger index1 = 2 * indexPath.row;
  
  ANPhoto *photo1 = [_photos objectAtIndex:index1];
  cell.imageView1.tag = index1;
  ANPhoto *photo2 = nil; 
  
  NSUInteger index2 = 2 * indexPath.row + 1;
  
  if (index2 < self.photos.count) {
    photo2 = [_photos objectAtIndex:index2];
    cell.imageView2.tag = index2;
  };
  
  [cell.imageView1 setImageWithURL:photo1.thumbURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
  [cell.imageView2 setImageWithURL:photo2.thumbURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
	
  return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kThumbPhotoHeight + 20;
}

#pragma mark - Pull To Refresh View Delegate 

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
  [self reloadTableData];
}

@end
