//
//  ScoreProgressGraphView.h
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreProgressGraphView : UIScrollView {
    NSArray *yValues;
}

@property (strong, atomic) NSArray *yValues;
@property (strong, atomic) NSMutableArray* circles;

-(void) calc_info;
@end
