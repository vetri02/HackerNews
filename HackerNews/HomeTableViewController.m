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



@interface HomeTableViewController ()

@property NSMutableArray *temporaryTop100StoriesIds;
@property NSMutableArray *storyEventRefs;
@property NSMutableArray *dataArr;

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
    [topStories observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"%@", snapshot.value);
        self.dataArr = snapshot.value;
        
        
        
        NSLog (@"Number of elements in array = %lu", [self.dataArr count]);
        
        self.temporaryTop100StoriesIds = [snapshot.value mutableCopy];
        [self getStoryDescriptionsUsingNewIDs:YES];
        //[listStories addObject:(snapshot.value)];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}

- (void)getStoryDescriptionsUsingNewIDs:(BOOL)usingNewIDs{
    
    if(usingNewIDs){
        for(NSNumber *itemNumber in self.temporaryTop100StoriesIds){
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
    [storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        //NSDictionary *responseDictionary = snapshot.value;
        
        NSLog(@"%@", snapshot.value);
        
        
        
    } withCancelBlock:^(NSError *error) {
        
    }
     ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self getTopStories];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://hacker-news.firebaseio.com/v0/"];
//    //__block Firebase *itemRef = nil;
//    Firebase *topStories = [ref childByAppendingPath:@"topstories"];
//    //Firebase *firstStory = [topStories childByAppendingPath:@"0"];
//    //__block NSMutableArray *listStories = [[NSMutableArray alloc] init];
//    // Attach a block to read the data at our posts reference
//    [topStories observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@", snapshot.value);
//        //[listStories addObject:(snapshot.value)];
//    } withCancelBlock:^(NSError *error) {
//        NSLog(@"%@", error.description);
//    }];
    
    
    
    //NSLog(@"%@", listStories);
    
//    FirebaseHandle handle = [firstStory observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        if(itemRef != nil) {
//            [itemRef removeObserverWithHandle: handle];
//        }
//        
//        NSString *itemId = [NSString stringWithFormat:@"item/%@",snapshot.value];
//        itemRef = [ref childByAppendingPath:itemId];
//        
//        [itemRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *itemSnap) {
//            NSLog(@"%@", itemSnap.value);
//        }];
//    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   
    //NSLog(@"%@", snapshot.value);
    return [self.dataArr count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
