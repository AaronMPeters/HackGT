//
//  CreateOrderTVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "CreateOrderTVC.h"

@interface CreateOrderTVC ()

@end

@implementation CreateOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createOrAccessCartDatabase];
    
    _resturants = @[
                      @"McDonald's",
                      @"Wendy's",
                      @"Taco Bell"
                      ];
    
    _cart_items = [self getCartCount];
    NSString * cartCount = [NSString stringWithFormat:@"%d", _cart_items];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:cartCount];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_resturants count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [_resturants objectAtIndex:indexPath.section];
    NSMutableString *name = [[NSMutableString alloc] initWithString:[_resturants objectAtIndex:indexPath.section]];
    [name appendString:@"-Logo.png"];
    cell.imageView.image = [UIImage imageNamed:name];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - SQLite3 methods

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
        const char *dbpath = [_cartDatabasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_shoppingCartDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS CART (ID INTEGER PRIMARY KEY AUTOINCREMENT, FOOD_ITEM TEXT, SPECIAL_INSTRUCTIONS TEXT, PRICE DOUBLE, QTY INTEGER, RESTAURANT TEXT)";
            
            if (sqlite3_exec(_shoppingCartDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                NSLog(@"%@", @"Failed to create table");
            else
                NSLog(@"%@", @"Successfully created table");
            
            sqlite3_close(_shoppingCartDB);
        } else
            NSLog(@"%@", @"Failed to open/create database");
    }
    else
        NSLog(@"%@", @"Table already exists. Status OK");
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * segueIdentifier = [segue identifier];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if([segueIdentifier isEqualToString:@"MenuSegue"]){
        MenuSelectionTVC *tvc = (MenuSelectionTVC *)[segue destinationViewController];
        tvc.navigationItem.title = [_resturants objectAtIndex:indexPath.section];
    }
}


@end
