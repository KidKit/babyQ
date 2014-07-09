//
//  AboutUsViewController.h
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel* copyright;
@property (nonatomic, retain) IBOutlet UITextView* aboutUs;
@property (nonatomic, retain) IBOutlet UILabel* findUs;

-(IBAction)twitter:(id)sender;
-(IBAction)facebook:(id)sender;
-(IBAction)website:(id)sender;
-(IBAction)blog:(id)sender;

@end
