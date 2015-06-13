//
//  WebViewController.h
//  HackerNews
//
//  Created by Vetrichelvan on 13/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) NSString *fullURL;
@property (weak, nonatomic) NSDictionary *story;

@end
