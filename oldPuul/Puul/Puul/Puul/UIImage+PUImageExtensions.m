//
//  UIImage+PUImageExtensions.m
//  Puul
//
//  Created by David Ho on 3/25/15.
//  Copyright (c) 2015 David Ho. All rights reserved.
//

#import "UIImage+PUImageExtensions.h"

@implementation UIImage (PUImageExtensions)

+ (UIImage*)backgroundImageForButton:(UIButton *)button{
    
    UIFont *font = button.titleLabel.font;
    NSString *text = button.titleLabel.text;
    CGSize size = button.frame.size;
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGColorRef c = (button.layer.borderColor != [UIColor blackColor].CGColor)?button.layer.borderColor : [UIColor whiteColor].CGColor;
    
    CGSize textSize = [text sizeWithAttributes:dic];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctz = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctz, c);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    CGContextAddPath(ctz, path.CGPath);
    CGContextFillPath(ctz);
    
    CGContextSetBlendMode(ctz, kCGBlendModeDestinationOut);
    CGPoint center = CGPointMake(size.width/2-textSize.width/2, size.height/2-textSize.height/2);
    [text drawAtPoint:center withAttributes:dic];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
