//
//  HowItWorksContentViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowItWorksContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView* avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UITextView* pageTextView;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *pageText;
@property NSString *imageFile;

@end
