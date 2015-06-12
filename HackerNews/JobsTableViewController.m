//
//  JobsTableViewController.m
//  HackerNews
//
//  Created by Vetrichelvan on 12/06/15.
//  Copyright (c) 2015 Vetrichelvan. All rights reserved.
//

#import "JobsTableViewController.h"

@interface JobsTableViewController ()

@end

@implementation JobsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)datasourceName {
    
    return @"jobstories";
}

- (NSString *)loadMsg {
    
    return @"Fetching Jobs";
}

- (NSString *)navTitle {
    
    return @"Jobs";
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
