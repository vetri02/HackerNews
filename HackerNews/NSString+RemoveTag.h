//
//  NSString+RemoveTag.h
//  HackerNews
//
//  Created by Vetrichelvan on 09/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag;
- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag;

@end
