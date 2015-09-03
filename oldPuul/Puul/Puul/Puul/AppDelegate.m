//
//  AppDelegate.m
//  Pool
//
//  Created by David Ho on 3/16/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "PURoute.h"
#import "PUStartViewController.h"
#import "UIColor+PUColors.h"
#import "PUSettingsViewController.h"
#import "PUProfileViewController.h"
#import "PUHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PURoute registerSubclass];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([PFUser currentUser]) {
        [self setUpForCurrentUser];
    }
    else{
        [self setUpForNewUser];
    }
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UITabBar appearance] setTintColor:[UIColor puulRedColor]];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setNewRootViewController:(UIViewController*)newViewController{
    self.window.rootViewController = newViewController;
}

- (void)setUpForCurrentUser{
    PUHomeViewController *home = [[PUHomeViewController alloc]init];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:home];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    controller.navigationBar.barTintColor = [UIColor puulRedColor];
    controller.navigationBar.translucent = NO;
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"feed"] tag:0];
    
    PUSettingsViewController *settings = [[PUSettingsViewController alloc]init];
    UINavigationController *controller1 = [[UINavigationController alloc]initWithRootViewController:settings];
    controller1.navigationBar.tintColor = [UIColor whiteColor];
    controller1.navigationBar.barTintColor = [UIColor puulRedColor];
    controller1.navigationBar.translucent = NO;
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"settings"] tag:0];
    
    PUProfileViewController *profile = [[PUProfileViewController alloc]init];
    UINavigationController *controller2 = [[UINavigationController alloc]initWithRootViewController:profile];
    controller2.navigationBar.tintColor = [UIColor whiteColor];
    controller2.navigationBar.barTintColor = [UIColor puulRedColor];
    controller2.navigationBar.translucent = NO;
    controller2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile"] tag:0];
    
    UITabBarController *tab = [[UITabBarController alloc]init];
    [tab setViewControllers:@[controller, controller2, controller1]];

    self.window.rootViewController = tab;
}

- (void)setUpForNewUser{
    PUStartViewController *p = [[PUStartViewController alloc]init];
    UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:p];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    controller.navigationBar.barTintColor = [UIColor puulRedColor];
    controller.navigationBar.translucent = NO;
    self.window.rootViewController = controller;
}

@end
