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
#import "WebViewController.h"




@interface HomeTableViewController ()

@property (nonatomic, strong) NSMutableArray *temporaryTop500StoriesIds;
@property (nonatomic, strong) NSMutableArray *storyEventRefs;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *heights;
@property (nonatomic, assign) NSInteger counter;
@property (nonatomic, strong) StoryTableViewCell *prototypeCell;
- (IBAction)refresh:(UIRefreshControl *)sender;



@end


@implementation HomeTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.datasourceName = @"topstories";
    self.loadMsg = @"Fetching Top Stories";
    self.navTitle = @"Top Stories";
    return self;
}


#pragma mark - FireBase API

- (void)getTopStories {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://hacker-news.firebaseio.com/v0/"];
    //__block Firebase *itemRef = nil;
    Firebase *topStories = [ref childByAppendingPath:self.datasourceName];
    //Firebase *firstStory = [topStories childByAppendingPath:@"0"];
    //__block NSMutableArray *listStories = [[NSMutableArray alloc] init];
    // Attach a block to read the data at our posts reference
    self.counter = 0;
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
    
    //    NSLog(@"%@", itemNumber);
    
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [self.storyEventRefs addObject:storyDescriptionRef];
    //[storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    [storyDescriptionRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSDictionary *responseDictionary = snapshot.value;
        
        //        NSLog(@"%@", snapshot.value);
        if(snapshot.value != [NSNull null]){
            [self.tableView beginUpdates];
            [self.storiesArray addObject:snapshot.value];
            NSInteger row = self.storiesArray.count - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            //            [self.tableView reloadData];
        }
        
        self.counter++;
        HUD.progress = (float)self.counter / self.temporaryTop500StoriesIds.count;
        if (self.counter == self.temporaryTop500StoriesIds.count) {
            [HUD hide:YES];
        }
        
        
    } withCancelBlock:^(NSError *error) {
        
    }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize array that will store stories.
    self.storiesArray = [[NSMutableArray alloc] init];
    self.heights = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.topItem.title = self.navTitle;
    
    
    
    UINib *celllNib = [UINib nibWithNibName:@"StoryTableCellView" bundle:nil] ;
    [self.tableView registerNib:celllNib forCellReuseIdentifier:@"storyCell"];
    
    [self getTopStories];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.labelText = @"Fetching Stories";
    HUD.detailsLabelText = self.loadMsg;
    HUD.mode = MBProgressHUDModeDeterminate;
    
    //    [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    
    //self.title = @"Top Stories";
    
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    
    
    self.tableView.scrollsToTop = YES;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [self.refreshControl setTintColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] /*#cccccc*/];
    //[self.refreshControl setAttributedTitle:string];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = self.navTitle;
    self.title = self.navTitle;
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
    
    
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    
    if (cell==nil) {
        
        NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"StoryTableCellView" owner:self options:nil];
        
        cell = [storyObject firstObject];
    }
    
    
    
    
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
    NSString *urlString = [story valueForKey:@"url"];
    NSURL* url = [NSURL URLWithString:[story valueForKey:@"url"]];
    NSString* reducedUrl = [NSString stringWithFormat:
                            @"%@",url.host];
    //NSLog(@"Output is: \"%@\"", reducedUrl);
    if([story valueForKey:@"deleted"]){
    } else {
        
        
        // Apply the data to each row
        cell.titleLabel.text = [story valueForKey:@"title"];
        cell.authorWithTimeLabel.text = [NSString stringWithFormat:@"by %@, %@", [story valueForKey:@"by"], ago];
        cell.commentLabel.text = [NSString stringWithFormat:@"%@", commentCountText];
        cell.scoreLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"score"]];
        cell.sourceLabel.text = urlString.length > 0 ? reducedUrl : @"";
        cell.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [story valueForKeyPath:@"type"]]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.titleLabel.numberOfLines = 0;
        [cell.titleLabel sizeToFit];
        
    }
    //[HUD hide:YES];
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    //NSLog(@"Output is: \"%@\"", cell.titleLabel);
    
    return cell;
}


//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
//    NSString* text = [story valueForKey:@"title"];
//    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:
//                                                                                               @{ NSFontAttributeName: [UIFont systemFontOfSize:16]}];
//
//        //its not possible to get the cell label width since this method is called before cellForRow so best we can do
//        //is get the table width and subtract the default extra space on either side of the label.
//    CGSize constraintSize = CGSizeMake(300 - 30, MAXFLOAT);
//
//    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
//
//        //NSLog(@"Output is: \"%d\"", rect.size.height);
//
//        //Add back in the extra padding above and below label on table cell.
//        rect.size.height = rect.size.height + 23;
//
//        //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
//
//    return (rect.size.height < 44 ? 95 : 115);
//    //return 95;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    //NSString *fullURL = [story valueForKey:@"url"];
    //if(indexPath.row == 0) {
    [self performSegueWithIdentifier:@"topStoriestoWebView" sender:story];
    //}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"topStoriestoWebView"])
    {
        //if you need to pass data to the next controller do it here
        WebViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }
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
    rect.size.height = rect.size.height + 70;
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    
    return rect.size.height;
    //return 95;
}


- (IBAction)refresh:(UIRefreshControl *)sender {
    
    
    
    [self.storiesArray removeAllObjects];
    [self.tableView reloadData];
    
    
    
    [self viewDidLoad];
    
    
    [sender endRefreshing];
}
@end