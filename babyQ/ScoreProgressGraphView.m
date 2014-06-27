//
//  ScoreProgressGraphView.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "ScoreProgressGraphView.h"

@implementation ScoreProgressGraphView

@synthesize yValues,circles;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
}

- (void) calc_info
{
    circles = [[NSMutableArray alloc] init];
    CGFloat yRatio = self.frame.size.height/100;
    CGFloat xRatio = self.frame.size.width/(yValues.count-1);
    UIBezierPath *sparkline = [UIBezierPath bezierPath];
    for (int x = 0; x< yValues.count; x++) {
        UIButton* circle = [UIButton buttonWithType:UIButtonTypeCustom];
        [circle setFrame:CGRectMake(x*xRatio-5, self.frame.size.height - (yRatio*[[yValues objectAtIndex:x] doubleValue])-8, 16, 16)];
        [circle setBackgroundImage:[UIImage imageNamed:@"babyq_circle_orange_no_fill.png"] forState:UIControlStateNormal];
        circle.tag = x;
        [circles addObject:circle];
        CGPoint newPoint = CGPointMake(x*xRatio, self.frame.size.height - (yRatio*[[yValues objectAtIndex:x] doubleValue]));
        if (x == 0) {
            [sparkline moveToPoint:newPoint];
        }
        else {
            [sparkline addLineToPoint:newPoint];
        }
    }
    //[sparkline stroke];
    CAShapeLayer* line = [[CAShapeLayer alloc] init];
    [line setPath:sparkline.CGPath];
    line.fillColor = nil;
    line.lineWidth = 4.0;
    line.opacity = 1.0;
    line.strokeColor = [UIColor whiteColor].CGColor;
    [[self layer] addSublayer:line];
}


@end
