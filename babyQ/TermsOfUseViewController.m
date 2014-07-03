//
//  TermsOfUseViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

@synthesize termsOfUse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"TERMS OF USE";
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://tutorial.babyq.com/terms-of-use/"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1000];
    [self.termsOfUse loadRequest: request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
