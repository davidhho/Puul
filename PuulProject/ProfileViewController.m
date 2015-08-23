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
#import "CustomCell.h"

@interface ProfileViewController (){

}

@end

@implementation ProfileViewController
@synthesize GiveRideButton, RequestRideButton, profile, tableView;
PFFile *imageFile;
NSMutableArray *myRides;
-(void) viewDidLoad{
    self.view.backgroundColor = [UIColor puulRedColor];
    [super viewDidLoad];
    GiveRideButton.layer.borderColor = [UIColor whiteColor].CGColor;
    GiveRideButton.layer.borderWidth = 1.5f;
    
    myRides = [[NSMutableArray alloc] init];
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
    

    [self findMyRides];

}

- (void)findMyRides
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
    [query fromLocalDatastore];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     
     {
         if(!error)
         {
             myRides = [NSMutableArray arrayWithArray:objects];
             [self.tableView reloadData];
         }
         else{
             //:)
         }
         
     }];
    //    PFFile *data = [PFFile fileWithDa

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





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myRides count];

}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFObject *ride = [myRides objectAtIndex:indexPath.row];
    cell.startAddressLabel.text = ride[@"startAddress"];
    cell.endAddressLabel.text = ride[@"endAddress"];
    cell.pay.text = ride[@"pay"];
    cell.HeadLabel.text = [NSString stringWithFormat:@"Ride %d", indexPath.row+1 ];
    return cell;
    
    
//    cell.startAddressLabel.text = [startAddressArray objectAtIndex:indexPath.row];
//    cell.endAddressLabel.text = [endAddressArray objectAtIndex:indexPath.row];
//    cell.pay.text = [payArray objectAtIndex:indexPath.row];
//    cell.HeadLabel.text = [headArray objectAtIndex:indexPath.row];
//    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        PFObject *ride = [myRides objectAtIndex:indexPath.row];
        [myRides removeObjectAtIndex:indexPath.row];
        [ride unpinInBackground];
        //Deletes pin from the correct map
        [ride deleteInBackground];
        //Deletes the cell in the tableView
        [self.tableView reloadData]; // tell table to refresh now
    
        
        
    }
}



@end
