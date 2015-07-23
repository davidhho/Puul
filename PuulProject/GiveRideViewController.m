 
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

#define HW_LONGITUDE (-118.412835)
#define HW_LATITUDE (34.139545)
#define THE_SPAN (0.01f)


@implementation GiveRideViewController
@synthesize giveRideMap, locationManager, startAddress, endAddress, label, endAddressString, startAddressString;
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
    endAddress.delegate = self;

    startAddress.returnKeyType = UIReturnKeyGo;
    endAddress.returnKeyType = UIReturnKeyGo;
    

}
-(void) youAtSchool{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:HW_LATITUDE longitude:HW_LONGITUDE];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:self.giveRideMap.userLocation.coordinate.latitude longitude:self.giveRideMap.userLocation.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc2 completionHandler:^(NSArray *placemarks, NSError *error){
        if (error == nil && [placemarks count] > 0){
            placemark = [placemarks lastObject];
        }
        else
        {
            
        }
    }];
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
        label.text = @"You are giving a ride from your current location to school";
        endAddressString = @"Harvard Westlake High School";
        startAddressString = [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare, placemark.thoroughfare];
        _pay.hidden = false;
        _giveARide.hidden = false;
    }
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
        [self.giveRideMap addAnnotation:annotation];
        
        MKMapRect mr = [self.giveRideMap visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y - mr.size.height * 0.6;
        [self.giveRideMap setVisibleMapRect:mr animated:YES];
        endAddressString = endAddress.text;
        
        
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
        MKAnnotationView *annotationView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:@"home153.png"];
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
        [self youAtSchool];
    }
    
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
}

-(void)viewWillAppear:(BOOL)animated{
    //    self.requestedViewController.hidden = YES;
    _pay.hidden = true;
    _giveARide.hidden = true;
    startAddress.hidden = TRUE;

    
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
- (IBAction)giveARideButton:(id)sender {
    PFObject *newRide = [PFObject objectWithClassName:@"Ride"];
    newRide[@"startAddress"] = startAddressString;
    newRide[@"endAddress"] = endAddressString;
    if ([_pay.text isEqualToString:@""]){
        _parsePay = @"Free";
    }
    else{
        _parsePay = _pay.text;
    }
    newRide[@"pay"] = _parsePay;
    
    
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
        _pay.hidden = false;
        _giveARide.hidden = false;
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
