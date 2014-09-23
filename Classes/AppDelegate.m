//
//  AppDelegate.m
//  Budget Buddy
//
//  Created by Marco Cabazal on 4/20/14.
//  Copyright (c) 2014 The Chill Mill. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountsVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [TestFlight takeOff:@"17976e7c-9163-40c8-8ee8-a2fac2b05a33"];
    [Parse setApplicationId:@"e4URsEi918Rc7lT12pD4ZtiQHH8uPYCDeekxw8uq"
                  clientKey:@"TGvD04hODwV3QXNJPWO1ngRwRq4N4s7nB71rSNV6"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    AccountsVC *mainVC = [[AccountsVC alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [[UINavigationBar appearance] setBarTintColor:OPAQUE_HEXCOLOR(0x444444)];
    [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]}];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
