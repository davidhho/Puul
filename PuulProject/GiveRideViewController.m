
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
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"

#define HW_LONGITUDE -118.412835;
#define HW_LATITUDE 34.139545;
#define THE_SPAN 0.01f;


@implementation GiveRideViewController
@synthesize giveRideMap, locationManager, startAddress, endAddress;
bool firstLoad;


- (void)viewDidLoad {
    firstLoad =true;
    [super viewDidLoad];
    
    //Create Region
    MKCoordinateRegion myRegion;
    
    //Center
    CLLocationCoordinate2D center;
    center.latitude = HW_LATITUDE;
    center.longitude = HW_LONGITUDE;
    
    //Span
    MKCoordinateSpan span;
    span.latitudeDelta = THE_SPAN;
    span.longitudeDelta = THE_SPAN;
    
    myRegion.center = center;
    myRegion.span = span;
    
    //Annotation stuff
    CLLocationCoordinate2D hwLocation;
    hwLocation.longitude = HW_LONGITUDE;
    hwLocation.latitude = HW_LATITUDE;
    
    Annotation * myAnnotation = [Annotation alloc];
    myAnnotation.coordinate = hwLocation;
    myAnnotation.title = @"Harvard Westlake";
    myAnnotation.subtitle = @"3700 Coldwater Canyon, Studio City";
    [self.giveRideMap addAnnotation:myAnnotation];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0){
        NSLog(@" %d", [CLLocationManager locationServicesEnabled]);
        NSLog(@" ZOOP! %d", [CLLocationManager authorizationStatus]);
        [self.locationManager requestAlwaysAuthorization];
    }
        [self.locationManager startUpdatingLocation];

    
    


    // Do any additional setup after loading the view.
    _driveButton.layer.cornerRadius = 4.0f;
    _driveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _driveButton.layer.borderWidth = 1.0f;
    _driveButton.clipsToBounds = YES;

    startAddress.returnKeyType = UIReturnKeyGo;
    endAddress.returnKeyType = UIReturnKeyGo;
    

}

-(void) findAddress{
    [self.startAddress resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.startAddress.text completionHandler:^(NSArray *placemarks, NSError *error){
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.startAddress.text];
        [self.giveRideMap addAnnotation:annotation];
        
        MKMapRect mr = [self.giveRideMap visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.25;
        [self.giveRideMap setVisibleMapRect:mr animated:YES];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    if ([annotation isKindOfClass:[Annotation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:@"HW.png"];
        annotationView.enabled = true;
        annotationView.canShowCallout = true;
        return annotationView;
    }
    return nil;
    
}

- (void)locationManager:(CLLocationManager * )manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"CHANGED STATUS: %d", status);
}

-(void)viewDidAppear:(BOOL)animated{
    [self.locationManager requestWhenInUseAuthorization];
    [super viewDidAppear:YES];
    giveRideMap.showsUserLocation = YES;
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (firstLoad == true)
    {
        
        [self.giveRideMap setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
        firstLoad =false;
    }
    
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
}

-(void)viewWillAppear:(BOOL)animated{
    //    self.requestedViewController.hidden = YES;
    
    [super viewWillAppear:YES];
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
    NSString *startAddressString = startAddress.text;
    NSString *endAddressString = endAddress.text;

    
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"endAddress"] = endAddressString;

    
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
    if ([startAddress.text isEqualToString:@"hw"] || [startAddress.text isEqualToString:@"Hw"] || [startAddress.text isEqualToString:@"HW"] || [endAddress.text isEqualToString:@"hw"] ||[endAddress.text isEqualToString:@"Hw"] || [endAddress.text isEqualToString:@"HW"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"One of the Address's must be 'HW'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.returnKeyType == UIReturnKeyGo)
    {
        [self findAddress];
    }
    return YES;
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get Location");
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
}



@end
