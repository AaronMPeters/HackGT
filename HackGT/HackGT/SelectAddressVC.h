//
//  SelectAddressVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectAddressVC : UIViewController <GMSMapViewDelegate>

@property(strong, nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UITextField *addressTextBox;
@property (weak, nonatomic) IBOutlet UIButton *searchAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) NSString *addressString;

@end
