//
//  SignInViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideSwipeTableViewController.h"
#import "AppDelegate.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField* email;
@property (nonatomic,retain) IBOutlet UITextField* password;

- (IBAction) signIn;

@end
