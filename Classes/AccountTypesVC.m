//
//  AccountTypesVC.m
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/12/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AccountTypesVC.h"

@interface AccountTypesVC () {

    NSArray *_accountTypes;
}

@end

@implementation AccountTypesVC

- (id)initWithStyle:(UITableViewStyle)style {

    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    _accountTypes = @[@"Credit Card", @"Savings Account", @"Checking Account", @"Wallet/Cash"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self.delegate updateAccountTypeWith:cell.textLabel.text];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"AccountTypesCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }


    NSString *accountType = [_accountTypes objectAtIndex:indexPath.row];

    if ([accountType isEqualToString:self.selectedAccountType]) {

            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

    } else {

            [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [cell.textLabel setText:accountType];

    
    return cell;
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
