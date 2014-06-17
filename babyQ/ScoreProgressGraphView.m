//
//  ScoreProgressGraphView.m
//  babyQ
//
//  Created by Chris Wood on 6/16/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "ScoreProgressGraphView.h"

@implementation ScoreProgressGraphView

@synthesize yValues;

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
    CGFloat yRatio = self.frame.size.height/100;
    CGFloat xRatio = self.frame.size.width/(yValues.count-1);
    UIBezierPath *sparkline = [UIBezierPath bezierPath];
    for (int x = 0; x< yValues.count; x++) {
        CGPoint newPoint = CGPointMake(x*xRatio, self.frame.size.height - (yRatio*[[yValues objectAtIndex:x] doubleValue]));
        if (x == 0) {
            [sparkline moveToPoint:newPoint];
        }
        else {
            [sparkline addLineToPoint:newPoint];
        }
    }
    [[UIColor redColor] set];
    //[sparkline stroke];
    CAShapeLayer* line = [[CAShapeLayer alloc] init];
    [line setPath:sparkline.CGPath];
    line.fillColor = nil;
    line.opacity = 1.0;
    line.strokeColor = [UIColor redColor].CGColor;
    [[self layer] addSublayer:line];
}


@end
