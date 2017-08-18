//
//  UIImage+Category.m
//  SMShareView
//
//  Created by Siman on 2017/8/15.
//  Copyright © 2017年 Siman. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+(UIImage *)createImageWithColor:(UIColor *) color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
