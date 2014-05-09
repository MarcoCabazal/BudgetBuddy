//
//  NewVC.m
//  Piggy
//
//  Created by Marco Cabazal on 4/22/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "NewTransactionsVC.h"

@interface NewTransactionsVC ()

@end

@implementation NewTransactionsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:@"New Transaction"];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissThisVC)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];

    [self.transactionDescription becomeFirstResponder];

    [self.navigationItem setTitle:@"New Transaction"];
}

- (void)viewDidAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark TextField Notification

-(void) keyboardDidShow:(NSNotification*) notification {

}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField == self.transactionDescription) {

        [self.transactionAmount becomeFirstResponder];

    } else if (textField == self.transactionAmount) {

        if ([self.transactionDescription.text length] > 0 && [self.transactionAmount.text length] > 0) {

            [textField resignFirstResponder];

            [self.view endEditing:YES];

            [self.createTransactionButton setEnabled:YES];

        } else {

            [self.transactionDescription becomeFirstResponder];

        }
    }

    return YES;
}

- (IBAction)createTransaction {

    [self.delegate saveNewTransaction:self.transactionDescription.text transactionAmount:[NSNumber numberWithDouble:[self.transactionAmount.text doubleValue]]];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissThisVC {

//    [self createTransaction];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
