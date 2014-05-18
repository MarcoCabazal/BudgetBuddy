//
//  MasterViewController.m
//  Piggy
//
//  Created by Marco Cabazal on 4/20/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AccountsVC.h"
#import "AccountVC.h"
#import "TransactionsVC.h"
#import "LoginVC.h"
#import "SignUpVC.h"

@interface AccountsVC () {
    NSMutableArray *_objects;
    NSMutableDictionary *_transactions;
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

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(logoutUser)];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayNewAccountsVC)];
    self.navigationItem.rightBarButtonItem = addButton;

	_transactions = [NSMutableDictionary dictionary];
}

- (void)viewDidAppear:(BOOL)animated {

    PFUser *currentUser = [PFUser currentUser];

	if (! currentUser) {

        LoginVC *logInViewController = [[LoginVC alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFields: PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];

        SignUpVC *signUpViewController = [[SignUpVC alloc] init];
        [signUpViewController setDelegate:self];

        [logInViewController setSignUpController:signUpViewController];

        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

    if (currentUser) {

        PFQuery *query = [PFQuery queryWithClassName:@"Account"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query whereKey:@"owner" equalTo:currentUser];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            _objects = [objects mutableCopy];

            for (PFObject *accountObject in _objects) {

				PFQuery *transactionQuery = [PFQuery queryWithClassName:@"Transaction"];
                transactionQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
                [transactionQuery whereKey:@"owner" equalTo:currentUser];
                [transactionQuery whereKey:@"account" equalTo:accountObject];

                [transactionQuery findObjectsInBackgroundWithBlock:^(NSArray *transactionObjects, NSError *error) {

                    NSArray *transactions = [transactionObjects copy];

                    double total;

                    total = 0;

                    for (PFObject *transaction in transactions) {

						total = total + [transaction[@"transactionAmount"] doubleValue];
                    }

					[_transactions setObject:[NSNumber numberWithDouble:total] forKey:accountObject[@"accountDescription"]];

                    [self.tableView reloadData];
                }];

            }

            [self.tableView reloadData];
        }];
    }

    [self.tableView reloadData];
}

#pragma mark - Login Delegate

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {

    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SignUp Delegate

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {

    BOOL informationComplete = YES;

    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {

    [self dismissModalViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {

    NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {

    NSLog(@"User dismissed the signUpViewController");
}

- (void)logoutUser {

    [PFUser logOut];

    [self viewDidAppear:YES];
}

- (void)saveNewAccount:(NSString *)accountDescription accountType:(NSString *)accountType {

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

- (void)updateAccount:(PFObject *)accountObject withDescription:(NSString *)accountDescription andAccountType:(NSString *)accountType {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {

		if (accountDescription)
            accountObject[@"accountDescription"] = accountDescription;

        if (accountType)
            accountObject[@"accountType"] = accountType;

        int i;

        for (i = 0; i < [_objects count]; i++) {

            PFObject *object = [_objects objectAtIndex:i];

			if ([object.objectId isEqualToString:accountObject.objectId]) {

				[_objects replaceObjectAtIndex:i withObject:accountObject];
            }
        }

        [accountObject saveEventually];
    }
}

- (void)displayNewAccountsVC {

    AccountVC *accountVC = [[AccountVC alloc] init];
    [accountVC setDelegate:self];

    [self.navigationController pushViewController:accountVC animated:YES];
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

    cell.textLabel.text = object[@"accountDescription"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_transactions valueForKey:object[@"accountDescription"]]];

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    PFObject *object = _objects[indexPath.row];

    AccountVC *accountVC = [[AccountVC alloc] init];
    [accountVC setDelegate:self];
    [accountVC setAccountObject:object];

    [self.navigationController pushViewController:accountVC animated:YES];
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

        PFUser *currentUser = [PFUser currentUser];
        PFObject *accountObject = _objects[indexPath.row];

        PFQuery *query = [PFQuery queryWithClassName:@"Transaction"];
        [query whereKey:@"owner" equalTo:currentUser];
        [query whereKey:@"account" equalTo:accountObject];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            for (PFObject *object in objects) {

                [object deleteEventually];
            }
        }];

        
        [accountObject deleteEventually];
        
        [_objects removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
