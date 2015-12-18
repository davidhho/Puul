//
//  PUUtility.m
//  Puul
//
//  Created by David Ho on 3/25/15.
//  Copyright (c) 2015 David Ho and David Ho. All rights reserved.
//

#import "PUUtility.h"


@implementation PUUtility

+ (BOOL)containsIllegalCharacters:(NSString *)string{
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return NO;    }
    return YES;
}

//check valid email
+ (BOOL)isValidHWEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion 
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL illegalCharacters = [emailTest evaluateWithObject:checkString];
    
    BOOL hwemail = [checkString containsString:@"@hwemail.com"];
    
    return illegalCharacters && hwemail;
}


@end
