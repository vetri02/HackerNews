//
//  HomeTableViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 18/02/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "HomeTableViewController.h"
#import <Firebase/Firebase.h>
#import "StoryTableViewCell.h"
#import "MBProgressHUD.h"
#import "NSDate+TimeAgo.h"
#import <PureLayout/PureLayout.h>




@interface HomeTableViewController ()

@property NSMutableArray *temporaryTop500StoriesIds;
@property NSMutableArray *storyEventRefs;
@property NSMutableArray *dataArr;
@property NSMutableArray *heights;
@property (nonatomic, strong) StoryTableViewCell *prototypeCell;





@end

@implementation HomeTableViewController




#pragma mark - FireBase API

- (void)getTopStories {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://hacker-news.firebaseio.com/v0/"];
    //__block Firebase *itemRef = nil;
    Firebase *topStories = [ref childByAppendingPath:@"topstories"];
    //Firebase *firstStory = [topStories childByAppendingPath:@"0"];
    //__block NSMutableArray *listStories = [[NSMutableArray alloc] init];
    // Attach a block to read the data at our posts reference
    [topStories observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"%@", snapshot.value);
        self.dataArr = [snapshot.value mutableCopy];
        
        
        //NSLog (@"Number of elements in array = %d", [self.dataArr count]);
        
        
        

//        NSArray *tempArray = [self.dataArr subarrayWithRange:NSMakeRange(0, 10)];
//        
//        [self.temporaryTop100StoriesIds addObjectsFromArray:tempArray];
        

        
        self.temporaryTop500StoriesIds = [snapshot.value mutableCopy];
        
//        NSArray *uniques = Underscore.uniq(self.temporaryTop100StoriesIds);
//        
//        NSLog (@"Number of elements in array = %d", [uniques count]);
        
        
        [self getStoryDescriptionsUsingNewIDs:YES];
        //[listStories addObject:(snapshot.value)];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}

- (void)getStoryDescriptionsUsingNewIDs:(BOOL)usingNewIDs{
    
    if(usingNewIDs){
        for(NSNumber *itemNumber in self.temporaryTop500StoriesIds){
            [self getStoryDataOfItem:itemNumber usingNewIDs:usingNewIDs];
        }
    }
    else{
//        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastRefreshDate"];
//        
//        for(NSNumber *itemNumber in self.top100StoriesIds){
//            [self getStoryDataOfItem:itemNumber usingNewIDs:usingNewIDs];
//        }
    }
    
}

- (void)getStoryDataOfItem:(NSNumber *)itemNumber usingNewIDs:(BOOL)usingNewIDs{
    
    //[[Crashlytics sharedInstance] crash];
    
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    
    //NSLog(@"%@", itemNumber);
    
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [self.storyEventRefs addObject:storyDescriptionRef];
    //[storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    [storyDescriptionRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSDictionary *responseDictionary = snapshot.value;
        
        //NSLog(@"%@", snapshot.value);
        
        [self.storiesArray addObject:snapshot.value];
        
        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError *error) {
        
    }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize array that will store stories.
    self.storiesArray = [[NSMutableArray alloc] init];
    self.heights = [[NSMutableArray alloc] init];
    
    [self.navigationController setTitle:@"Live"];
    
    [self getTopStories];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.labelText = @"Fetching Stories";
    HUD.detailsLabelText = @"Fetching Stories";

    [self.view addSubview:HUD];
    [HUD show:YES];
    
    
    self.tableView.scrollsToTop = YES;
    
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   
    //NSLog(@"%@", snapshot.value);
    return [self.storiesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
//    static NSString *CellIdentifier = @"storyCell";
//    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell==nil) {
//        cell = [[StoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//    }
    
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    
    
    
    // Get data from the array at position of the row
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    
    //Get the Time interval from when the story is posted
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
    NSURL* url = [NSURL URLWithString:[story valueForKey:@"url"]];
    NSString* reducedUrl = [NSString stringWithFormat:
                            @"%@",url.host];
    NSLog(@"Output is: \"%@\"", reducedUrl);
    
    // Apply the data to each row
    cell.titleLabel.text = [story valueForKey:@"title"];
    cell.authorWithTimeLabel.text = [NSString stringWithFormat:@"by %@, %@", [story valueForKey:@"by"], ago];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@", commentCountText];
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"score"]];
    cell.sourceLabel.text = [NSString stringWithFormat:@"%@", reducedUrl];
    cell.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [story valueForKeyPath:@"type"]]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.titleLabel.numberOfLines = 0;
    [cell.titleLabel sizeToFit];
    
    [HUD hide:YES];
    
    
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    NSString* text = [story valueForKey:@"title"];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:
                                                                                               @{ NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
        //its not possible to get the cell label width since this method is called before cellForRow so best we can do
        //is get the table width and subtract the default extra space on either side of the label.
    CGSize constraintSize = CGSizeMake(300 - 30, MAXFLOAT);
    
    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
        //NSLog(@"Output is: \"%d\"", rect.size.height);
    
        //Add back in the extra padding above and below label on table cell.
        rect.size.height = rect.size.height + 23;
    
        //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return (rect.size.height < 44 ? 95 : 110);
    //return 95;
}


@end
