//
//  MasterViewController.m
//  Piggy
//
//  Created by Marco Cabazal on 4/20/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AccountsVC.h"
#import "NewAccountsVC.h"
#import "TransactionsVC.h"

@interface AccountsVC () {
    NSMutableArray *_objects;
}
@end

@implementation AccountsVC

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:@"Accounts Overview"];

	UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    [self setTabBarItem:item];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNewAccountsVC)];
    self.navigationItem.rightBarButtonItem = addButton;


    PFUser *currentUser = [PFUser currentUser];

	if (! currentUser) {

        NSLog (@"currentUser not found.");
        // TODO: present login form

    } else {

        PFQuery *query = [PFQuery queryWithClassName:@"Account"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query whereKey:@"owner" equalTo:currentUser];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            _objects = [objects mutableCopy];
            [self.tableView reloadData];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [self.tableView reloadData];
}

- (void) saveNewAccount:(NSString *)accountDescription accountType:(NSString *)accountType {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {

        PFObject *accountObject = [PFObject objectWithClassName:@"Account"];
        accountObject[@"accountDescription"] = accountDescription;
        accountObject[@"accountType"] = accountType;
        accountObject[@"owner"] = currentUser;

        [_objects addObject:accountObject];
        [accountObject saveEventually];
    }
}

- (void)displayNewAccountsVC {

    NewAccountsVC *newVC = [[NewAccountsVC alloc] init];
    [newVC setDelegate:self];
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

    cell.textLabel.text = object[@"accountDescription"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    PFObject *accountObject = _objects[indexPath.row];

	TransactionsVC *transactionsVC = [[TransactionsVC alloc] init];
    [transactionsVC setAccountObject:accountObject];

    [self.navigationController pushViewController:transactionsVC animated:YES];
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
