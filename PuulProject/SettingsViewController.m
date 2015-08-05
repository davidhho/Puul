
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

@end
