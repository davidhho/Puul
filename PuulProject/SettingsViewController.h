//
//  SettingsViewController.h
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)logoutButton:(id)sender;

@end
