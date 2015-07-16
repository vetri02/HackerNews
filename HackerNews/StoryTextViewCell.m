//
//  StoryTextViewCell.m
//  HackerNews
//
//  Created by Vetrichelvan on 07/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "StoryTextViewCell.h"
#import "Utils.h"

@implementation StoryTextViewCell


- (void)setStory:(NSDictionary *)story {
    if ([_story isEqualToDictionary:story]) {
        return;
    }
    _story = story;
    
    if([story valueForKey:@"deleted"]){
    } else if([[story valueForKey:@"text"]  isEqual: @""]){
    
    } else {
        NSAttributedString *attributedString= [Utils convertHTMLToAttributedString:[story valueForKey:@"text"]];
        
        self.storyText.attributedText = attributedString;
        //self.textCell.text = [story valueForKey:@"text"];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        //self.storyText.numberOfLines = 0;
        [self.storyText sizeToFit];
    }
}

+ (CGFloat)heightForStory:(NSDictionary *)story {
    NSString* text = [story valueForKey:@"text"];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:
                                             @{ NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    
    //its not possible to get the cell label width since this method is called before cellForRow so best we can do
    //is get the table width and subtract the default extra space on either side of the label.
    const CGFloat leadingSpace = 44;
    const CGFloat trailingSpace = 10;
    CGSize constraintSize = CGSizeMake(320 - leadingSpace - trailingSpace, MAXFLOAT);
    
    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    
    //Add back in the extra padding above and below label on table cell.
    const CGFloat topSpaceToSuperView = 37;
    const CGFloat bottomSpaceToSuperView = 50;
    rect.size.height = rect.size.height + topSpaceToSuperView + bottomSpaceToSuperView;
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return rect.size.height;

}

@end
