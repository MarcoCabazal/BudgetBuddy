//
//  NewAccountsVC.m
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/5/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AccountVC.h"
#import "AccountTypesVC.h"

@interface AccountVC () {

}

@end

@implementation AccountVC

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

    if (self.accountObject) {

        [self.accountDescription setText:self.accountObject[@"accountDescription"]];
        [self.accountTypeButton setTitle:self.accountObject[@"accountType"] forState:UIControlStateNormal];
    }
}

#pragma mark TextField Notification

-(void) keyboardDidShow:(NSNotification*) notification {
	
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    return YES;
}

- (IBAction)createAccount {

    [self.view endEditing:YES];

    if (self.accountObject) {

        [self.delegate updateAccount:self.accountObject withDescription:self.accountDescription.text andAccountType:self.accountTypeButton.titleLabel.text];

    } else {

        [self.delegate saveNewAccount:self.accountDescription.text accountType:self.accountTypeButton.titleLabel.text];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showAccountTypes {

    AccountTypesVC *accountTypesVC = [[AccountTypesVC alloc] init];
    [accountTypesVC setDelegate:self];
    if (! [self.accountTypeButton.titleLabel.text isEqualToString:@"Account Type"]) {

        [accountTypesVC setSelectedAccountType:self.accountTypeButton.titleLabel.text];
    }

    [self.navigationController pushViewController:accountTypesVC animated:YES];
}

- (void)updateAccountTypeWith:(NSString *)accountType {

    [self.accountTypeButton setTitle:accountType forState:UIControlStateNormal];
}

- (void)dismissThisVC {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
