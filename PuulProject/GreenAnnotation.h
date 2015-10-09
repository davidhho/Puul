//
//  GreenAnnotation.h
//  PuulProject
//
//  Created by David Ho on 8/4/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DownPicker.h"


@interface GreenAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * begAddress;
@property(nonatomic, copy) NSString * endAddress;
@property(nonatomic, copy) NSString * pay;
@property(nonatomic, copy) NSString * subtitle;



@end
