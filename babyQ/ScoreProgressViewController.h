//
//  ScoreProgressViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreProgressGraphView.h"

@interface ScoreProgressViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* scoreLabel;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@end
