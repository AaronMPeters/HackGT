//
//  EditProfileVC.m
//  HackGT
//
//  Created by Aaron Peters on 9/21/14.
//  Copyright (c) 2014 Aaron Peters. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
