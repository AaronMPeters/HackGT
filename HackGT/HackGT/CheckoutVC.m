//
//  CheckoutVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/21/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "CheckoutVC.h"

@interface CheckoutVC ()

@property(nonatomic,retain) CLLocationManager *locationManager;

@end

@implementation CheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self accessCartDatabase];
    
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
                                                                 zoom:15];
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        
        GMSAddress * address = [response results][0];
        if (address != nil){
            NSMutableString * result = [[NSMutableString alloc] initWithString:address.lines[0]];
            [result appendString:@" "];
            [result appendString:address.lines[1]];
  
            [_addressLabel setText:result];
        }
    }];
    
    
    self.mapView = [GMSMapView mapWithFrame:_viewForMap.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
    [_viewForMap addSubview:self.mapView];
}

-(void)viewDidAppear:(BOOL)animated
{    
    _subTotalLabel.text = [NSString stringWithFormat:@"$%.02f", [_subTotalAmount doubleValue]];
    _paypalCheckoutButton.enabled = false;
    [self calculateFees];
}

- (void)calculateFees
{
    double subTotal = [_subTotalAmount doubleValue];
    
    // First, calculate Delivery Fee: 20% of order, or $2.00, whichever is greater:
    _deliveryFee = subTotal * .2 < 2.00 ? 2.00 : subTotal * .2;
    _deliveryFeeLabel.text = [NSString stringWithFormat:@"$%.02f", _deliveryFee];
    
    // Next, processing fee, which is always 15% of order
    _processingFee = subTotal * .15;
    _processingFeeLabel.text = [NSString stringWithFormat:@"$%.02f", _processingFee];
    
    _grandTotal = subTotal + _deliveryFee + _processingFee;
    _grandTotalLabel.text = [NSString stringWithFormat:@"$%.02f", _grandTotal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)didCertifyAddress:(id)sender
{
    _addressCertifyButton.enabled = false;
    _paypalCheckoutButton.enabled = true;
}

- (IBAction)didClickCheckoutBtn:(id)sender
{
    PFObject *location = [PFObject objectWithClassName:@"Locations"];    
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
    location[@"location"] = point;
    location[@"type"] = @"request";
    [location saveInBackground];
    [self deleteAllItemsFromCart];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                      message:@"You will be charged if an available deilverer picks up your order. Until that time, you may cancel your order from the settings menu."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
}

#pragma mark SQLite Methods

- (void)accessCartDatabase
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _cartDatabasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"cart.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _cartDatabasePath ] == NO)
    {
        NSLog(@"%@", @"Table does not exist. Fatal error");
    }
    else
        NSLog(@"%@", @"Table exists and is open. Status OK");
}

//delete the item from the cart
- (BOOL)deleteAllItemsFromCart
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_cartDatabasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_shoppingCartDB) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Delete Please");
        
        const char* delete_stmt = "DELETE FROM cart;";   // THIS DELETE EVERYTHING FROM THE CART!!!
        
        //const char *delete_stmt = [deleteSQL UTF8String];
        if (sqlite3_prepare_v2(_shoppingCartDB, delete_stmt, -1, &statement, NULL ) != SQLITE_OK )
        {
            NSLog(@"Failed to compile statement");
        }
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        else
        {
            NSLog(@"Failed to delete data");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_shoppingCartDB);
        
    }
    
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:@"0"];
    return success;
}


@end
