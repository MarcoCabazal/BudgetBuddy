//
//  MyLogInViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "LoginVC.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginVC ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation LoginVC

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.logInView setBackgroundColor:OPAQUE_HEXCOLOR(0xdddddd)];
    [self.logInView.usernameField setBackgroundColor:OPAQUE_HEXCOLOR(0x333333)];
    [self.logInView.passwordField setBackgroundColor:OPAQUE_HEXCOLOR(0x333333)];
    [self.logInView.signUpButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [self.logInView.signUpLabel setText:@""];
    [self.logInView.usernameField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 115.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 165.0f, 250.0f, 50.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(35.0f, 235, 250.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 295, 250.0f, 40.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
