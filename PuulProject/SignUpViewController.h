//
//  SignUpViewController.h
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reenterPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UILabel *Puul;
@property (weak, nonatomic) IBOutlet UIButton *Register;
@property (weak, nonatomic) IBOutlet UIButton *Login;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;



- (IBAction)registerUser:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end
