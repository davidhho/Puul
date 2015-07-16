//
//  LoginViewController.h
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) UIWindow *window;


@property (weak, nonatomic) IBOutlet UILabel *Puul;
@property (weak, nonatomic) IBOutlet UIButton *Register;
@property (weak, nonatomic) IBOutlet UIButton *Login;

- (IBAction)backgroundTap:(id)sender;



- (IBAction)LoginButton:(id)sender;

@end
