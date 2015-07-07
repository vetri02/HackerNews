//
//  StoryTextViewCell.m
//  HackerNews
//
//  Created by Vetrichelvan on 07/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "StoryTextViewCell.h"

@implementation StoryTextViewCell


- (void)setStory:(NSDictionary *)story {
    if ([_story isEqualToDictionary:story]) {
        return;
    }
    _story = story;
    
    if([story valueForKey:@"deleted"]){
    } else if([[story valueForKey:@"text"]  isEqual: @""]){
    
    } else {
        self.textCell.text = [story valueForKey:@"text"];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.textCell.numberOfLines = 0;
        [self.textCell sizeToFit];
    }
}

+ (CGFloat)heightForStory:(NSDictionary *)story {
    NSString* text = [story valueForKey:@"text"];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:
                                             @{ NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    
    //its not possible to get the cell label width since this method is called before cellForRow so best we can do
    //is get the table width and subtract the default extra space on either side of the label.
    CGSize constraintSize = CGSizeMake(300 - 30, MAXFLOAT);
    
    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    //NSLog(@"Output is: \"%d\"", rect.size.height);
    
    //Add back in the extra padding above and below label on table cell.
    rect.size.height = rect.size.height;
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return rect.size.height;
}

@end
