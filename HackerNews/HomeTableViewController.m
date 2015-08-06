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
#import "CommentsTableViewController.h"
#import "Reachability.h"





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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hacker News" message:@"Error Fetching Stories." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
        
        float progress = (float)self.counter / self.temporaryTop500StoriesIds.count;
        
        if(progress > 0.1){
            HUD.progress = progress;
        }
        if (self.counter == (self.temporaryTop500StoriesIds.count-3)) {
            [HUD hide:YES];
        }
        
        
    } withCancelBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hacker News" message:@"Error Fetching Stories." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
    
//    //// Color Declarations
//    UIColor* color3 = [UIColor colorWithRed: 0.471 green: 0.471 blue: 0.471 alpha: 1];
//    
//    //// Oval Drawing
//    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(75, 19, 30, 30)];
//    [color3 setFill];
//    [ovalPath fill];
//    
//    
//    //// Oval 2 Drawing
//    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(84, 20, 12, 12)];
//    [UIColor.whiteColor setFill];
//    [oval2Path fill];
    
    NSURL *scriptUrl = [NSURL URLWithString:@"http://apps.wegenerlabs.com/hi.html"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        NSLog(@"Device is connected to the internet");
    }else{
        NSLog(@"Device is not connected to the internet");
    }
    

    
    if(HUD!=nil)
    {
        [HUD hide:YES];
        [HUD removeFromSuperViewOnHide];
        HUD = nil;
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.labelText = @"Fetching Stories";
    HUD.detailsLabelText = self.loadMsg;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.progress = 0.1;
    
    //    [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    
    //self.title = @"Top Stories";
    
    [HUD hide:YES];
    
    [self.view addSubview:HUD];

    [HUD show:YES];
    
    
    
    self.tableView.scrollsToTop = YES;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [self.refreshControl setTintColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] /*#cccccc*/];
    //[self.refreshControl setAttributedTitle:string];
    
    

    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"REACHABLE!");
//        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        if (!reach.isReachable) {

            NSLog(@"UNREACHABLE!");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hacker News" message:@"No internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
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
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"StoryTableCellView" owner:self options:nil];
        cell = [storyObject firstObject];
    }
    
    // Get data from the array at position of the row
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    cell.story = story;
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    NSString *urlString = [story valueForKey:@"url"];
    if(urlString.length > 0) {
        [self performSegueWithIdentifier:@"topStoriestoWebView" sender:story];
    } else {
        [self performSegueWithIdentifier:@"topStoriesToComments" sender:story];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"topStoriestoWebView"])
    {
        //if you need to pass data to the next controller do it here
        WebViewController *controller = segue.destinationViewController;
        controller.story = sender;
    } else if([[segue identifier] isEqualToString:@"topStoriesToComments"]) {
        CommentsTableViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    return [StoryTableViewCell heightForStory:story];
}


- (IBAction)refresh:(UIRefreshControl *)sender {
    
    
    
    [self.storiesArray removeAllObjects];
    [self.tableView reloadData];
    
    
    
    [self viewDidLoad];
    
    
    [sender endRefreshing];
}
@end