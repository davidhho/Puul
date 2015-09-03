//
//  PUStartViewController.m
//  Puul
//
//  Created by David Ho on 3/23/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "PUStartViewController.h"
#import "PUSignUpViewController.h"
#import "UIImage+PUImageExtensions.h"
#import "UIColor+PUColors.h"

@interface PUStartViewController (){
    UITableView *sTableView;
    UIButton *loginButton;
    UIButton *signUpButton;
    UILabel *titleLabel;
}

@end

@implementation PUStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    //allocating and initializing the title label
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 100)];
    titleLabel.font = [UIFont boldSystemFontOfSize:50];
    titleLabel.text = @"Puul";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    
    //allocating and initializing the sign up button, then adding it to the view
    signUpButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 110, self.view.bounds.size.width - 20, 45)];
    [signUpButton setTitle:@"Register with HW Email" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.layer.cornerRadius = 4.0f;
    signUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signUpButton.layer.borderWidth = 1.0f;
    signUpButton.clipsToBounds = YES;
    [signUpButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setImage:[UIImage backgroundImageForButton:signUpButton] forState:UIControlStateHighlighted];
    
    [self.view addSubview:signUpButton];
    
    //allocating and initializing the sign in button, then adding it to the view
    loginButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.bounds.size.height - 55, self.view.bounds.size.width - 20, 45)];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 4.0f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 1.0f;
    loginButton.clipsToBounds = YES;
    [loginButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage backgroundImageForButton:loginButton] forState:UIControlStateHighlighted];
    
    [self.view addSubview:loginButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - Button Methods

- (void)buttonPressed:(id)sender{
    if (sender == loginButton) {
        PULoginViewController *l = [[PULoginViewController alloc]init];
        [self.navigationController pushViewController:l animated:YES];
    }
    else{
        PUSignUpViewController *p = [[PUSignUpViewController alloc]init];
        [self.navigationController pushViewController:p animated:YES];
    }
}

@end
