//
//  Utils.h
//  HackerNews
//
//  Created by Vetrichelvan on 09/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+ (NSString *)timeAgoFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)makeThisPieceOfHTMLBeautiful: (NSString *)htmlString withFont:(NSString *)fontName ofSize:(int)size;
+ (NSAttributedString *)convertHTMLToAttributedString:(NSString *)string;

@end
