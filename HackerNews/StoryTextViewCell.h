//
//  StoryTextViewCell.h
//  HackerNews
//
//  Created by Vetrichelvan on 07/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryTextViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *textCell;
@property (weak, nonatomic) IBOutlet UITextView *storyText;

@property (strong, nonatomic) NSDictionary *story;

+ (CGFloat)heightForStory:(NSDictionary *)story;

@end
