//
//  CartTVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "CartTVC.h"

@interface CartTVC ()

@end

@implementation CartTVC

- (void)viewDidAppear:(BOOL)animated
{
    _foodItemsFormatted = [[NSMutableArray alloc] init];
    _foodCosts = [[NSMutableArray alloc] init];
    _foodItemsRaw = [[NSMutableArray alloc] init];
    _qtyOfItems  = [[NSMutableArray alloc] init];
    _totalCost = 0;
    
    [self accessCartDatabase];
    [self getAllItemsFromCart];
    [self getCartRestaurant];
    _cart_items = [self getCartCount];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_foodItemsFormatted count];
            break;
        case 1:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"CartItemCell" forIndexPath:indexPath];
            cell.textLabel.text = [_foodItemsFormatted objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [_foodCosts objectAtIndex:indexPath.row];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitButtonCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Submit Order";
            NSString * totalAmount = [NSString stringWithFormat:@"$%.02f", _totalCost];
            cell.detailTextLabel.text = totalAmount;
            break;
    }
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _totalCost -= [[_foodCosts objectAtIndex:indexPath.row] doubleValue];
        NSString * cartCount = [NSString stringWithFormat:@"%d", --_cart_items];
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:cartCount];
        
        int row = (int)indexPath.row;
        
        [self deleteItemFromCartForItem:[_foodItemsRaw objectAtIndex:row] andPrice:[[_foodCosts objectAtIndex:row] doubleValue] andQty:[[_qtyOfItems objectAtIndex:row] intValue]];
        
        [_foodItemsRaw removeObjectAtIndex:row];
        [_foodItemsFormatted removeObjectAtIndex:row];
        [_foodCosts removeObjectAtIndex:row];
        [_qtyOfItems removeObjectAtIndex:row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 1)];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
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

- (void)getAllItemsFromCart
{
    const char *dbpath = [_cartDatabasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_shoppingCartDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT food_item, price, qty FROM cart"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_shoppingCartDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *food_item_field = [[NSString alloc]
                                             initWithUTF8String:(const char *)
                                             sqlite3_column_text(statement, 0)];
                NSString *qty_field = [[NSString alloc]
                                       initWithUTF8String:(const char *)
                                       sqlite3_column_text(statement, 2)];
                NSString *price_field = [[NSString alloc]
                                             initWithUTF8String:(const char *)
                                             sqlite3_column_text(statement, 1)];
                
                _totalCost += [price_field doubleValue];
                
                NSString *listItem = [NSString stringWithFormat:@"%@ X %@", qty_field, food_item_field];
                
                [_foodItemsRaw addObject:food_item_field];
                [_qtyOfItems addObject:qty_field];
                [_foodItemsFormatted addObject:listItem];
                [_foodCosts addObject:price_field];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_shoppingCartDB);
        [self.tableView reloadData];
    }
}

- (int) getCartCount
{
    int count = 0;
    if (sqlite3_open([_cartDatabasePath UTF8String], &_shoppingCartDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM CART";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(_shoppingCartDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_shoppingCartDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(_shoppingCartDB);
    }
    
    return count;
}

- (void) getCartRestaurant
{
    int count = 0;
    if (sqlite3_open([_cartDatabasePath UTF8String], &_shoppingCartDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT restaurant FROM CART LIMIT 1";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(_shoppingCartDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                self.navigationItem.title = [NSString stringWithFormat:@"Cart for %s", sqlite3_column_text(statement, 0)];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(_shoppingCartDB) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(_shoppingCartDB);
    }
}

//delete the item from the cart
- (BOOL) deleteItemFromCartForItem:(NSString *)item andPrice:(double)price andQty:(int)qty
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_cartDatabasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_shoppingCartDB) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Delete Please");
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from CART WHERE food_item=\"%@\" AND price=\"%f\" AND qty=\"%d\";", item, price, qty];
        
        //const char* delete_stmt = "DROP TABLE cart"; //"DELETE FROM cart";   // THIS DELETE EVERYTHING FROM THE CART!!!
        
        const char *delete_stmt = [deleteSQL UTF8String];
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
    
    return success;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
