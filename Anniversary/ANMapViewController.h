//
//  ANMapViewController.h
//  Aniversary
//
//  Created by Lee Chih-Wei on 3/1/12.
//  Copyright (c) 2012 National Chengchi University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ANMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) MKMapView *mapView;

@end
