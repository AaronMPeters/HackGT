//
//  MapOverviewVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/21/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface MapOverviewVC : UIViewController <GMSMapViewDelegate>

@property(strong, nonatomic) GMSMapView *mapView;
@property(strong, nonatomic) NSMutableArray *markers;

@end
