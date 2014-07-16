//
//  Constants.h
//  babyQ
//
//  Created by Chris Wood on 6/18/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

@property (nonatomic,retain) NSString *const HOST;
@property (nonatomic,retain) NSString *const VERSION;
@property (nonatomic,retain) NSString *const CREATE_ACCOUNT_PATH;
@property (nonatomic,retain) NSString *const LOGIN_PATH;
@property (nonatomic,retain) NSString *const FORGOT_PASSWORD_PATH;
@property (nonatomic,retain) NSString *const FACEBOOK_LOGIN_PATH;
@property (nonatomic,retain) NSString *const FACEBOOK_FINALIZE_PATH;
@property (nonatomic,retain) NSString *const REGISTER_DEVICE_PATH;
@property (nonatomic,retain) NSString *const SET_DEVICE_SETTINGS_PATH;
@property (nonatomic,retain) NSString *const GET_DEVICE_SETTINGS_PATH;
@property (nonatomic,retain) NSString *const GET_ABOUT_ME_PATH;
@property (nonatomic,retain) NSString *const SET_ABOUT_ME_PATH;
@property (nonatomic,retain) NSString *const GET_PREGNANCY_PATH;
@property (nonatomic,retain) NSString *const SET_PREGNANCY_PATH;
@property (nonatomic,retain) NSString *const GET_DELIVERY_PATH;
@property (nonatomic,retain) NSString *const SET_DELIVERY_PATH;
@property (nonatomic,retain) NSString *const GET_SURVEY_PATH;
@property (nonatomic,retain) NSString *const SUBMIT_SURVEY_PATH;
@property (nonatomic,retain) NSString *const GET_CURRENT_SCORE_PATH;
@property (nonatomic,retain) NSString *const GET_SCORE_HISTORY_PATH;
@property (nonatomic,retain) NSString *const GET_COMPLETED_TODOS_PATH;
@property (nonatomic,retain) NSString *const GET_NEXT_COMPLETED_TODOS_GROUP_PATH;
@property (nonatomic,retain) NSString *const GET_CURRENT_TODOS_PATH;
@property (nonatomic,retain) NSString *const SET_TODO_COMPLETED_PATH;
@property (nonatomic,retain) NSString *const GET_DAILY_TIP_PATH;
@property (nonatomic,retain) NSString *const GET_TIP_HISTORY_PATH;
@property (nonatomic,retain) NSString *const GET_NEXT_TIP_HISTORY_GROUP_PATH;

@end
