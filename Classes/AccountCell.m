//
//  AccountCell.m
//  Budget Buddy
//
//  Created by Marco Cabazal on 5/24/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AccountCell.h"
@interface AccountCell ()

@property (strong, nonatomic) NSString *accountDescription;
@property (strong, nonatomic) NSString *tranactionsAmount;
@property (strong, nonatomic) IBOutlet UILabel *accountDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *transactionsAmountLabel;

@end

@implementation AccountCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDescription:(NSString*)accountDescription andAmount:(NSNumber*)transactionsAmount {

    [self.accountDescriptionLabel setTextColor:OPAQUE_HEXCOLOR(0xcccccc)];
    [self.accountDescriptionLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.accountDescriptionLabel setText:accountDescription];


    [self.transactionsAmountLabel setFont:[UIFont boldSystemFontOfSize:15]];

    if ([transactionsAmount floatValue] < 0) {

        [self.transactionsAmountLabel setTextColor:OPAQUE_HEXCOLOR(0xF24E62)];

    } else {

        [self.transactionsAmountLabel setTextColor:OPAQUE_HEXCOLOR(0x7ED321)];
    }

    [self.transactionsAmountLabel setText:[NSString stringWithFormat:@"%@", transactionsAmount]];

}

@end
