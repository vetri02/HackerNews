//
//  StoryTableViewCell.m
//  HackerNews
//
//  Created by Vetrichelvan on 19/05/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "StoryTableViewCell.h"
#import "NSDate+TimeAgo.h"


@implementation StoryTableViewCell

- (void)setStory:(NSDictionary *)story {
    if ([_story isEqualToDictionary:story]) {
        return;
    }
    _story = story;
    NSTimeInterval timeSince = [[story valueForKey:@"time"] doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970: timeSince];
    NSString *ago = [date timeAgo];
    //NSLog(@"Output is: \"%@\"", ago);
    
    //Get Comments count
    NSMutableArray *commentArray = [story valueForKey:@"kids"];
    NSUInteger commentCount = [commentArray count];
    NSString *commentCountText = [NSString stringWithFormat:@"%@",  @(commentCount)];
    //NSLog (@"Number of elements in array = %lu", [commentArray count]);
    
    //Get the HostName
    NSString *urlString = [story valueForKey:@"url"];
    NSURL* url = [NSURL URLWithString:[story valueForKey:@"url"]];
    NSString* reducedUrl = [NSString stringWithFormat:
                            @"%@",url.host];
    //NSLog(@"Output is: \"%@\"", reducedUrl);
    if([story valueForKey:@"deleted"]){
    } else {
        self.titleLabel.text = [story valueForKey:@"title"];
        self.authorWithTimeLabel.text = [NSString stringWithFormat:@"by %@, %@", [story valueForKey:@"by"], ago];
        self.commentLabel.text = [NSString stringWithFormat:@"%@", commentCountText];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"score"]];
        self.sourceLabel.text = urlString.length > 0 ? reducedUrl : @"";
        self.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [story valueForKeyPath:@"type"]]];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel sizeToFit];
    }
}

@end
