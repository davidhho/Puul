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
@synthesize registerButton;

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

- (IBAction)backgroundTap:(id)sender {

    [self.view endEditing:YES];
}
-(void) viewDidLoad{
    self.title = @"Sign Up";
    self.view.backgroundColor = [UIColor puulRedColor];
    registerButton.layer.cornerRadius = 4.0f;
    registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    registerButton.layer.borderWidth = 1.0f;
    registerButton.clipsToBounds = YES;
    
    
    _usernameField.returnKeyType = UIReturnKeyNext;
    _emailField.returnKeyType = UIReturnKeyNext;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _reenterPasswordField.returnKeyType = UIReturnKeyNext;
    _phoneField.returnKeyType = UIReturnKeyGo;
    

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
    registerButton.layer.cornerRadius = 4.0f;
    registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    registerButton.layer.borderWidth = 1.0f;
    registerButton.clipsToBounds = YES;
    _usernameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
    _reenterPasswordField.delegate = self;
    _phoneField.delegate = self;
    
}


- (void)  registerNewUser{
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.email = _emailField.text;
    newUser.password = _passwordField.text;
    newUser[@"phone"] = _phoneField.text;

    
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
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(textField.returnKeyType == UIReturnKeyNext)
    {
        if (textField == _usernameField)
        {
            [_emailField becomeFirstResponder];
        }
        if (textField == _emailField){
            [_passwordField becomeFirstResponder];
        }
        if (textField == _passwordField){
            [_reenterPasswordField becomeFirstResponder];
        }
        if (textField == _reenterPasswordField){
            [_phoneField becomeFirstResponder];
        }
    }
    if(textField.returnKeyType == UIReturnKeyGo)
    {
        [self registerUser: self];
    }
    
    return YES;
}

@end