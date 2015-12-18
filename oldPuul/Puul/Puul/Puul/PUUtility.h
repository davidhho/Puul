//
//  PUUtility.h
//  Puul
//
//  Created by David Ho on 3/25/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^PUUtilityBlock)(BOOL taken, NSError* error);

@interface PUUtility : NSObject

+ (BOOL)containsIllegalCharacters:(NSString *)string;

+ (BOOL)isValidHWEmail:(NSString *)checkString;

+ (void)usernameIsTaken:(NSString*)string withCompletionBlock:(PUUtilityBlock)block;

@end
