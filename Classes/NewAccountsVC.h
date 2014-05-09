//
//  NewAccountsVC.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/5/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountsDelegate <NSObject>

@required
- (void) saveNewAccount:(NSString*)accountDescription accountType:(NSString*)accountType;

@end

@interface NewAccountsVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *accountDescription;
@property (strong, nonatomic) IBOutlet UITextField *accountType;
@property (nonatomic, assign) id <AccountsDelegate> delegate;
@end

