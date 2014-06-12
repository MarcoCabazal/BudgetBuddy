//
//  AccountCell.h
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/24/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface AccountCell : SWTableViewCell
//@interface AccountCell : UITableViewCell
@property (weak, nonatomic) UILabel *customLabel;
@property (weak, nonatomic) UIImageView *customImageView;

- (void)configureCellWithDescription:(NSString*)accountDescription andAmount:(NSNumber*)transactionsAmount;

@end
