//
//  FeedViewController.m
//  PuulProject
//
//  Created by David Ho on 7/9/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "global.h"
#import <SVProgressHUD.h>

#define HW_LONGITUDE -118.412835;
#define HW_LATITUDE 34.139545;
#define THE_SPAN 0.01f;



@implementation FeedViewController
@synthesize requestMap, locationManager;
CLLocation *currentLocation;
bool firstLoad;
- (void)viewDidLoad {
    [super viewDidLoad];
    _options.backgroundColor = [UIColor whiteColor];
    firstLoad = true;
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
    [self.requestMap addAnnotation:myAnnotation];
    [[global sharedInstance].locationManager requestAlwaysAuthorization];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"kGotLocationNotification" object:nil];
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
    requestMap.showsUserLocation = YES;
    
}
-(void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
}

-(void)viewWillAppear:(BOOL)animated{
//    self.requestedViewController.hidden = YES;

    [super viewWillAppear:animated];
}

-(void)didLogin{
    
    //instantiate next view controller
    
    LoginViewController *logger = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    
    
    //create a navController with your next view as its root
    
    UINavigationController *logWork = [[UINavigationController alloc] initWithRootViewController:logger];
    
    
    
    //present the Navigation Controller, not the next view you want; it will present its root view, which should be the correct view.
    
    [self presentViewController:logWork animated:NO completion:nil];


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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (firstLoad == true)
    {
      
    [self.requestMap setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
        firstLoad =false;
    }
    
}

- (void) retrieveFromParse {
    
    
}

- (IBAction)changeRides:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: {
            PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
            [query whereKey:@"giver" equalTo:[NSNumber numberWithBool:YES]];;
            

        } break;
        case 1:{
            PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
            [query whereKey:@"giver" equalTo:[NSNumber numberWithBool:false]];;
        }break;
            
            
        default:
            break;
    }
    [ FeedViewController getLocation];
}
//
//
//if (annotationView == nil)
//{
//    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//}
//else
//{
//    annotationView.annotation = annotation;
//}
//annotationView.tintColor = MKPinAnnotationColorRed;
//annotationView.enabled = true;
//annotationView.canShowCallout = true;
//annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//return annotationView;
//}

@end
