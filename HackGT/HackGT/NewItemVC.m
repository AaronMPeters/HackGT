//
//  NewItemVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "NewItemVC.h"

@interface NewItemVC ()

@end

@implementation NewItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createOrAccessCartDatabase];
    _menuItemLabel.adjustsFontSizeToFitWidth = true;
    _menuItemLabel.text = _menuItemLabelText;
    _priceLabel.text = _priceLabelText;
    _current_qty = 1;
    _cart_items = [self getCartCount];
}
- (IBAction)didPressAddButton:(id)sender {
    [self saveDataToCartWithName:_menuItemLabelText andInstructions:_specialInstructionsTextView.text andPrice:_current_qty * [_menuItemPrice doubleValue] andQty:_current_qty];
    
    ++_cart_items;
    NSString * cartCount = [NSString stringWithFormat:@"%d", _cart_items];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:cartCount];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)valueDidChange:(UIStepper *)sender forEvent:(UIEvent *)event {
    double value = [sender value];
    _current_qty = value;
    _priceLabel.text = [NSString stringWithFormat:@"$%.02f", [_menuItemPrice floatValue] * _current_qty];
    [_qtyLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - SQLite3 methods

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

- (void)createOrAccessCartDatabase
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

- (void)saveDataToCartWithName:(NSString *)item andInstructions:(NSString *)instructions andPrice:(double)price andQty:(int)qty
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_cartDatabasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_shoppingCartDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO CART (food_item, special_instructions, price, qty) VALUES (\"%@\", \"%@\", \"%f\", \"%d\")",
                               item, instructions, price, qty];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_shoppingCartDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", @"Added item to cart with success");
        } else {
            NSLog(@"%@", @"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_shoppingCartDB);
    }
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
