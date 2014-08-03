//
//  SideSwipeTableViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/11/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SideSwipeTableViewCell.h"
#import "MMDrawerController.h"
#import "CurrentScoreViewController.h"
#import "HowItWorksPageViewController.h"

@interface SideSwipeTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,retain) IBOutlet UILabel* headerLabel;
@end
