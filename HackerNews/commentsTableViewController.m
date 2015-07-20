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
#import "StoryTextViewCell.h"
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    self.navigationItem.hidesBackButton=YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,13.5,23);
    [button setBackgroundImage:[UIImage imageNamed:@"Safari Back White"] forState:UIControlStateNormal];
    
    //    [button setTitle:@"" forState:UIControlStateNormal];
    //    [button.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:16.0f]];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];

    
    
    self.temporaryCommentsIds = [self.story valueForKey:@"kids"];

    
    UINib *celllNib = [UINib nibWithNibName:@"StoryTableCellView" bundle:nil] ;
    [self.tableView registerNib:celllNib forCellReuseIdentifier:@"storyCell"];
    
    UINib *cellTextNib = [UINib nibWithNibName:@"StoryTextCellView" bundle:nil] ;
    [self.tableView registerNib:cellTextNib forCellReuseIdentifier:@"storyTextCell"];
    
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
        if(snapshot.value && snapshot.value != [NSNull null] && ![snapshot.value  isEqual: @""] && ![snapshot.value valueForKey:@"deleted"]){
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1 && [self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]){
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
        if ([self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]){
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        // Get data from the array at position of the row
        cell.story = self.story;
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        return cell;
    } else if (indexPath.section == 1 && [self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]){
       
            StoryTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyTextCell" forIndexPath:indexPath];
            
            if (cell == nil) {
                NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"StoryTextCellView" owner:self options:nil];
                cell = [storyObject firstObject];
            }
            
            // Get data from the array at position of the row
            cell.story = self.story;
        
        
            [cell layoutIfNeeded];
            [cell setNeedsLayout];
            
        return cell;
    } else {
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
    if (indexPath.section == 0) {
        NSDictionary *story = self.story;
        return [StoryTableViewCell heightForStory:story];
    } else if(indexPath.section == 1 && [self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]) {
        NSDictionary *story = self.story;
        return [StoryTextViewCell heightForStory:story];
    }
    NSDictionary *comment = [self.commentList objectAtIndex:indexPath.row];
    return [CommentTableViewCell heightForComment:comment];
}

@end
