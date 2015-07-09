//
//  NSString+RemoveTag.m
//  HackerNews
//
//  Created by Vetrichelvan on 09/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "NSString+RemoveTag.h"

@implementation NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag{
    NSString *closingTag = [tag stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag{
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

@end
