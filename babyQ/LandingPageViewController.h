//
//  LandingPageViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "JoinViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LandingPageViewController : UIViewController

@property (nonatomic,retain) IBOutlet UILabel* headerLabel;

-(IBAction)pushSignInJoinScreen;
- (IBAction)loginWithFacebook:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)join:(id)sender;

@end
