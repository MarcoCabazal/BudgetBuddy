//
//  AccountTypesVC.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/12/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountTypesDelegate <NSObject>

@required
- (void) updateAccountTypeWith:(NSString*)accountType;

@end

@interface AccountTypesVC : UITableViewController
@property (strong, nonatomic) NSString *selectedAccountType;
@property (nonatomic, assign) id <AccountTypesDelegate> delegate;

@end
