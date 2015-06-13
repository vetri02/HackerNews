//
//  WebViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 13/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

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

@end
