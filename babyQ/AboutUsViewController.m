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

@synthesize copyright,aboutUs,findUs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    findUs.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    aboutUs.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    copyright.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
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
    
}

-(IBAction)facebook:(id)sender
{
    
}

-(IBAction)website:(id)sender
{
    
}

-(IBAction)blog:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
