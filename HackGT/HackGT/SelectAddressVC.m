//
//  SelectAddressVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "SelectAddressVC.h"

@interface SelectAddressVC ()

@property(nonatomic,retain) CLLocationManager *locationManager;

@end

@implementation SelectAddressVC{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.   
    
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
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        GMSAddress * address = [response results][0];
        NSMutableString * result = [[NSMutableString alloc] initWithString:address.lines[0]];
        [result appendString:@" "];
        [result appendString:address.lines[1]];
        
        _addressString = [[NSString alloc] initWithString:result];  // Address string is stored for when the user clicks next
        [_addressTextBox setText:result];
    }];

    
    self.mapView = [GMSMapView mapWithFrame:_viewForMap.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    [_viewForMap addSubview:self.mapView];
}

- (void)viewWillLayoutSubviews {
    // Padding the map so our buttons still appear:
    /*    Top,  L,  Bot,  R
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(450.0, 0.0, 0.0, 0.0);
    self.mapView.padding = mapInsets;*/
    [super viewWillLayoutSubviews];
    self.mapView.padding =
    UIEdgeInsetsMake(self.topLayoutGuide.length + 30,
                     0,
                     self.bottomLayoutGuide.length + 5,
                     0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Google Map Events

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        GMSAddress * address = [response results][0];
        NSMutableString * result = [[NSMutableString alloc] initWithString:address.lines[0]];
        [result appendString:@" "];
        [result appendString:address.lines[1]];
        
        _addressString = [[NSString alloc] initWithString:result];  // Address string is stored for when the user clicks next
        [_addressTextBox setText:result];
    }];
    
    /*[[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        for(GMSAddress* addressObj in [response results])
        {
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
        }
    }];*/
}

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView{
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        GMSAddress * address = [response results][0];
        NSMutableString * result = [[NSMutableString alloc] initWithString:address.lines[0]];
        [result appendString:@" "];
        [result appendString:address.lines[1]];
        
        _addressString = [[NSString alloc] initWithString:result];  // Address string is stored for when the user clicks next
        [_addressTextBox setText:result];
    }];
    return false; // Returning false makes Google Maps still execute the default action for pressing the 'My Locaiton' button
}

@end
