//
//  CommentsTableViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 15/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "CommentsTableViewController.h"
#import <Firebase/Firebase.h>
#import "StoryTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "CommentTableViewCell.h"


@interface CommentsTableViewController ()

@property (nonatomic, strong) NSMutableArray *temporaryCommentsIds;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, assign) NSInteger count;

@end

@implementation CommentsTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.commentList = [[NSMutableArray alloc] init];
    self.count = 0;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.story);
    
    self.title = @"Comments";
    
    self.temporaryCommentsIds = [self.story valueForKey:@"kids"];

    
    UINib *celllNib = [UINib nibWithNibName:@"StoryTableCellView" bundle:nil] ;
    [self.tableView registerNib:celllNib forCellReuseIdentifier:@"storyCell"];
    
    UINib *commentCellNib = [UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] ;
    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"commentsCell"];
    
    for(NSNumber *itemNumber in self.temporaryCommentsIds){
        [self getStoryDataOfItem:itemNumber];
    }
}

- (void)getStoryDataOfItem:(NSNumber *)itemNumber {
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [storyDescriptionRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value != [NSNull null]){
            [self.commentList addObject:snapshot.value];
        }
        self.count++;
        if (self.count == self.temporaryCommentsIds.count) {
            [self.tableView reloadData];
        }
        
    } withCancelBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"StoryTableCellView" owner:self options:nil];
            cell = [storyObject firstObject];
        }
        
        // Get data from the array at position of the row
        cell.story = self.story;
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return cell;
    } else  {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentsCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"CommentTableCellView" owner:self options:nil];
            cell = [storyObject firstObject];
        }
        cell.comment = [self.commentList objectAtIndex:indexPath.row];
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *story = self.story;
    NSString* text = [story valueForKey:@"title"];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:
                                             @{ NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    //its not possible to get the cell label width since this method is called before cellForRow so best we can do
    //is get the table width and subtract the default extra space on either side of the label.
    CGSize constraintSize = CGSizeMake(300 - 30, MAXFLOAT);
    
    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    //NSLog(@"Output is: \"%d\"", rect.size.height);
    
    //Add back in the extra padding above and below label on table cell.
    rect.size.height = rect.size.height + 70;
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return rect.size.height;
}

@end
