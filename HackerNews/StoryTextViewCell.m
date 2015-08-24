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
        
        self.storyText.delegate=self;
        self.storyText.selectable=YES;
        self.storyText.dataDetectorTypes = UIDataDetectorTypeLink;
        
        
        //self.storyText.numberOfLines = 0;
        [self.storyText sizeToFit];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if (self.textUrlDelegate) {
        [self.textUrlDelegate openUrl:URL];
    }
    return NO;
}

+ (CGFloat)heightForStory:(NSDictionary *)story {
    NSString* text = [story valueForKey:@"text"];
    NSAttributedString *attributedString= [Utils convertHTMLToAttributedString:text];
    
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:attributedString];
    
    //its not possible to get the cell label width since this method is called before cellForRow so best we can do
    //is get the table width and subtract the default extra space on either side of the label.
    const CGFloat leadingSpace = 44;
    const CGFloat trailingSpace = 10;
    CGSize constraintSize = [calculationView sizeThatFits:CGSizeMake(320 - leadingSpace - trailingSpace, FLT_MAX)];
    
    //CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    
    //Add back in the extra padding above and below label on table cell.
    //if(constraintSize.height < 100){
        const CGFloat topSpaceToSuperView = 40;
        const CGFloat bottomSpaceToSuperView = 55;
        constraintSize.height = constraintSize.height + topSpaceToSuperView + bottomSpaceToSuperView;
    //}
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return constraintSize.height;
    
    
   

}

@end
