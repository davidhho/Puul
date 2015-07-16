
//
//  RequestViewController.m
//  PuulProject
//
//  Created by David Ho on 7/13/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "RequestViewController.h"
#import "UIColor+PUColors.h"
#import "Parse/Parse.h"

@interface RequestViewController ()

@end
@implementation RequestViewController
@synthesize findmeARideButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor puulRedColor];
    findmeARideButton.layer.cornerRadius = 4.0f;
    findmeARideButton.layer.borderColor = [UIColor whiteColor].CGColor;
    findmeARideButton.layer.borderWidth = 1.0f;
    findmeARideButton.clipsToBounds =YES;
   
    
}

//Makes sure all fields are completed before

- (void) checkFieldsComplete{
    if ([_startAddress.text isEqualToString:@""] || [_pickUpTime.text isEqualToString:@""]|| [_startCity.text isEqualToString:@""] || [_endAddress.text isEqualToString:@""] || [_pay.text isEqualToString:@""] || [_endCity.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"You did not complete all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
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


- (IBAction)findMeARide:(id)sender {
        [self checkFieldsComplete];
    NSString *startAddressString = _startAddress.text;
    NSString *pickUpTimeString = _pickUpTime.text;
    NSString *startCityString = _startCity.text;
    NSString *endAddressString = _endAddress.text;
    NSString *payString = _pay.text;
    NSString *endCityString = _endCity.text;
    
//Sends information of ride to Parse
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"pickUpTime"] = pickUpTimeString;
    newRide[@"startCity"] = startCityString;
    newRide[@"endAddress"] = endAddressString;
    newRide[@"pay"] = payString;
    newRide[@"endCity"] = endCityString;
    newRide[@"driver"] = NO;
    
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded == YES){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ride" message:@"Your Ride has been Requested" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            NSLog(@"Ride Request Success");

            UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            
            UIViewController *loginvc=[mainstoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                        [self presentViewController:loginvc animated:NO completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Your Ride wasn't Requested" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];

}

- (IBAction)backButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Makes keyboard disappear when clicked away
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
