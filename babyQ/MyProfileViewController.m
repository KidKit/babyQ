//
//  MyProfileViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 1136)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
