//
//  MasterViewController.h
//  Piggy
//
//  Created by Marco Cabazal on 4/20/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountVC.h"
#import "SWTableViewCell.h"

@interface AccountsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, AccountDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, SWTableViewCellDelegate>

@end

