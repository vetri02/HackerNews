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
    
    // Transform HTML into an attributed string
//    NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithFileURL:[comment valueForKey:@"text"] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    
//    self.commentLabel.attributedText = stringWithHTMLAttributes;
    
    self.commentLabel.text = [comment valueForKey:@"text"];
}

+ (CGFloat)heightForComment:(NSDictionary *)comment {
    NSString* text = [comment valueForKey:@"text"];
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
