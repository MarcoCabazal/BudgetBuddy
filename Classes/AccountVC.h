//
//  NewAccountsVC.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/5/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountTypesVC.h"

@protocol AccountDelegate <NSObject>

@optional
- (void) saveNewAccount:(NSString*)accountDescription accountType:(NSString*)accountType;
- (void) updateAccount:(PFObject*)accountObject withDescription:(NSString*)accountDescription andAccountType:(NSString*)accountType;
@end

@interface AccountVC : UIViewController <UITextFieldDelegate, AccountTypesDelegate>

@property (strong, nonatomic) PFObject *accountObject;
@property (strong, nonatomic) IBOutlet UITextField *accountDescription;
@property (strong, nonatomic) IBOutlet UITextField *accountType;
@property (strong, nonatomic) IBOutlet UIButton *accountTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *createAccountButton;
@property (nonatomic, assign) id <AccountDelegate> delegate;
@end

