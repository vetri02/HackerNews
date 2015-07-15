//
//  ViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 03/08/14.
//  Copyright (c) 2014 Vetrichelvan. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonDidPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *usernameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self setupGradients];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;

    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    //Username Field is active
    if ([textField isEqual:self.usernameTextField]) {
    
        //NSLog(@"username");
        self.usernameImageView.image = [UIImage imageNamed:@"userSolid"];
        //self.usernameTextField.borderStyle = UITextBorderStyleLine;
        
    } else {
    
        self.usernameImageView.image = [UIImage imageNamed:@"userLine"];
        //self.usernameTextField.borderStyle = UITextBorderStyleNone;
    
    }
    
    //Password Field is active
    if ([textField isEqual:self.passwordTextField]){
        
        //NSLog(@"password");
        self.passwordImageView.image = [UIImage imageNamed:@"lockSolid"];
        //self.passwordTextField.borderStyle = UITextBorderStyleLine;
    
    } else {
       
        self.passwordImageView.image = [UIImage imageNamed:@"lockLine"];
        //self.passwordTextField.borderStyle = UITextBorderStyleNone;
   
    }
    
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
              //Change the size of dialogview
              //Make sure it's run only once
              if(self.dialogView.frame.origin.y == 148){
                  [self.dialogView setFrame:CGRectMake(self.dialogView.frame.origin.x, self.dialogView.frame.origin.y-60, self.dialogView.frame.size.width, 320)];
              }
          } completion:^(BOOL finished){
              
          }];
}
@end
