//
//  NewItemVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface NewItemVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *menuItemLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UIStepper *qtyStepper;
@property (weak, nonatomic) IBOutlet UITextField *specialInstructionsTextView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic) NSString *menuItemLabelText;
@property (strong, nonatomic) NSString *priceLabelText;
@property (strong, nonatomic) NSString *restaurant;
@property (strong, nonatomic) NSNumber *menuItemPrice;

@property (nonatomic) sqlite3 *shoppingCartDB;
@property (strong, nonatomic) NSString *cartDatabasePath;

@property (nonatomic) int current_qty;
@property (nonatomic) int cart_items;


@end
