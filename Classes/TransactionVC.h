//
//  NewVC.h
//  Piggy
//
//  Created by Marco Cabazal on 4/22/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransactionsDelegate <NSObject>

@required
- (void) saveNewTransaction:(NSString*)transactionDescription transactionAmount:(NSNumber*)transactionAmount;

@end

@interface TransactionVC : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *transactionDescription;
@property (strong, nonatomic) IBOutlet UITextField *transactionAmount;
@property (strong, nonatomic) IBOutlet UIButton *createTransactionButton;
@property (nonatomic, assign) id <TransactionsDelegate> delegate;

-(IBAction)createTransaction;

@end
