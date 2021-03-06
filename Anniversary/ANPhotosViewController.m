//
//  ANPhotosViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/12/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import "ANPhotosViewController.h"
#import "ANHTTPClient.h"
#import "ANPhotoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ANPhotosTableViewCell.h"
#import "ANPhotoViewController.h"
#import "ANPhoto.h"
#import "ANLoadMoreCell.h"

@interface ANPhotosViewController ()

- (void)reloadTableData;

@end

@implementation ANPhotosViewController

@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;
@synthesize photos = _photos;
@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize canLoadMore = _canLoadMore;

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
  
  if (!self.isLoaded && !self.isLoading) {
    [self.pullToRefreshView setState:PullToRefreshViewStateLoading];
    [self reloadTableData];
  }
}

#pragma mark - Downloading Table Data

- (void)reloadTableData {
  if (!self.isLoading) {
    self.canLoadMore = NO;
    self.currentPageIndex = 0;
    self.isLoading = YES;
    
    __weak ANPhotosViewController *tempSelf = self;
    
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
      tempSelf.photos = photos;
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      tempSelf.currentPageIndex++;
      
      if (photos.count != 0) {
        tempSelf.canLoadMore = YES;
      } else {
        tempSelf.canLoadMore = NO;
      }
      
      [tempSelf.tableView reloadData];
      [tempSelf.pullToRefreshView finishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      tempSelf.isLoading = NO;
      
      [tempSelf.pullToRefreshView finishedLoading];
    }];
  }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.photos.count == 0) {
    return 0;
  }
  
	return ceil(self.photos.count / 2.0) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row * 2 >= self.photos.count) {
    ANLoadMoreCell *cell = (ANLoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:@"LoadMoreCellIdentifier"];
    if (!cell) {
      cell = [[ANLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadMoreCellIdentifier"];
    }
    
    if (self.canLoadMore) {
      [cell.activityIndicatorView startAnimating];
    } else {
      [cell.activityIndicatorView stopAnimating];
    }
    
    return cell;
  }
  
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
    
    cell.imageView1.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.imageView1.layer.borderWidth = 2;
    
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
    
    cell.imageView2.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.imageView2.layer.borderWidth = 2;
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row * 2 < self.photos.count ? kThumbPhotoHeight + 20 : 44;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([cell isKindOfClass:[ANLoadMoreCell class]] &&
      ceil(self.photos.count / 2.0) - [tableView.indexPathsForVisibleRows.lastObject row] < 2 &&
      !self.isLoading && self.canLoadMore) {
    self.isLoading = YES;
    
    __weak ANPhotosViewController *tempSelf = self;
    
    [[ANHTTPClient sharedClient] getPath:[NSString stringWithFormat:@"/photos.json?page=%d", self.currentPageIndex + 1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
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
      tempSelf.photos = [tempSelf.photos arrayByAddingObjectsFromArray:photos];
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      tempSelf.currentPageIndex++;
      
      if (photos.count != 0) {
        tempSelf.canLoadMore = YES;
      } else {
        tempSelf.canLoadMore = NO;
      }
      
      [tempSelf.tableView reloadData];
      [tempSelf.pullToRefreshView finishedLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      tempSelf.isLoading = NO;
      
      [tempSelf.pullToRefreshView finishedLoading];
    }];
  }
}

#pragma mark - Pull To Refresh View Delegate 

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
  [self reloadTableData];
}

@end
