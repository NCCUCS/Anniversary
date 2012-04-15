//
//  ANMapViewController.m
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "ANMapViewController.h"
#import "ANPhotoViewController.h"
#import "ANHTTPClient.h"
#import "ANPhoto.h"

@interface ANMapViewController ()

@end

@implementation ANMapViewController

@synthesize isLoaded = _isLoaded;
@synthesize isLoading = _isLoading;
@synthesize photos = _photos;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"全球校友";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleView"]];
    self.tabBarItem.image = [UIImage imageNamed:@"07-map-marker"];
  }
  return self;
}

#pragma mark - Private

- (void)reloadData {
  if (!self.isLoading) {
    self.isLoading = YES;
    
    [[ANHTTPClient sharedClient] getPath:@"/photos/locations.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
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
        
        NIDPRINT(@"Location %f, %f", photo.longitude, photo.latitude);
        
        if (CLLocationCoordinate2DIsValid(photo.coordinate)) {
          [photos addObject:photo];
        }
      }
      self.photos = photos;
      self.isLoading = NO;
      self.isLoaded = YES;
      
      [self.mapView removeAnnotations:self.mapView.annotations];
      [self.mapView addAnnotations:self.photos];
      
      MKMapRect rect = MKMapRectNull;
      
      for (ANPhoto *photo in photos) {
        MKMapPoint photoCoordinatePoint = MKMapPointForCoordinate(photo.coordinate);
        MKMapRect pointRect = MKMapRectMake(photoCoordinatePoint.x, photoCoordinatePoint.y, 0, 0);
        rect = MKMapRectUnion(rect, pointRect);
      }
      
      [_mapView setVisibleMapRect:rect animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
      self.isLoading = NO;
    }];
  }
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
  _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _mapView.showsUserLocation = YES;
  _mapView.delegate = self;
  [self.view addSubview:_mapView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  _mapView.delegate = nil;
  _mapView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!self.isLoaded) {
    [self reloadData];
  }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(self.class)];
  
  if (!view) {
    view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(self.class)];
    view.canShowCallout = YES;
    view.animatesDrop = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    __weak ANMapViewController *tempSelf = self;
    [button addEventHandler:^(id sender){
      ANPhoto *photo = (ANPhoto *)[(MKPinAnnotationView *)[[(UIButton *)sender superview] superview] annotation];
      [tempSelf.navigationController pushViewController:[[ANPhotoViewController alloc] initWithPhoto:photo] animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    view.rightCalloutAccessoryView = button;
  }
  view.annotation = annotation;
  
  return view;
}


@end
