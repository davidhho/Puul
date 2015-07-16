
//
//  GiveRideViewController.m
//  PuulProject
//
//  Created by David Ho on 7/13/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "GiveRideViewController.h"
#import "UIColor+PUColors.h"
#import "Parse/Parse.h"

@interface GiveRideViewController ()


@end

@implementation GiveRideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor puulRedColor];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(400, 708)];
    // Do any additional setup after loading the view.
    _driveButton.layer.cornerRadius = 4.0f;
    _driveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _driveButton.layer.borderWidth = 1.0f;
    _driveButton.clipsToBounds = YES;

    

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
//Sends information about the Drive to Parse
- (IBAction)drive:(id)sender {
    [self checkFieldsComplete];
    NSString *startCityString = _startCity.text;
    NSString *stopsString = _stops.text;
    NSString *startAddressString = _startAddress.text;
    NSString *endCityString = _endCity.text;
    NSString *endAddressString = _endAddress.text;
    NSString *requestedPayString = _requestedPay.text;
    
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"stops"] = stopsString;
    newRide[@"startCity"] = startCityString;
    newRide[@"endAddress"] = endAddressString;
    newRide[@"pay"] = requestedPayString;
    newRide[@"endCity"] = endCityString;
    
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded == YES){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ride" message:@"Your Drive has been Posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            NSLog(@"Drive Post Success");
            
            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            
            UIViewController *loginvc=[mainstoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self presentViewController:loginvc animated:NO completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Your Drive wasn't Posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
    
}

//Makes keyboard disappear when clicked away

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)backButton:(id)sender {

        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Makes sure fields are complete
- (void) checkFieldsComplete{
    if ([_startAddress.text isEqualToString:@""] || [_startCity.text isEqualToString:@""] || [_endAddress.text isEqualToString:@""] || [_requestedPay.text isEqualToString:@""] || [_endCity.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"You did not complete all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
