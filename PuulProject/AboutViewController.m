//
//  AboutViewController.m
//  PuulProject
//
//  Created by David Ho on 8/5/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "AboutViewController.h"
#import "UIColor+PUColors.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"About";
    
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 300, 300)];
    [aboutLabel setTextColor:[UIColor blackColor]];
    [aboutLabel setTextAlignment:NSTextAlignmentCenter];
    [aboutLabel setBackgroundColor:[UIColor clearColor]];
    [aboutLabel setText:@"App by David Ho"];
//     Policy summary
//     Personal Data collected for the following purposes and using the following services:
//     Contacting the User
//     Contact form
//     Personal Data: Address, Email address, First Name, Last Name and Phone number
//     Location-based interactions
//     Geolocation and Non-continuous geolocation
//     Personal Data: Geographic position"];
    
    
    //Policy summary,
    [self.view addSubview: aboutLabel];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
