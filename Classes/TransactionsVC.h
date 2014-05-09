//
//  TransactionsVC.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/6/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTransactionsVC.h"

@interface TransactionsVC : UITableViewController <TransactionsDelegate>
@property (strong, nonatomic) PFObject *accountObject;

@end
