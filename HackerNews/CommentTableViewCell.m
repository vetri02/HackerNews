//
//  CommentTableViewCell.m
//  HackerNews
//
//  Created by Vetrichelvan on 18/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "NSDate+TimeAgo.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(NSDictionary *)comment {
    if ([_comment isEqualToDictionary:comment]) {
        return;
    }
    _comment = comment;
    
    NSTimeInterval timeSince = [[comment valueForKey:@"time"] doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970: timeSince];
    NSString *ago = [date timeAgo];
    self.timeLabel.text = ago;
    self.userLabel.text = [comment valueForKey:@"by"];
    self.commentLabel.text = [comment valueForKey:@"text"];
}

@end
