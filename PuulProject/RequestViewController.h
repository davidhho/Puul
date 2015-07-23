//
//  RequestViewController.h
//  PuulProject
//
//  Created by David Ho on 7/13/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RequestViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocation *currentLocation;
    CLLocationCoordinate2D currentCenter;
    CLPlacemark *placemark;
}
@property (weak, nonatomic) IBOutlet UITextField *startAddress;

@property (weak, nonatomic) IBOutlet MKMapView *requestRideMap;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *endAddress;

@property (weak, nonatomic) IBOutlet CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITextField *pay;

@property (strong, nonatomic) NSString *endAddressString;

@property (strong, nonatomic) NSString *startAddressString;

@property (strong, nonatomic) NSString *parsePay;

@property (weak, nonatomic) IBOutlet UIButton *findmeARideButton;



- (IBAction)findMeARide:(id)sender;


- (IBAction)backgroundTap:(id)sender;

@end
