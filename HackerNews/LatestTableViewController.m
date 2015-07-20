//
//  LatestTableViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 12/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "LatestTableViewController.h"
#import "MBProgressHUD.h"
#import "WebViewController.h"
#import "CommentsTableViewController.h"

@interface LatestTableViewController ()
- (IBAction)refresh:(UIRefreshControl *)sender;

@end

@implementation LatestTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.datasourceName = @"newstories";
    self.loadMsg = @"Fetching Latest";
    self.navTitle = @"Latest Stories";
    return self;
}

- (void)viewDidLoad {
    
    
    //self.datasourceName = @"newstories";
    HUD.detailsLabelText = @"Fetching Latest Stories";
    
    //self.navigationController.navigationBar.topItem.title = @"Latest Stories";
    
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *story = [self.storiesArray objectAtIndex:indexPath.row];
    NSString *urlString = [story valueForKey:@"url"];
    if(urlString.length > 0) {
        [self performSegueWithIdentifier:@"latesttoWebView" sender:story];
    } else {
        [self performSegueWithIdentifier:@"latestToComments" sender:story];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"latesttoWebView"])
    {
        //if you need to pass data to the next controller do it here
        WebViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }else if([[segue identifier] isEqualToString:@"latestToComments"]) {
        CommentsTableViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self.storiesArray removeAllObjects];
    [self.tableView reloadData];
    
    [super viewDidLoad];
    //[HUD show:YES];
    
    [sender endRefreshing];
}
@end
