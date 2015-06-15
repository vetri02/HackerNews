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
@property (nonatomic, strong) StoryTableViewCell *prototypeCell;

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
    Firebase *topStories = [ref childByAppendingPath:self.datasourceName];

    // Attach a block to read the data at our posts reference
    [topStories observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSLog(@"%@", snapshot.value);
        
        self.temporaryTop500StoriesIds = [snapshot.value mutableCopy];
        
        [self getStoryDescriptionsUsingNewIDs:YES];
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
    }
    
}

- (void)getStoryDataOfItem:(NSNumber *)itemNumber usingNewIDs:(BOOL)usingNewIDs{
    
    //[[Crashlytics sharedInstance] crash];
    
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    
    NSLog(@"%@", itemNumber);
    
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [self.storyEventRefs addObject:storyDescriptionRef];
    [storyDescriptionRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        if(snapshot.value != [NSNull null]){
            [self.tableView beginUpdates];
            [self.storiesArray addObject:snapshot.value];
            NSInteger row = self.storiesArray.count - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }

        
        
        
    } withCancelBlock:^(NSError *error) {
        
    }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize array that will store stories.
    self.storiesArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.topItem.title = self.navTitle;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0;
    
    UINib *celllNib = [UINib nibWithNibName:@"StoryTableCellView" bundle:nil] ;
    [self.tableView registerNib:celllNib forCellReuseIdentifier:@"storyCell"];
    
    [self getTopStories];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.detailsLabelText = self.loadMsg;
    HUD.mode = MBProgressHUDModeDeterminate;
    
    [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];
    

    [self.view addSubview:HUD];
    [HUD show:YES];
    
    self.tableView.scrollsToTop = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = self.navTitle;
    self.title = self.navTitle;
}

- (void)doSomeFunkyStuff {
    float progress = 0.0;
    
    while (progress < 1.0) {
        progress += 0.005;
        HUD.progress = progress;
        usleep(50000);
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storyCell" forIndexPath:indexPath];
    
        if (cell==nil) {
            
            NSArray* storyObject = [[NSBundle mainBundle] loadNibNamed:@"CurrentOffersInfoView" owner:self options:nil];
            
            cell = [storyObject firstObject];
        }
    
    
    
    
    // Get data from the array at position of the row
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    
    //Get the Time interval from when the story is posted
    NSTimeInterval timeSince = [[story valueForKey:@"time"] doubleValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970: timeSince];
    NSString *ago = [date timeAgo];
    
    NSMutableArray *commentArray = [story valueForKey:@"kids"];
    NSUInteger commentCount = [commentArray count];
    NSString *commentCountText = [NSString stringWithFormat:@"%@",  @(commentCount)];

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
        cell.sourceLabel.text = [NSString stringWithFormat:@"%@", reducedUrl];
        cell.typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [story valueForKeyPath:@"type"]]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.titleLabel.numberOfLines = 0;
        [cell.titleLabel sizeToFit];
    }
    [HUD hide:YES];
    
    //NSLog(@"Output is: \"%@\"", cell.titleLabel);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"toWebView" sender:story];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWebView"])
    {
        //if you need to pass data to the next controller do it here
        WebViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }
}

@end
