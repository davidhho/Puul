//
//  PRoute.m
//  Puul
//
//  Created by David Ho on 3/16/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "PURoute.h"
#import <MapKit/MapKit.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PURoute

@dynamic initialLocation, finalLocation, departureTime, price;

+ (NSString*)parseClassName{
    return @"PURoute";
}

- (NSString*)stringFromDepartureTime{
    //sanity check
    if (!self.departureTime) {
        return nil;
    }
    
    //use apples date formatter to easilty convert from date to string
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"hh:mm a";
    NSString *s = [formatter stringFromDate:self.departureTime];
    
    /*Check to make sure that time wont show as "05:30 AM"
     Will take out first 0 if it is there and return "5:30 AM"
     */
    if ([s characterAtIndex:0] == '0') {
        s = [s substringFromIndex:1];
    }
    
    return s;
}

+ (PURoute*)routeFromLocation:(PFGeoPoint*)initialLocation toLocation:(PFGeoPoint*)finalLocation withDepartureTime:(NSDate*)date withPrice:(NSNumber*)price
{
    //create the route object using the parameters given
    PURoute *route = [PURoute object];
    route.finalLocation = finalLocation;
    route.departureTime = date;
    route.initialLocation = initialLocation;
    route.price = price;
        
    return route;
}

- (void)mapRoutesWithCompletionHandler:(routeCompletion)completion{
    
    //the actual request object
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    
    //coverting to get the inital location
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.initialLocation.latitude, self.initialLocation.longitude) addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc]initWithPlacemark:placemark];
    [request setSource:item];
    
    //converting to get the final location
    MKPlacemark *placemark1 = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(self.finalLocation.latitude, self.finalLocation.longitude) addressDictionary:nil];
    MKMapItem *item1 = [[MKMapItem alloc]initWithPlacemark:placemark1];
    [request setDestination:item1];
    
    //setting the departure time
    [request setDepartureDate:self.departureTime];
    
    //All things set, lets get the directions
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    
    //run this code on a separate thread in the background so the app doesn't have to wait for it to finish
    dispatch_async(kBgQueue, ^{
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            completion(response.routes, error);
        }];
    });
}

@end
