//
//  CartTVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CartTVC : UITableViewController

@property (nonatomic) sqlite3 *shoppingCartDB;
@property (strong, nonatomic) NSString *cartDatabasePath;

@property (strong, nonatomic) NSMutableArray *foodItems;
@property (strong, nonatomic) NSMutableArray *foodCosts;

@end
