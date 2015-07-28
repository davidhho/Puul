//
//  global.h
//  PuulProject
//
//  Created by David Ho on 7/27/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface global : NSObject <CLLocationManagerDelegate>

+ (global*) sharedInstance;


@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic, readonly) NSString *address;

- (void) reset;
- (NSString *)deviceLocation;


@end
