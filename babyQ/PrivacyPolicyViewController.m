//
//  PrivacyPolicyViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

@synthesize privacyPolicy;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://tutorial.babyq.com/privacy-policy/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1000];
    [self.privacyPolicy loadRequest: request];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"PRIVACY POLICY";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
