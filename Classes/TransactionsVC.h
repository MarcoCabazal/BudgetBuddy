//
//  TransactionsVC.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/6/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionVC.h"

@interface TransactionsVC : UIViewController <TransactionsDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFObject *accountObject;

@end
