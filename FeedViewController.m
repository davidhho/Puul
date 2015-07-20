//
//  FeedViewController.m
//  PuulProject
//
//  Created by David Ho on 7/9/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FeedViewController
@synthesize givenRidesTableView, requestedViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{

    
    [super viewDidAppear:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.requestedViewController.hidden = YES;

    [super viewWillAppear:YES];
}

-(void)didLogin{
    
    //instantiate next view controller
    
    LoginViewController *logger = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    
    
    //create a navController with your next view as its root
    
    UINavigationController *logWork = [[UINavigationController alloc] initWithRootViewController:logger];
    
    
    
    //present the Navigation Controller, not the next view you want; it will present its root view, which should be the correct view.
    
    [self presentViewController:logWork animated:NO completion:nil];


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

- (void) retrieveFromParse {
    
    
}

- (IBAction)changeRides:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.givenRidesTableView.hidden = NO;
            self.requestedViewController.hidden = YES;
            break;
            
        case 1:
            self.givenRidesTableView.hidden = YES;
            self.requestedViewController.hidden = NO;
            break;
            
        default:
            break;
    }
    
}
@end
