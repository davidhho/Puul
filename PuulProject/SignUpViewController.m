//
//  SignUpViewController.m
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIColor+PUColors.h"
#import "Parse/Parse.h"

@implementation SignUpViewController

UITableView *sTableView;


-(IBAction)registerUser:(id)sender{
    [_usernameField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reenterPasswordField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [self checkFieldsComplete];
    if (![_passwordField.text isEqualToString:_reenterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops" message:@"Your passwords did not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self registerNewUser];
    }

}
-(void) viewDidLoad{
    self.title = @"Sign Up";
    self.view.backgroundColor = [UIColor puulRedColor];

}

- (void) checkFieldsComplete{
    if ([_usernameField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""]| [_passwordField.text isEqualToString:@""] || [_reenterPasswordField.text isEqualToString:@""] || [_phoneField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops" message:@"You did not fill all the fields " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch{
    if (![_passwordField.text isEqualToString:_reenterPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops" message:@"Your passwords did not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
    }
}

-(void) viewDidAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if (user.username !=nil){
        [self performSegueWithIdentifier:@"login" sender: self];
    }
}


- (void)  registerNewUser{
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
 
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error){
            NSLog(@"Registration Complete");
            //[self performSegueWithIdentifier:@"login" sender:self];
            
            
           // UIWindow *mywindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            //self.window=mywindow;
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *loginvc=[mainstoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            //CATransition* transition = [CATransition animation];
            //transition.duration = 0.2;
            //transition.type = kCATransitionFade;
            //[self.view.window.layer addAnimation:transition forKey:kCATransition];
            [self presentViewController:loginvc animated:NO completion:nil];
            
            }
        else{
            NSLog(@"Registration Unsucccessful");
        }
    }];
    
}

@end