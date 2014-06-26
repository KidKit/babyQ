//
//  TipHistoryViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"

@interface TipHistoryViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIImageView* background;
@property (nonatomic, retain) UIButton* moreButton;
@property (nonatomic, retain) NSArray* tipsArray;
@property (nonatomic, retain) NSMutableData* tipsData;

@end
