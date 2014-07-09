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
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.topItem.title = @"ABOUT US";
    
    findUs.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    aboutUs.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    copyright.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
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
