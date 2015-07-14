//
//  ProfileViewController.h
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *GiveRideButton;
@property (weak, nonatomic) IBOutlet UIButton *RequestRideButton;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (strong, nonatomic) UIImageView *chosenImage;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
- (void) setProfilePic;
@end
