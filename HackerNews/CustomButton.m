//
//  CustomButton.m
//  HackerNews
//
//  Created by Vetrichelvan on 27/09/14.
//  Copyright (c) 2014 Vetrichelvan. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1.0];
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, self.bounds);
    
}


@end
