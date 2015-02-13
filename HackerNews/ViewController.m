//
//  ViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 03/08/14.
//  Copyright (c) 2014 Vetrichelvan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonDidPress:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self setupGradients];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSString *fullURL = @"https://github.com/philipl/pifs";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    
}


/********* Back Buttn ***********/

- (IBAction)unwindFromView: (UIStoryboardSegue *)sender {}


/*
 *******************************************************
 Setup gradients
 *******************************************************
 */
//- (void) setupGradients {
//    
//    CAGradientLayer *gradientLayer = [Gradient orangeGradient];
//    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view.layer insertSublayer:gradientLayer atIndex:0];
//    
//}
//*********************************************************************************************************

- (IBAction)loginButtonDidPress:(id)sender {
    //Animate Login Button
    
    [UIView animateWithDuration:0.1 animations:^{
        self.loginButton.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished){
        //Step 2
        [UIView animateWithDuration:0.1 animations:^{
            self.loginButton.transform = CGAffineTransformMakeTranslation(-10, 0);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^{
                self.loginButton.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }];
    }];
    
    // animationWithDuration with Damping
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5
          initialSpringVelocity:0 options:0 animations:^{
              [self.dialogView setFrame:CGRectMake(self.dialogView.frame.origin.x, self.dialogView.frame.origin.y, self.dialogView.frame.size.width, 320)];
          } completion:^(BOOL finished){
              
          }];
}
@end
