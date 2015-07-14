
//
//  SettingsViewController.m
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIColor+PUColors.h"

@implementation SettingsViewController

-(void) viewDidLoad{

}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
