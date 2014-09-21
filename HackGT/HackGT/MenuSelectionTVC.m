//
//  MenuSelectionTVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "MenuSelectionTVC.h"

@interface MenuSelectionTVC ()

@end

@implementation MenuSelectionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retreiveFoodPricesFromDatabase];
    _foodItems = [[NSMutableArray alloc] init];
    _foodCosts = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    // Return the number of sections.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_foodItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_foodItems objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_foodCosts objectAtIndex:indexPath.row];
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

# pragma mark - parse methods

- (void)retreiveFoodPricesFromDatabase
{
    PFQuery *query = [PFQuery queryWithClassName:@"FoodPrice"];
    [query whereKey:@"RESTAURANT" equalTo:self.navigationItem.title];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                [_foodItems addObject:object[@"FOOD"]];
                NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", [object[@"PRICE"] floatValue]];
                [_foodCosts addObject:formattedNumber];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.tableView reloadData];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * segueIdentifier = [segue identifier];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if([segueIdentifier isEqualToString:@"NewItemSegue"]){
        NewItemVC *vc = (NewItemVC *)[segue destinationViewController];
        NSMutableString *text = [[NSMutableString alloc] initWithString:@"$"];
        [text appendString:[_foodCosts objectAtIndex:indexPath.row]];
        vc.menuItemPrice = [_foodCosts objectAtIndex:indexPath.row];
        vc.menuItemLabelText = [_foodItems objectAtIndex:indexPath.row];
        vc.priceLabelText = text;
    }
}


@end
