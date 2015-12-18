//
//  global.m
//  PuulProject
//
//  Created by David Ho on 7/27/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "global.h"
#define kGotLocationNotification @"kGotLocationNotification"

@implementation global


+ (global*) sharedInstance {
    static global *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id) init {
    if ((self = [super init])) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        _locationManager.delegate = self;
        
        [_locationManager startUpdatingLocation];
        
    }
    return self;
}


- (void) reset {
    _currentLocation = nil;
    [_locationManager startUpdatingLocation];
}

- (NSString *)deviceLocation
{
    
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
    return theLocation;
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.count == 0) return;

    _currentLocation = locations[0];
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];

            _address = [NSString stringWithFormat:@"%@ %@",placemark.subThoroughfare, placemark.thoroughfare];

            
            // Stop Location Manager
            
        }
    }];
    [_locationManager stopUpdatingLocation];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGotLocationNotification object:self];
}

@end
