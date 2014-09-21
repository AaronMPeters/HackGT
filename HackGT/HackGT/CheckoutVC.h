//
//  CheckoutVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/21/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface CheckoutVC : UIViewController <GMSMapViewDelegate>

@property (nonatomic) NSNumber *subTotalAmount;
@property (nonatomic) double deliveryFee;
@property (nonatomic) double processingFee;
@property (nonatomic) double grandTotal;

@property(strong, nonatomic) GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *processingFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *grandTotalLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressCertifyButton;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIButton *paypalCheckoutButton;

@property (nonatomic) sqlite3 *shoppingCartDB;
@property (strong, nonatomic) NSString *cartDatabasePath;

@end
