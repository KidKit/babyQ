//
//  Constants.h
//  babyQ
//
//  Created by Chris Wood on 6/17/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#ifndef babyQ_Constants_h
#define babyQ_Constants_h

NSString *const STAGING_HOST = @"http://50.203.58.166/babyq-backend/"
NSString *const VERSION = @"v1";

NSString *const FULL_STAGING_URL_PREFIX = [STAGING_HOST stringByAppendingString: VERSION];

NSString *const CREATE_ACCOUNT_PATH = @"/CreateStandardAccount";
NSString *const LOGIN_PATH = @"/StandardLogin";
NSString *const FACEBOOK_LOGIN_PATH = @"/FacebookLogin";
NSString *const FACEBOOK_FINALIZE_PATH = @"/FacebookFinalize";
NSString *const SET_DEVICE_PATH = @"/SetDevice";
NSString *const GET_ABOUT_ME_PATH = @"/GetAboutMe";
NSString *const SET_ABOUT_ME_PATH = @"/SetAboutMe";
NSString *const GET_PREGNANCY_PATH = @"/GetPregnancy";
NSString *const SET_PREGNANCY_PATH = @"/SetPregnancy";
NSString *const GET_DELIVERY_PATH = @"/GetDelivery";
NSString *const SET_DELIVERY_PATH = @"/SetDelivery";
NSString *const GET_SURVEY_PATH = @"/GetSurvey";
NSString *const SUBMIT_SURVEY_PATH = @"/SubmitSurvey";
NSString *const GET_CURRENT_SCORE_PATH = @"/GetCurrentScore";
NSString *const GET_SCORE_HISTORY_PATH = @"/GetSurveyHistory";
NSString *const GET_COMPLETED_TODOS_PATH = @"/GetCompletedToDos";
NSString *const GET_CURRENT_TODOS_PATH = @"/GetCurrentToDos";
NSString *const SET_TODO_COMPLETED_PATH = @"/SetToDoCompleted";
NSString *const GET_DAILY_TIP_PATH = @"/GetDailyTip";
NSString *const GET_TIP_HISTORY_PATH = @"/GetTipHistory";
NSString *const GET_NEXT_TIP_HISTORY_GROUP_PATH = @"/GetNextTipHistoryGroup";

#endif
