//
//  AppDelegate.h
//  babyQ
//
//  Created by Chris Wood on 6/10/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SignInViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString* api_token;
@property (nonatomic,retain) NSString* fb_userId;
@property (nonatomic,retain) NSString* fb_name;
@property (nonatomic,retain) NSString* fb_birthday;
@property (nonatomic,retain) NSString* user_email;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
