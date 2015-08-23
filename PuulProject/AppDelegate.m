//
//  AppDelegate.m
//  Pool
//
//  Created by David Ho on 3/16/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "AppDelegate.h"

#import "PURoute.h"
#import "UIColor+PUColors.h"
#import "global.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PURoute registerSubclass];
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"ivGqdOBrW4N9wEy16QeOoYm4IXDKnPkfmsNKUwoZ"
                  clientKey:@"oL6VguODNoKrG1uyLxiWRgh0lMt2VjBxKJ7ZC9pr"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBar appearance] setTintColor:[UIColor puulRedColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor puulBarTint]];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotif)
    {

        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Ride Accepted"
                                                         message:[NSString stringWithFormat:@"%@ %@ \n %@ %@", [remoteNotif objectForKey:@"user"], @"has accepted your ride!", @"Phone:", [remoteNotif objectForKey:@"phone"]]
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles: nil];
        [alert show];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    if (PFUser.currentUser) {
        PFUser.currentUser[@"installation"] = currentInstallation;
        [PFUser.currentUser saveInBackground];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
        NSLog(@"dict is %@", userInfo);

        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Ride Accepted"
                                                         message:[NSString stringWithFormat:@"%@ %@ \n %@ %@", [userInfo objectForKey:@"user"], @"has accepted your ride!", @"Phone:", [userInfo objectForKey:@"phone"]]
                                                        delegate:self
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles: nil];
    
        [alert show];
    
            // app was just brought from background to foreground
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
    [[global sharedInstance] reset];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setNewRootViewController:(UIViewController*)newViewController{
    self.window.rootViewController = newViewController;
}
@end
