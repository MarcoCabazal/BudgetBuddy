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

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:@"New Transaction"];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createTransaction)];
    self.navigationItem.rightBarButtonItem = doneButton;


	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissThisVC)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [container setBackgroundColor:[UIColor blueColor]];

    [self.navigationItem setTitle:@"New Transaction"];

    [self.view addSubview:container];
}

- (void)createTransaction {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {

        PFObject *transaction = [PFObject objectWithClassName:@"TransactionObject"];
        transaction[@"transactionDesc"] = @"PLDT Bills";
        transaction[@"owner"] = currentUser;
        [transaction saveEventually];
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissThisVC {

//    [self createTransaction];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
