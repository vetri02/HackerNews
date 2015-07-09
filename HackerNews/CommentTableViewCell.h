//
//  CommentTableViewCell.h
//  HackerNews
//
//  Created by Vetrichelvan on 18/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
//@property (weak, nonatomic) IBOutlet UITextView *commentText;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (strong, nonatomic) NSDictionary *comment;

+ (CGFloat)heightForComment:(NSDictionary *)comment;

@end
