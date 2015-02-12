//
//  ViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 03/08/14.
//  Copyright (c) 2014 Vetrichelvan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupGradients];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSString *fullURL = @"https://github.com/philipl/pifs";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/********* Back Buttn ***********/

- (IBAction)unwindFromView: (UIStoryboardSegue *)sender {}

/********* Status Bar ***********/

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/* Web View Load indicator */


/*
 *******************************************************
 Setup gradients
 *******************************************************
 */
- (void) setupGradients {
    
    CAGradientLayer *gradientLayer = [Gradient orangeGradient];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
}
//*********************************************************************************************************

@end
