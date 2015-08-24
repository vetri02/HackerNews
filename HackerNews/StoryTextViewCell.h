//
//  StoryTextViewCell.h
//  HackerNews
//
//  Created by Vetrichelvan on 07/07/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextUrlDelegate;


@interface StoryTextViewCell : UITableViewCell<UITextViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *textCell;
@property (weak, nonatomic) IBOutlet UITextView *storyText;

@property (strong, nonatomic) NSDictionary *story;
@property (weak, nonatomic) id<TextUrlDelegate> textUrlDelegate;

+ (CGFloat)heightForStory:(NSDictionary *)story;

@end

@protocol TextUrlDelegate <NSObject>

- (void)openUrl:(NSURL *)urlString;

@end