//
//  CommentTableViewCell.h
//  HackerNews
//
//  Created by Vetrichelvan on 18/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentUrlDelegate;

@interface CommentTableViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
//@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *childCommentCount;
@property (weak, nonatomic) IBOutlet UIImageView *childCommentBGImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLeadingSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeadingSpacing;

@property (strong, nonatomic) NSDictionary *comment;
@property (weak, nonatomic) id<CommentUrlDelegate> urlDelegate;

+ (CGFloat)heightForComment:(NSDictionary *)comment;

@end


@protocol CommentUrlDelegate <NSObject>

- (void)openUrl:(NSURL *)urlString;

@end