//
//  AppDelegate.h
//  Pool
//
//  Created by David Ho on 3/16/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setNewRootViewController:(UIViewController*)newViewController;

@end

