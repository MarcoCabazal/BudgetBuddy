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

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNewVC)];
    self.navigationItem.rightBarButtonItem = addButton;


    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [container setBackgroundColor:[UIColor blueColor]];

    [self.navigationItem setTitle:@"TZ Buddy"];

    [self.view addSubview:container];
}

- (void)displayNewVC {

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   	
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
