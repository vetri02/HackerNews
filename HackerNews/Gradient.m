//
//  Gradient.m
//  HackerNews
//
//  Created by Vetrichelvan on 27/09/14.
//  Copyright (c) 2014 Vetrichelvan. All rights reserved.
//

#import "Gradient.h"

@implementation Gradient

+ (CAGradientLayer*) orangeGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(240/255.0) green:(101/255.0) blue:(47/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(228/255.0)  green:(95/255.0)  blue:(44/255.0)  alpha:1.0];
    UIColor *colorThree = [UIColor colorWithRed:(215/255.0)  green:(89/255.0)  blue:(40/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
