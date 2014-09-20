//
//  NewItemVC.h
//  HackGT
//
//  Created by Aaron Peters on 9/20/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *menuItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UIStepper *qtyStepper;
@property (weak, nonatomic) IBOutlet UITextView *specialInstructionsField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
