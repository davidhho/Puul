//
//  GiveRideViewController.h
//  PuulProject
//
//  Created by David Ho on 7/13/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiveRideViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UIScrollView *scroller;
}
@property (weak, nonatomic) IBOutlet UITextField *startCity;
@property (weak, nonatomic) IBOutlet UITextField *startAddress;
@property (weak, nonatomic) IBOutlet UITextField *stops;
@property (weak, nonatomic) IBOutlet UITextField *endCity;
@property (weak, nonatomic) IBOutlet UITextField *endAddress;
@property (weak, nonatomic) IBOutlet UITextField *requestedPay;
@property (weak, nonatomic) IBOutlet UIButton *driveButton;

- (IBAction)drive:(id)sender;

- (IBAction)backgroundTap:(id)sender;

- (IBAction)backButton:(id)sender;

@end
