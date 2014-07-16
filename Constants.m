//
//  Constants.m
//  babyQ
//
//  Created by Chris Wood on 6/18/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "Constants.h"

@implementation Constants
- (id)init {
    if( (self = [super init]) ) {
        self.HOST = @"http://50.203.58.166/babyq-backend/";
        self.VERSION = @"v1";

        self.CREATE_ACCOUNT_PATH = @"/CreateStandardAccount";
        self.LOGIN_PATH = @"/StandardLogin";
        self.FORGOT_PASSWORD_PATH = @"/ForgotPassword";
        self.FACEBOOK_LOGIN_PATH = @"/FacebookLogin";
        self.FACEBOOK_FINALIZE_PATH = @"/FacebookFinalize";
        self.REGISTER_DEVICE_PATH = @"/RegisterDevice";
        self.SET_DEVICE_SETTINGS_PATH = @"/SetDeviceSettings";
        self.GET_DEVICE_SETTINGS_PATH = @"/GetDeviceSettings";
        self.GET_ABOUT_ME_PATH = @"/GetAboutMe";
        self.SET_ABOUT_ME_PATH = @"/SetAboutMe";
        self.GET_PREGNANCY_PATH = @"/GetPregnancy";
        self.SET_PREGNANCY_PATH = @"/SetPregnancy";
        self.GET_DELIVERY_PATH = @"/GetDelivery";
        self.SET_DELIVERY_PATH = @"/SetDelivery";
        self.GET_SURVEY_PATH = @"/GetSurvey";
        self.SUBMIT_SURVEY_PATH = @"/SubmitSurvey";
        self.GET_CURRENT_SCORE_PATH = @"/GetCurrentScore";
        self.GET_SCORE_HISTORY_PATH = @"/GetSurveyHistory";
        self.GET_COMPLETED_TODOS_PATH = @"/GetCompletedToDos";
        self.GET_NEXT_COMPLETED_TODOS_GROUP_PATH = @"/GetNextCompletedToDoGroup";
        self.GET_CURRENT_TODOS_PATH = @"/GetCurrentToDos";
        self.SET_TODO_COMPLETED_PATH = @"/SetToDoCompleted";
        self.GET_DAILY_TIP_PATH = @"/GetDailyTip";
        self.GET_TIP_HISTORY_PATH = @"/GetTipHistory";
        self.GET_NEXT_TIP_HISTORY_GROUP_PATH = @"/GetNextTipHistoryGroup";
    }
    return self;
}
@end
