//
//  WebViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 13/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "WebViewController.h"
#import "CommentsTableViewController.h"

@interface WebViewController ()
- (IBAction)commentsButton:(UIButton *)sender;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Load web page
    //NSString *fullURL = @"http://designcode.io";
    NSURL *url = [NSURL URLWithString:[self.story valueForKey:@"url"]];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:requestObject];
    
    self.title = [self.story valueForKey:@"title"];
    [self.navigationItem.backBarButtonItem setTitle:@" "];
    //self.navigationController.toolbarHidden = NO;
    
    NSLog(@"%@", self.story);
    
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
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

- (IBAction)commentsButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"webToComments" sender:self.story];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"webToComments"])
    {
        //if you need to pass data to the next controller do it here
        CommentsTableViewController *controller = segue.destinationViewController;
        controller.story = sender;
    }
}

@end
