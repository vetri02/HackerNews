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
#import "WebViewController.h"


@interface CommentsTableViewController ()<CommentUrlDelegate>

@property (nonatomic, strong) NSMutableArray *temporaryCommentsIds;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, strong) NSArray *sortedCommentList;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger kidscount;
@property (nonatomic, strong) NSMutableArray *selectedComments;

@end

@implementation CommentsTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.commentList = [[NSMutableArray alloc] init];
    self.count = 0;
    self.kidscount = 0;
    self.selectedComments = [[NSMutableArray alloc] init];
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
    
//    UINib *commentCellSmallNib = [UINib nibWithNibName:@"CommentTableViewCellSmall" bundle:nil] ;
//    [self.tableView registerNib:commentCellNib forCellReuseIdentifier:@"commentsCellSmall"];
    
    for(NSNumber *itemNumber in self.temporaryCommentsIds){
        [self getStoryDataOfItem:itemNumber parentComment:nil];
    }
}

- (void)getStoryDataOfItem:(NSNumber *)itemNumber parentComment:(NSDictionary *)parentComment  {
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [storyDescriptionRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(snapshot.value && snapshot.value != [NSNull null] && ![snapshot.value  isEqual: @""] && ![snapshot.value valueForKey:@"deleted"]){
            NSMutableDictionary *comment = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
            if (parentComment) {
                NSInteger parentLevel = [[parentComment objectForKey:@"level"] integerValue];
                NSInteger level = parentLevel + 1;
                [comment setObject:@(level) forKey:@"level"];
                NSInteger index = [self.commentList indexOfObject:parentComment];
                [self.commentList insertObject:comment atIndex:index+1];
            } else {
                [comment setObject:@(1) forKey:@"level"];
                [self.commentList addObject:comment];
            }
            
            NSLog(@"%@", snapshot.value);
            
//            [self.tableView beginUpdates];
//            [self.commentList addObject:snapshot.value];
//            NSInteger row = self.temporaryCommentsIds.count - 1;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
        }
        if (parentComment) {
            self.kidscount++;
            NSArray *kidsArr = [parentComment objectForKey:@"kids"];
            if(self.kidscount == kidsArr.count){
                [self.tableView reloadData];
                self.kidscount = 0;
            }
        } else {
            self.count++;
            if (self.count == self.temporaryCommentsIds.count) {
                                NSLog(@"%@", self.commentList);
                NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:FALSE];
                NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
                
                self.sortedCommentList = [self.commentList sortedArrayUsingDescriptors:sortDescriptors];
                
                self.commentList = [NSMutableArray arrayWithArray:self.sortedCommentList];
                //NSLog(@"%@", sortedSocialPosts);
                [self.tableView reloadData];
            }
        }
        
    } withCancelBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]){
        return 3;
    } else {
        return 2;
    }
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
        cell.urlDelegate = self;
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CommentTableViewCell class]]) {
        CommentTableViewCell *commentCell = (CommentTableViewCell *)cell;
        //NSLog(@"%@", commentCell.comment);
        // downloadKidForComment:comment
        [self downloadKidsForComment:commentCell.comment];
        [self.selectedComments addObject:commentCell.comment];
    }
    
    
}

- (void)downloadKidsForComment:(NSDictionary *)comment {
    
    NSLog(@"%@", comment);
    
    NSArray *kidsArr = [comment objectForKey:@"kids"];
    for(NSNumber *itemNumber in kidsArr){
        [self getStoryDataOfItem:itemNumber parentComment:comment];
    }
    
    // show loader
    // donwload kids
    // callback:
    // insert kid comment after parent
    // set level value to kid comment
    // hide loader
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfCommentsSection = 1;
    if(indexPath.section == 1 && [self.story valueForKey:@"text"] && [self.story valueForKey:@"text"] != [NSNull null] && ![[self.story valueForKey:@"text"]  isEqual: @""]) {
        indexOfCommentsSection = 2;
    }
    if (indexPath.section == indexOfCommentsSection) {
        NSDictionary *comment = [self.commentList objectAtIndex:indexPath.row];
        if ([self.selectedComments containsObject:comment]) {
            return nil;
        }
    }
    return indexPath;
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

- (void)openUrl:(NSURL *)url {
    NSDictionary *story = @{@"url" : url.absoluteString, @"title" : url.absoluteString};
//    WebViewController *webBrowser = [[WebViewController alloc] init];
//    webBrowser.story = story;
//    [self.navigationController pushViewController:webBrowser animated:YES];
    
    [self performSegueWithIdentifier:@"commentsToWeb" sender:story];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"commentsToWeb"])
    {
        //if you need to pass data to the next controller do it here
        WebViewController *controller = segue.destinationViewController;
        controller.story = sender;
    } 
}

@end
