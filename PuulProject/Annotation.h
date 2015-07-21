//
//  Annotation.h
//  PuulProject
//
//  Created by David Ho on 7/20/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * subtitle;


@end
