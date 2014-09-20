//
//  MenuSelectionTVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MenuSelectionTVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *foodItems;
@property (strong, nonatomic) NSMutableArray *foodCosts;

@end
