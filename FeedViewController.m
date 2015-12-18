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
#import "RideAnnotations.h"
#import "global.h"
#import <SVProgressHUD.h>
#import "GreenAnnotation.h"






#define HW_LONGITUDE -118.412835;
#define HW_LATITUDE 34.139545;
#define THE_SPAN 0.01f;



@implementation FeedViewController
@synthesize requestMap, locationManager;
CLLocation *currentLocation;
NSString *showInfo;
PFObject *profileUser;
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
    PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
    [query includeKey:@"Requestor"];
    [query whereKey:@"giver" equalTo:[NSNumber numberWithBool:YES]];;
    [query findObjectsInBackgroundWithBlock:^(NSArray *points, NSError *error)
     {
         if(!error)
         {
             [self plotPositionsRed:points];
        }

        else{
         }
         
    }];

    
}

-(void)plotPositionsRed: (NSArray *) points
{
    for (PFObject *point in points)
    {
        RideAnnotations *annotation = [[RideAnnotations alloc] init];
        PFObject *username = point[@"Requestor"];
        annotation.title = username[@"username"];
        annotation.begAddress = point[@"startAddress"];
        PFFile* pic = username[@"profilePic"];
        annotation.profilePic = [UIImage imageWithData:[pic getData]];
        if ([point[@"startAddress"] isEqualToString:@"Harvard Westlake High School"]){
            annotation.subtitle = point[@"endAddress"];
            annotation.showInfo = [NSString stringWithFormat:@" %@ \n %@ \n %@ \n %@ %@ \n %@   	%@",username[@"username"],point[@"endAddress"], point[@"time"], @"Cost:", point[@"pay"], @"Phone Number:", username[@"phone"]];
            profileUser = username[@"installation"];
        }
        else{
            annotation.subtitle = point[@"startAddress"];
            annotation.showInfo = [NSString stringWithFormat:@" %@ \n %@ \n %@ \n %@ %@ \n %@ %@",username[@"username"],point[@"startAddress"], point[@"time"], @"Cost:", point[@"pay"], @"Phone Number:", username[@"phone"]];
            profileUser = username[@"installation"];
        }
        
        PFGeoPoint *geoPoint = point[@"location"];
        annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        
        
        [self.requestMap addAnnotation:annotation];
    }
}



-(void) removeSV{
    [SVProgressHUD dismiss];
    //Removes SVProgressHUD when finished finding location
}

-(void)suggestPay{
    
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
    if ([annotation isKindOfClass:[RideAnnotations class]])
    {
        MKPinAnnotationView *pinView=(MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,50,50)];
        view.backgroundColor = [UIColor blueColor];
        
        RideAnnotations* anno = annotation;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:anno.profilePic];
        imgView.frame = CGRectMake(0,0,50,50);
        //[view addSubview:imgView];
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            //pinView.annotation = annotation;
        }
        pinView.annotation = annotation;
        pinView.leftCalloutAccessoryView = imgView;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        if ([anno.begAddress isEqualToString:@"Harvard Westlake High School"]){
            pinView.pinColor = MKPinAnnotationColorGreen;
        }
        return pinView;
    }
    return nil;
    
} 


-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    RideAnnotations* annotation = view.annotation;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Information" message:annotation.showInfo delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Accept Ride", nil];
    [alert show];
    [alert setDelegate:self];
}




-(void)viewDidAppear:(BOOL)animated{
    [self.locationManager requestWhenInUseAuthorization];
    [super viewDidAppear:YES];
    _label.numberOfLines = 2;
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
      
    [self.requestMap setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.2f, 0.2f)) animated:YES];
        firstLoad =false;
    }
    
}


- (IBAction)changeRides:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: {
            NSMutableArray * annotationsToRemove = [ requestMap.annotations mutableCopy ] ;
            [ annotationsToRemove removeObject:requestMap.userLocation ] ;
            [ requestMap removeAnnotations:annotationsToRemove ] ;
            
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
            PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
            [query includeKey:@"Requestor"];

            [query whereKey:@"giver" equalTo:[NSNumber numberWithBool:YES]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *points, NSError *error)
             {
                 if(!error)
                 {
                        [self plotPositionsRed:points];
                 }
                 else{
                     
                 }
                 
             }];
            

        } break;
        case 1:{
            NSMutableArray * annotationsToRemove = [ requestMap.annotations mutableCopy ] ;
            [ annotationsToRemove removeObject:requestMap.userLocation ] ;
            [ requestMap removeAnnotations:annotationsToRemove ] ;
            
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
            PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
            [query includeKey:@"Requestor"];

            [query whereKey:@"giver" equalTo:[NSNumber numberWithBool:false]];;
            [query findObjectsInBackgroundWithBlock:^(NSArray *points, NSError *error)
             {
                 if(!error)
                 {
                     [self plotPositionsRed:points];
                 }
                 else{
                     
                 }
                 
             }];
            
        }break;
            
            
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"objectId" equalTo: profileUser.objectId];
        
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        NSDictionary *data = @{
                               @"alert" : [NSString stringWithFormat:@"%@ %@", PFUser.currentUser[@"username"], @"has accepted your ride!"],
                               @"sound" : @"chime",
                               @"user" : PFUser.currentUser[@"username"],
                               @"phone" : PFUser.currentUser[@"phone"]
                               };
        [push setData:data];
        PFInstallation *installation = [PFInstallation currentInstallation];
        installation[@"user"] = [PFUser currentUser];
        [installation saveInBackground];
        [push sendPushInBackground];
        
    }
}
 //01001000 01101111

@end
