
//
//  LoginViewController.m
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+PUColors.h"
#import "Parse/Parse.h"

@implementation LoginViewController
@synthesize loginButton, loginPasswordField, loginUsernameField;



-(void) viewDidLoad{
    self.title = @"Login";
    self.view.backgroundColor = [UIColor puulRedColor];
//    loginButton.layer.backgroundColor = [UIColor grayColor];
    loginButton.layer.cornerRadius = 4.0f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 1.0f;
    loginButton.clipsToBounds = YES;
    loginUsernameField.returnKeyType = UIReturnKeyNext;
    loginPasswordField.returnKeyType = UIReturnKeyGo;
    loginPasswordField.delegate = self;
    loginUsernameField.delegate = self;
    
    
}



- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)LoginButton:(id)sender {
    [PFUser logInWithUsernameInBackground:loginUsernameField.text password:loginPasswordField.text block:^(PFUser *user, NSError *error){
        if (!error) {
//            [self performSegueWithIdentifier:@"login" sender:self];
//            
            //UIWindow *mywindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            //self.window=mywindow;
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *loginvc=[mainstoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            
            //CATransition* transition = [CATransition animation];
            //transition.duration = 0.2;
            //transition.type = kCATransitionFade;
            //[self.view.window.layer addAnimation:transition forKey:kCATransition];
            [self presentViewController:loginvc animated:NO completion:nil];
            
            
        }
        if (error){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        [sender resignFirstResponder];
        
    }];
    

    
}

-(void) viewDidAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    if (user.username !=nil){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *loginvc=[mainstoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self presentViewController:loginvc animated:NO completion:nil];
    }


}
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        [loginPasswordField becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyGo)
    {
    [self LoginButton:self];
    }
    return YES;
}
@end
