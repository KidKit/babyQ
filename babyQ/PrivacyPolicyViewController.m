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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"PRIVACY POLICY";
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://tutorial.babyq.com/privacy-policy/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1000];
    [self.privacyPolicy loadRequest: request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
