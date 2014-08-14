//
//  SVWebViewDelegate.h
//  yamaha
//
//  Created by Cesar Davila on 10/8/13.
//  Copyright (c) 2013 XTOPOLY, INC. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SVWebViewDelegate <NSObject>
@optional
- (void) svWebViewControllerWillDismiss:(UIViewController*) controller;
- (void) svWebViewControllerDidDismiss:(UIViewController*) controller;
@end