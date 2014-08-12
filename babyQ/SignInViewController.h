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
@property (nonatomic,retain) IBOutlet UILabel* forgotPasswordLabel;
@property (nonatomic,retain) IBOutlet UILabel* errorMessage;

- (IBAction) signIn;
- (IBAction)forgotPassword;

@end
