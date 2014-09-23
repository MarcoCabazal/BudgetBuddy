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
#import "AccountCell.h"
#import "LoginVC.h"
#import "SignUpVC.h"
#import "SWTableViewCell.h"

@interface AccountsVC () {
    NSMutableArray *_objects;
    NSMutableDictionary *_transactions;
}

@property (strong, nonatomic) UITableView *tableView;
@end

@implementation AccountsVC

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self setTitle:@"Accounts Overview"];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    [self.tableView setAutoresizesSubviews:YES];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"AccountCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    [self.view addSubview:self.tableView];

	UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    [self setTabBarItem:item];


    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] init];
    [logoutButton setTitle:@"Logout"];
    [logoutButton setAction:@selector(logoutUser)];
    [self.navigationItem setLeftBarButtonItem:logoutButton];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] init];
    [addButton setTitle:@"Add"];
    [addButton setAction:@selector(displayNewAccountsVC)];
    [addButton setTarget:self];
    [self.navigationItem setRightBarButtonItem:addButton];

	_transactions = [NSMutableDictionary dictionary];

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

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
    return NO;
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

        if (!field || field.length == 0) {

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

    [self dismissViewControllerAnimated:YES completion:nil];
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

     UINavigationController *tempNav = [[UINavigationController alloc] initWithRootViewController:accountVC];
    [self presentViewController:tempNav animated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"AccountCell";

    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    PFObject *object = _objects[indexPath.row];

    cell.rightUtilityButtons = [self leftButtons];
    cell.delegate = self;

    [cell configureCellWithDescription:object[@"accountDescription"] andAmount:[_transactions valueForKey:object[@"accountDescription"]]];

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

#pragma mark - SWTableViewDelegate

- (NSArray *)rightButtons {

    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];

    return rightUtilityButtons;
}

- (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];

    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                               title:@"Delete"] ;

    return leftUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {

    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {

    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];

            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
                // Delete button was pressed
//            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

//            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

            NSLog (@"boo");
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
        // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    switch (state) {
        case 1:
                // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
                // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

@end
