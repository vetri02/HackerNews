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
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320-10, 44)];
//    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    //titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
//    //titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
//    titleLabel.text = [self.story valueForKey:@"title"];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = [UIColor whiteColor];
    
    
    NSLog(@"%@", self.story);
    
    self.viewWeb.delegate = self;
    self.viewWeb.progressDelegate = self;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
     [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AvenirNext-Medium" size:16.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)theWebView
//{
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    theWebView.scrollView.minimumZoomScale = rw;
//    theWebView.scrollView.maximumZoomScale = rw;
//    theWebView.scrollView.zoomScale = rw;
//}

#pragma mark - NJKWebViewProgressDelegate

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    //self.progressView = progress;
    NSLog(@"%f", progress);
    if(progress == 1.0){
        self.progressView.hidden = YES;
        CGRect frame = self.viewWeb.frame;
        frame.origin.y=0;//pass the cordinate which you want
        self.viewWeb.frame= frame;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }else {
        [self.progressView setProgress:progress animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)commentsButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"webToComments" sender:self.story];
}

#pragma mark - Navigation

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
