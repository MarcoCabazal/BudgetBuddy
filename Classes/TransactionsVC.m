    //
    //  TransactionsVC.m
    //  Piggy
    //
    //  Created by Marco Cabazal on 4/20/14.
    //  Copyright (c) 2014 The Chill Mill. All rights reserved.
    //

#import "TransactionsVC.h"
#import "NewTransactionsVC.h"

@interface TransactionsVC () {
    NSMutableArray *_objects;
}
@end

@implementation TransactionsVC

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:self.accountObject[@"accountDescription"]];

    [self.navigationItem.backBarButtonItem setTitle:@"Accounts"];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNewVC)];
    self.navigationItem.rightBarButtonItem = addButton;

    PFUser *currentUser = [PFUser currentUser];

	if (! currentUser) {

        NSLog (@"currentUser not found.");
            // TODO: present login form

    } else {

        PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query whereKey:@"owner" equalTo:currentUser];
        [query whereKey:@"account" equalTo:self.accountObject];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            _objects = [objects mutableCopy];
            [self.tableView reloadData];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [self.tableView reloadData];
}

- (void)displayNewVC {

    NewTransactionsVC *newTransactionVC = [[NewTransactionsVC alloc] init];
    [newTransactionVC setDelegate:self];

    [self.navigationController pushViewController:newTransactionVC animated:YES];
}

- (void)saveNewTransaction:(NSString *)transactionDescription transactionAmount:(NSNumber *)transactionAmount {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {

        PFObject *transactionObject = [PFObject objectWithClassName:@"Transaction"];
        transactionObject[@"transactionDescription"] = transactionDescription;
        transactionObject[@"transactionAmount"] = transactionAmount;
        transactionObject[@"account"] = self.accountObject;
        transactionObject[@"owner"] = currentUser;

        [_objects addObject:transactionObject];
        [transactionObject saveEventually];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    }

    PFObject *object = _objects[indexPath.row];

    cell.textLabel.text = object[@"transactionDescription"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object[@"transactionAmount"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
