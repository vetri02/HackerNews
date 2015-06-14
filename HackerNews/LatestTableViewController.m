//
//  LatestTableViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 12/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "LatestTableViewController.h"
#import "MBProgressHUD.h"

@interface LatestTableViewController ()

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
