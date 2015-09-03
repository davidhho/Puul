//
//  PRoute.h
//  Pool
//
//  Created by David Ho on 3/16/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

/** This is the class that will handle all of the routing that gets stored up in the database
 */

typedef void (^routeCompletion)(NSArray *routes, NSError *error);

@interface PURoute : PFObject <PFSubclassing>

/** An PFGeoPoint object which represents the final destination of the route
 */
@property (retain) PFGeoPoint *finalLocation;

/** An PFGeoPoint object which represents the initial location of the route
 */
@property (retain) PFGeoPoint *initialLocation;

/** A date object that represents the time of departure
 */
@property (retain) NSDate *departureTime;

/** A number that represents the price of the ride
 
 @info Set by the user during route creation
 @abstract Can only be a value of 0 - 10
 */

@property (retain) NSNumber *price;

/** Quick access method to get the string of the date
 
 Here just for helping with UI elements
 Uses NSDateFormatter to accomplish this
 
 returns date in the form of "12:23 AM"
 returns nil if no departureTime is available
 */
- (NSString*)stringFromDepartureTime;

/** A class method that serves as a quick way to create a Route
 
 @param initialLocation - The initial location represented as a PFGeoPoint
 @param finalLocation - The final location represented as a PFGeoPoint
 @param date - The time at which this route will be starting
 @info Both these parameters will be passed in while the initial location
 will be found and set automatically using location services

 */
+ (PURoute*)routeFromLocation:(PFGeoPoint*)initialLocation toLocation:(PFGeoPoint*)finalLocation withDepartureTime:(NSDate*)date withPrice:(NSNumber*)price;

/** Method that will return all of the possible routes that can be taken
 
 Uses MKDirections to calculate all of the routes
 @abstract Uses a completion block to pass forward the array of map routes
 because the calculations will run in teh background asynchronously
 */
- (void)mapRoutesWithCompletionHandler:(routeCompletion)completion;

@end
