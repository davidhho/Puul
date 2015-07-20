//
//  ProfileViewController.m
//  PuulProject
//
//  Created by David Ho on 7/8/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIColor+PUColors.h"
#import "Parse/Parse.h"

@implementation ProfileViewController
@synthesize GiveRideButton, RequestRideButton, profile;
PFFile *imageFile;
-(void) viewDidLoad{
    self.view.backgroundColor = [UIColor puulRedColor];
    [super viewDidLoad];
    GiveRideButton.layer.borderColor = [UIColor whiteColor].CGColor;
    GiveRideButton.layer.borderWidth = 1.5f;
    
    
    RequestRideButton.layer.borderColor = [UIColor whiteColor].CGColor;
    RequestRideButton.layer.borderWidth = 1.5F;
    self.UsernameLabel.text = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.UsernameLabel.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(!error)
         {
             imageFile = [objects objectAtIndex:0][@"profilePic"];
             profile.image = [UIImage imageWithData:[imageFile getData]];
             self.profile.image = [UIImage imageWithData:[imageFile getData]];
         }
         else{
             
         }
             
     }];
    profile.layer.borderWidth = 2;
    profile.layer.cornerRadius = 32.5;
    profile.layer.masksToBounds = TRUE;
    profile.image = [UIImage imageWithData:[imageFile getData]];
    

}



- (IBAction)chooseImage:(id)sender {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenImage = info[UIImagePickerControllerOriginalImage];
    [self.profile setImage:self.chosenImage];
    NSData *profilePic = UIImagePNGRepresentation(profile.image);
    PFFile *profileFile = [PFFile fileWithData:profilePic];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.UsernameLabel.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     
     {
         if(!error)
         {
             [objects objectAtIndex:0][@"profilePic"] = profileFile;
             imageFile = [objects objectAtIndex:0][@"profilePic"];
             profile.image = [UIImage imageWithData:[imageFile getData]];
             self.profile.image = [UIImage imageWithData:[imageFile getData]];
            [[objects objectAtIndex:0] saveInBackground];
         }
         else{
             //:)
         }
         
     }];
    //    PFFile *data = [PFFile fileWithData:profilePic];
//    [data saveInBackground];
//    [data getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            profile.image = [UIImage imageWithData:data];
//        }
//    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
