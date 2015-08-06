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
#import "Annotation.h"
#import "RideAnnotations.h"
#import "FeedViewController.h"
#import "global.h"
#import <SVProgressHUD.h>

#define HW_LONGITUDE (-118.412835)
#define HW_LATITUDE (34.139545)
#define THE_SPAN (0.01f)

@interface RequestViewController ()

@end
@implementation RequestViewController
@synthesize findmeARideButton, requestRideMap, locationManager, startAddress, label, endAddress, pay, endAddressString, startAddressString, time;
bool firstLoad;



- (void)viewDidLoad {
    
        firstLoad = true;
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
    [self.requestRideMap addAnnotation:myAnnotation];
    
        
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor puulRedColor];
    findmeARideButton.layer.cornerRadius = 4.0f;
    findmeARideButton.layer.borderColor = [UIColor whiteColor].CGColor;
    findmeARideButton.layer.borderWidth = 1.0f;
    findmeARideButton.clipsToBounds =YES;
   
    
    
    startAddress.delegate = self;
    endAddress.delegate = self;
    startAddress.returnKeyType = UIReturnKeyGo;
    endAddress.returnKeyType = UIReturnKeyGo;

    [global sharedInstance];
    
    
    if ([global sharedInstance].currentLocation == nil)
    {
        [SVProgressHUD show];
        [SVProgressHUD showWithStatus:@"Getting Current Location"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeSV) name:@"kGotLocationNotification" object:nil];
        
    }
}

-(void) removeSV{
    [SVProgressHUD dismiss];
}

-(void) findAddress{
    [self.endAddress resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSLog(@"Label: %@", self.endAddress.text);
    [geocoder geocodeAddressString:self.endAddress.text completionHandler:^(NSArray *placemarks, NSError *error){
      
        if (error) {
            NSLog(@"error! %@", error);
        }
        
        NSLog(@"location count: %d", (int)placemarks.count);
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"first location: %@", placemark);
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        RideAnnotations *annotation = [RideAnnotations alloc];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.endAddress.text];
        [self.requestRideMap addAnnotation:annotation];
        
        MKMapRect mr = [self.requestRideMap visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.6;
        [self.requestRideMap setVisibleMapRect:mr animated:YES];
        endAddressString = endAddress.text;
        currentLocationgeo =  [PFGeoPoint geoPointWithLocation: placemark.location];

        
    }];
}

-(void) youAtSchool{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:HW_LATITUDE longitude:HW_LONGITUDE];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[global sharedInstance].currentLocation.coordinate.latitude longitude:[global sharedInstance].currentLocation.coordinate.longitude];
    CLLocationDistance dist = [loc distanceFromLocation:loc2];
    
    NSLog(@"locations: %@ %@", loc, loc2);
    
    int distance = dist;
    if (distance < 835){
        label.numberOfLines = 2;
        NSLog(@"%lf", dist);
        label.text = @"You are at School. Please pick your End Address.";
        startAddressString = @"Harvard Westlake High School";
        
        
    }
    else{
        label.numberOfLines = 2;
        endAddress.hidden=true;
        startAddress.hidden=true;
        label.text = @"You are giving a ride from your current location to school";
        startAddressString = [global sharedInstance].address;
        endAddressString = @"Harvard Westlake High School";
        currentLocationgeo =  [PFGeoPoint geoPointWithLocation:[global sharedInstance].currentLocation];
        time.hidden = false;
        pay.hidden = false;
        findmeARideButton.hidden = false;
        
        
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewHWID = @"annotationViewHWID";
    static NSString *AnnotationViewID = @"annotationViewID";
    if ([annotation isKindOfClass:[Annotation class]])
    {
        MKAnnotationView *annotationViewHW = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewHWID];
        if (annotationViewHW == nil)
        {
            annotationViewHW = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        else
        {
            annotationViewHW.annotation = annotation;
        }
        annotationViewHW.image = [UIImage imageNamed:@"HW.png"];
        annotationViewHW.enabled = true;
        annotationViewHW.canShowCallout = true;
        return annotationViewHW;
    }
    else if ([annotation isKindOfClass:[RideAnnotations class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = true;
        annotationView.canShowCallout = true;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self.locationManager requestWhenInUseAuthorization];
    [super viewDidAppear:YES];
    requestRideMap.showsUserLocation = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    pay.hidden = true;
    time.hidden = true;
    findmeARideButton.hidden = true;
    startAddress.hidden = TRUE;
    [self youAtSchool];
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(49, -123);
    MKCoordinateRegion adjustedRegion = [requestRideMap regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [requestRideMap setRegion:adjustedRegion animated:YES];
    [super viewWillAppear:animated];


}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self.requestRideMap setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
}

//Makes sure all fields are completed before



- (void) checkFieldsComplete{
    if ([startAddress.text isEqualToString:@""] || [endAddress.text isEqualToString:@""]){
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
    
    //

    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"endAddress"] = endAddressString;
    newRide[@"location"] = currentLocationgeo;
    newRide[@"YourRides"] =
    newRide[@"Requestor"] = PFUser.currentUser;
    newRide[@"time"] = time.text;
    newRide[@"giver"] = [NSNumber numberWithBool:false];
    

    
    if ([pay.text isEqualToString:@""]){
        _parsePay = @"Free";
    }
    else{
        _parsePay = pay.text;
    }
    newRide[@"pay"] = _parsePay;

    [newRide pinInBackground];
    
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
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
        if (textField.returnKeyType == UIReturnKeyGo)
        {
            [self findAddress];
            time.hidden = false;
            pay.hidden = false;
            findmeARideButton.hidden = false;
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
