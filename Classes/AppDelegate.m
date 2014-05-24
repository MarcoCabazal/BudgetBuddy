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

    [Parse setApplicationId:@"e4URsEi918Rc7lT12pD4ZtiQHH8uPYCDeekxw8uq"
                  clientKey:@"TGvD04hODwV3QXNJPWO1ngRwRq4N4s7nB71rSNV6"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    AccountsVC *mainVC = [[AccountsVC alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];


    self.tabController = [[UITabBarController alloc] init];
    [self.tabController setViewControllers:@[mainNav]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabController;
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
