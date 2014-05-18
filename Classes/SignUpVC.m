//
//  MySignUpViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "SignUpVC.h"
#import <QuartzCore/QuartzCore.h>

@interface SignUpVC ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation SignUpVC

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.signUpView setBackgroundColor:OPAQUE_HEXCOLOR(0xdddddd)];
    [self.signUpView.usernameField setBackgroundColor:OPAQUE_HEXCOLOR(0x333333)];
    [self.signUpView.emailField setBackgroundColor:OPAQUE_HEXCOLOR(0x333333)];
    [self.signUpView.passwordField setBackgroundColor:OPAQUE_HEXCOLOR(0x333333)];
    [self.signUpView.signUpButton setTitle:@"Create Account" forState:UIControlStateNormal];

    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.signUpView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.signUpView.emailField setFrame:CGRectMake(35.0f, 195, 250.0f, 50.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(35.0f, 245.0f, 250.0f, 50.0f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 325, 250.0f, 40.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
