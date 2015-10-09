 
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
#import "RideAnnotations.h"
#import "FeedViewController.h"
#import "global.h"
#import <SVProgressHUD.h>

#define HW_LONGITUDE (-118.412835)
#define HW_LATITUDE (34.139545)
#define THE_SPAN (0.01f)


@implementation GiveRideViewController
@synthesize giveRideMap, locationManager, startAddress, endAddress, label, endAddressString, startAddressString, time, numbRiders;
bool firstLoad;

-(void)viewWillAppear:(BOOL)animated{
    //    self.requestedViewController.hidden = YES;
    time.hidden = true;
    _pay.hidden = true;
    _giveARide.hidden = true;
    startAddress.hidden = TRUE;
    [self youAtSchool];
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(49, -123);
    MKCoordinateRegion adjustedRegion = [giveRideMap regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [giveRideMap setRegion:adjustedRegion animated:YES];
    [super viewWillAppear:animated];
    
}

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
    
    [global sharedInstance];
    
    
    if ([global sharedInstance].currentLocation == nil)
    {
        [SVProgressHUD show];
        [SVProgressHUD showWithStatus:@"Getting Current Location"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeSV) name:@"kGotLocationNotification" object:nil];
        
    }
    
    


    // Do any additional setup after loading the view.
    _driveButton.layer.cornerRadius = 4.0f;
    _driveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _driveButton.layer.borderWidth = 1.0f;
    _driveButton.clipsToBounds = YES;
    endAddress.delegate = self;

    startAddress.returnKeyType = UIReturnKeyGo;
    endAddress.returnKeyType = UIReturnKeyGo;
    numbRiders.returnKeyType = UIReturnKeyGo;
}

-(void) removeSV{
    [SVProgressHUD dismiss];
}
-(void) youAtSchool{

    CLLocation *loc = [[CLLocation alloc] initWithLatitude:HW_LATITUDE longitude:HW_LONGITUDE];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[global sharedInstance].currentLocation.coordinate.latitude longitude:[global sharedInstance].currentLocation.coordinate.longitude];
    CLLocationDistance dist = [loc distanceFromLocation:loc2];
    
    
    int distance = dist;
    if (distance < 835){
        label.numberOfLines = 2;
        label.text = @"You are at School. Please pick your End Address.";
                startAddressString = @"Harvard Westlake High School";
        
    }
    else{
        label.numberOfLines = 2;
        endAddress.hidden=true;
        label.text = @"You are giving a ride from your current location to school";
        endAddressString = @"Harvard Westlake High School";
        startAddressString = [global sharedInstance].address;
        currentLocationgeo =  [PFGeoPoint geoPointWithLocation:[global sharedInstance].currentLocation];
        time.hidden = false;
        _pay.hidden = false;
        _giveARide.hidden = false;
        
        

    }
}
-(void) findAddress{
    [self.endAddress resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.endAddress.text completionHandler:^(NSArray *placemarks, NSError *error){
        
        if (error) {
        }
        
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        RideAnnotations *annotation = [RideAnnotations alloc];
        [annotation setCoordinate:newLocation];
        [annotation setTitle:self.endAddress.text];
        [self.giveRideMap addAnnotation:annotation];
        
        MKMapRect mr = [self.giveRideMap visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.6;
        [self.giveRideMap setVisibleMapRect:mr animated:YES];
        endAddressString = endAddress.text;
        currentLocationgeo =  [PFGeoPoint geoPointWithLocation: placemark.location];
        
    }];
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
        annotationView.tintColor = MKPinAnnotationColorRed;
        annotationView.enabled = true;
        annotationView.canShowCallout = true;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
    
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)locationManager:(CLLocationManager * )manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
}

-(void)viewDidAppear:(BOOL)animated{
    [self.locationManager requestWhenInUseAuthorization];
    [super viewDidAppear:YES];
    giveRideMap.showsUserLocation = YES;
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (firstLoad == true)
    {
        
        [self.giveRideMap setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.2f, 0.2f)) animated:YES];
        firstLoad =false;
        //[self youAtSchool];
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
//Sends information about the Drive to Parse


- (IBAction)giveARideButton:(id)sender {
    
    [self checkFieldsComplete];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:HW_LATITUDE longitude:HW_LONGITUDE];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[global sharedInstance].currentLocation.coordinate.latitude longitude:[global sharedInstance].currentLocation.coordinate.longitude];
    CLLocationDistance dist = [loc distanceFromLocation:loc2];
    
    int distance = dist;
    if (distance < 835){
        startAddressString = @"Harvard Westlake High School";
    }
    
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"endAddress"] = endAddressString;
    newRide[@"location"] = currentLocationgeo;
    newRide[@"time"] = time.text;
    newRide[@"Requestor"] = PFUser.currentUser;
    newRide[@"giver"] = [NSNumber numberWithBool:true];
    NSNumber *riders = [NSNumber numberWithFloat:[numbRiders.text floatValue]];
    newRide[@"NumberOfRiders"] = riders;
    

    if ([_pay.text isEqualToString:@""]){
        _parsePay = @"Free";
    }
    else{
        _parsePay = _pay.text;
    }
    newRide[@"pay"] = _parsePay;
    
    [newRide pinInBackground];
    
    [newRide saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded == YES){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ride" message:@"Your Ride has been Requested" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];

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



//Makes keyboard disappear when clicked away

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)backButton:(id)sender {

        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//Makes sure fields are complete
- (void) checkFieldsComplete{
    if ([time.text isEqualToString:@"" ]|| [numbRiders.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please enter a Time of Departure" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
//    if (_pay.text > 25){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"The Maximum payment is $25" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.returnKeyType == UIReturnKeyGo)
    {
        [self findAddress];
        time.hidden = false;
        _pay.hidden = false;
        _giveARide.hidden = false;
    }
    return YES;
}

#pragma mark CLLocationManagerDelegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
}



@end
