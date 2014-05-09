//
//  NewAccountsVC.m
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/5/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "NewAccountsVC.h"

@interface NewAccountsVC () {

}

@end

@implementation NewAccountsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self.accountDescription becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissThisVC)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

#pragma mark TextField Notification

-(void) keyboardDidShow:(NSNotification*) notification {
	
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.accountDescription) {

        [self.accountType becomeFirstResponder];

    } else if (textField == self.accountType) {

        if ([self.accountDescription.text length] > 0 && [self.accountType.text length] > 0) {

            [textField resignFirstResponder];

            [self.view endEditing:YES];

            [self.delegate saveNewAccount:self.accountDescription.text accountType:self.accountType.text];

            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

        } else {

            [self.accountDescription becomeFirstResponder];

        }
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}


- (void)dismissThisVC {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
