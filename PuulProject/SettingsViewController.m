
//
//  SettingsViewController.m
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIColor+PUColors.h"
#import "AboutViewController.h"
#import "TermsViewController.h"
#import "LicensesViewController.h"
#import "NameViewController.h"
#import "PhoneViewController.h"
#import "PasswordViewController.h"
#import "EmailViewController.h"
#import "LoginViewController.h"


@implementation SettingsViewController

-(void) viewDidLoad{
    
    self.title = @"Settings";

}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 3;
    }
    else if (section == 1){
        return 4;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Main Cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0){
        cell.textLabel.text = @"About";
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        cell.textLabel.text = @"Terms of Use";
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        cell.textLabel.text = @"Licenses";
    }
    else if (indexPath.section==1 && indexPath.row == 0){
        cell.textLabel.text = @"Name";
    }
    else if (indexPath.section ==1 && indexPath.row == 1){
        cell.textLabel.text = @"Phone Number";
    }
    else if (indexPath.section ==1 && indexPath.row == 2){
        cell.textLabel.text = @"Password";
    }
    else if (indexPath.section ==1 && indexPath.row == 3){
        cell.textLabel.text = @"Email";
    }
    else{
        cell.textLabel.text = @"Log Out";
        }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"About";
        
    }
    else if (section == 1){
        return @"My Account";
    }
    else{
        return @"Account Actions";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0 && indexPath.row == 1){
        UIViewController *terms  = [[TermsViewController alloc] init];
        [self.navigationController pushViewController:terms animated:YES];
        }
    else if (indexPath.section == 0 && indexPath.row == 0){
        UIViewController *about = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        UIViewController *license = [[LicensesViewController alloc]init];
        [self.navigationController pushViewController:license animated:YES];
    }
    
    else if (indexPath.section == 1 && indexPath.row == 0){
        UIViewController *about = [[NameViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        UIViewController *about = [[PhoneViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    
    else if (indexPath.section == 1 && indexPath.row == 2){
        UIViewController *about = [[PasswordViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.section ==1 && indexPath.row == 3){
        UIViewController *about = [[EmailViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    
    else{
        [PFUser logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
