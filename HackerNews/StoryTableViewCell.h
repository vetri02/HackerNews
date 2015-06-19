//
//  StoryTableViewCell.h
//  HackerNews
//
//  Created by Vetrichelvan on 19/05/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorWithTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (strong, nonatomic) NSDictionary *story;

+ (CGFloat)heightForStory:(NSDictionary *)story;

@end
