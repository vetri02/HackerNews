//
//  HomeTableViewController.h
//  HackerNews
//
//  Created by Vetrichelvan on 18/02/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface HomeTableViewController : UITableViewController{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSMutableArray* storiesArray;

@end
