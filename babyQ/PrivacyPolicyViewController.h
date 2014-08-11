//
//  PrivacyPolicyViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface PrivacyPolicyViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* offlineMessage;
@property (nonatomic, retain) IBOutlet UIWebView* privacyPolicy;

@end
