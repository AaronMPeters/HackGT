//
//  CreateOrderTVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MenuSelectionTVC.h"

@interface CreateOrderTVC : UITableViewController

@property (strong, nonatomic) NSArray *resturants;

@property (nonatomic) sqlite3 *shoppingCartDB;
@property (strong, nonatomic) NSString *cartDatabasePath;

@property (nonatomic) int cart_items;

@end
