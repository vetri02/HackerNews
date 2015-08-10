//
//  WebViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 13/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "WebViewController.h"
#import "CommentsTableViewController.h"
#import <TUSafariActivity/TUSafariActivity.h>

@interface WebViewController ()
- (IBAction)commentsButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webForward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *share;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (nonatomic, strong) NSDictionary *setStory;
- (IBAction)webShare:(id)sender;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Load web page
    //NSString *fullURL = @"http://designcode.io";
    self.setStory = self.story;
    NSURL *url = [NSURL URLWithString:[self.story valueForKey:@"url"]];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:requestObject];
    self.viewWeb.delegate = self;
    self.viewWeb.scalesPageToFit = YES;
    
    
    
    //TEST
//    NSAssert([self.viewWeb isKindOfClass:[UIWebView class]], @"You webView outlet is not correctly connected.");
//    NSAssert(self.webBack, @"Your back button outlet is not correctly connected");
//    NSAssert(self.refresh, @"Your refresh button outlet is not correctly connected");
//    NSAssert(self.webForward, @"Your forward button outlet is not correctly connected");
//    NSAssert((self.webBack.target == self.viewWeb) && (self.webBack.action = @selector(goBack)), @"Your back button action is not connected to goBack.");
//    NSAssert((self.refresh.target == self.viewWeb) && (self.refresh.action = @selector(reload)), @"Your refresh button action is not connected to reload.");
//    NSAssert((self.webForward.target == self.viewWeb) && (self.webForward.action = @selector(goForward)), @"Your forward button action is not connected to goForward.");
//    NSAssert(self.viewWeb.scalesPageToFit, @"You forgot to check 'Scales Page to Fit' for your web view.");
    
    
    
    self.navigationItem.hidesBackButton=YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,13.5,23);
    [button setBackgroundImage:[UIImage imageNamed:@"Safari Back White"] forState:UIControlStateNormal];
    
//    [button setTitle:@"" forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:16.0f]];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    
    
    

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320-10, 44)];
    titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
    //titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    titleLabel.text = [self.story valueForKey:@"title"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = titleLabel;
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-10, -10)
//                                                         forBarMetrics:UIBarMetricsDefault];
    

    //NSLog(@"%@", self.story);
    
    if ([self.story valueForKey:@"kids"] && [self.story valueForKey:@"kids"] != [NSNull null] && ![[self.story valueForKey:@"kids"]  isEqual: @""]){
        //[self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        self.navigationItem.rightBarButtonItem.title = @"Comments";
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    } else {
        //[self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem.title = @"";
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    
    self.viewWeb.delegate = self;
    self.viewWeb.progressDelegate = self;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
     [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window) {
        self.view = nil;
    }
    
    
    // Do additional cleanup if necessary
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    //NSLog(@"finished loading");
    self.progressView.hidden = YES;
    CGRect frame = self.viewWeb.frame;
    frame.origin.y=0;//pass the cordinate which you want
    self.viewWeb.frame= frame;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    // Enable or disable back
//    [self.webBack setEnabled:[self.viewWeb canGoBack]];
//    
//    // Enable or disable forward
//    [self.webForward setEnabled:[self.viewWeb canGoForward]];
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    theWebView.scrollView.minimumZoomScale = rw;
//    theWebView.scrollView.maximumZoomScale = rw;
//    theWebView.scrollView.zoomScale = rw;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSLog(@"start loading");
    
    // Enable or disable back
    [self.webBack setEnabled:[self.viewWeb canGoBack]];
    
    // Enable or disable forward
    [self.webForward setEnabled:[self.viewWeb canGoForward]];
}

#pragma mark - NJKWebViewProgressDelegate

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    //self.progressView = progress;
    //NSLog(@"%f", progress);
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        // Reset state for new page load
        self.progressView.hidden = NO;
        CGRect frame = self.viewWeb.frame;
        frame.origin.y=2;//pass the cordinate which you want
        self.viewWeb.frame= frame;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.progressView setProgress:0 animated:YES];
    }
    
    return YES;
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

- (IBAction)webShare:(id)sender {
    NSString *textToShare = [self.setStory valueForKey:@"title"];
    NSURL *myWebsite = [NSURL URLWithString:[self.setStory valueForKey:@"url"]];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    TUSafariActivity *activity = [[TUSafariActivity alloc] init];
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[myWebsite] applicationActivities:@[activity]];
//    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:@[activity]];
    
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypePrint,
//                                   UIActivityTypeAssignToContact,
//                                   UIActivityTypeSaveToCameraRoll,
//                                   UIActivityTypeAddToReadingList,
//                                   UIActivityTypePostToFlickr,
//                                   UIActivityTypePostToVimeo];
    
    //activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
