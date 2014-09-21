//
//  MapOverviewVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/21/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "MapOverviewVC.h"

@interface MapOverviewVC ()

@property(nonatomic,retain) CLLocationManager *locationManager;

@end

@implementation MapOverviewVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillLayoutSubviews];
    self.mapView.padding =
    UIEdgeInsetsMake(self.topLayoutGuide.length + 30,
                     0,
                     self.bottomLayoutGuide.length + 50,
                     0);
    
    [self getAllActiveDeliverers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Location services:
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_locationManager startUpdatingLocation];
    
    // Google Maps API:
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_locationManager.location.coordinate.latitude
                                                            longitude:_locationManager.location.coordinate.longitude
                                                                 zoom:19];
    
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

# pragma mark - parse methods

- (void)getAllActiveDeliverers
{
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                
                // Creates a marker in the center of the map.
                GMSMarker *marker = [[GMSMarker alloc] init];
                if ([object[@"type"]  isEqual: @"deliver"]){
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                    marker.title = @"Delivery";
                }
                else if ([object[@"type"]  isEqual: @"request"]){
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                    marker.title = @"Requestor";
                }

                PFGeoPoint *point = object[@"location"];
                marker.position = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                marker.map = _mapView;
                [_markers addObject:marker];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
