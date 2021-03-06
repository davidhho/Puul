//
//  FeedViewController.h
//  PuulProject
//
//  Created by David Ho on 7/9/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FeedViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate> {
    
    CLLocationCoordinate2D currentCenter;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *options;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet MKMapView *requestMap;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
