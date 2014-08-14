//
//  AboutUsViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

#define facebookURL @"https://www.facebook.com/babyQapp"
#define twitterURL @"https://twitter.com/babyQapp"
#define websiteURL @"https://www.babyq.com/"
#define blogURL @"https://www.babyq.com/blog/"

@synthesize copyright,aboutUs,findUs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    findUs.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:19];
    aboutUs.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
    copyright.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"ABOUT US";
}

-(IBAction)twitter:(id)sender
{
    NSURL *url = [NSURL URLWithString:twitterURL];
    
    SVModalWebViewController *webBrowser = [[SVModalWebViewController alloc] initWithURL:url];
    webBrowser.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self presentViewController:webBrowser animated:YES completion:nil];
}

-(IBAction)facebook:(id)sender
{
    NSURL *url = [NSURL URLWithString:facebookURL];
    
    SVModalWebViewController *webBrowser = [[SVModalWebViewController alloc] initWithURL:url];
    webBrowser.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self presentViewController:webBrowser animated:YES completion:nil];
}

-(IBAction)website:(id)sender
{
    NSURL *url = [NSURL URLWithString:websiteURL];
    
    SVModalWebViewController *webBrowser = [[SVModalWebViewController alloc] initWithURL:url];
    webBrowser.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self presentViewController:webBrowser animated:YES completion:nil];
}

-(IBAction)blog:(id)sender
{
    NSURL *url = [NSURL URLWithString:blogURL];
    
    SVModalWebViewController *webBrowser = [[SVModalWebViewController alloc] initWithURL:url];
    webBrowser.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self presentViewController:webBrowser animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
