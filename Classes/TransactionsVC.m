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
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [query whereKey:@"owner" equalTo:currentUser];
        [query whereKey:@"account" equalTo:self.accountObject];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            _objects = [objects mutableCopy];
            [self.tableView reloadData];
        }];
    }
}

- (void)displayNewVC {

    NewTransactionsVC *newVC = [[NewTransactionsVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:newVC];

    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)signup {

    PFUser *user = [PFUser user];
    user.username = @"marku";
    user.password = @"h3ll0";
    user.email = @"marco.cabazal@gmail.com";


    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

        } else {
            NSString *errorString = [error userInfo][@"error"];

            NSLog (@"Singup Error: %@", errorString);

        }
    }];
}

- (void)login {

    [PFUser logInWithUsernameInBackground:@"marku" password:@"h3ll0"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {

                                            NSLog (@"login success.");

                                        } else {

                                            NSString *errorString = [error userInfo][@"error"];

                                            NSLog (@"Login Error: %@", errorString);
                                        }
                                    }];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }

    PFObject *object = _objects[indexPath.row];

    cell.textLabel.text = object[@"transactionDescription"];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
