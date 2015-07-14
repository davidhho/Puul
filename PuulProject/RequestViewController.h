//
//  RequestViewController.h
//  PuulProject
//
//  Created by David Ho on 7/13/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *startAddress;
@property (weak, nonatomic) IBOutlet UITextField *pickUpTime;


@property (weak, nonatomic) IBOutlet UITextField *endAddress;
@property (weak, nonatomic) IBOutlet UITextField *pay;

@property (weak, nonatomic) IBOutlet UIButton *findmeARideButton;

- (IBAction)findMeARide:(id)sender;

@end
