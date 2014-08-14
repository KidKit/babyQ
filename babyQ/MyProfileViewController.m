//
//  MyProfileViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/12/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

@synthesize scrollView,headerLabel,statusBarWhiteBG,headerButton1,headerButton2,profilePicture,cameraImage,aboutMeView,nameField,zipCodeField,saveAboutMeButton,cancelAboutMeButton,pregnancyView,savePregnantButton,cancelPregnantButton,deliveredView,saveDeliveryButton,cancelDeliveryButton,nameLabel,birthdayLabel,zipCodeLabel,isPregnantLabel,dueDateLabel,wasDeliveredLabel,deliveredDateLabel,birthTypeLabel,vaginalLabel,cSectionLabel,complicationsLabel,complication1Label,complication2Label,complication3Label,complication4Label,complication5Label,complication6Label,complication1Button,complication2Button,complication3Button,complication4Button,complication5Button,complication6Button,yesDelivered,noDelivered,yesDeliveredLabel,noDeliveredLabel,vaginalButton,cSectionButton, savedMessage,offlineMessage,dueDate,deliveryDate,birthday,aboutMeHeader,pregnancyHeader,deliveryHeader,noPregnantButton,yesPregnantButton,noPregnant,yesPregnant,babyFeetField,babyInchesField,babyFeetLabel,babyInchesLabel,babyPoundsField,babyOuncesField,babyPoundsLabel,babyOuncesLabel,babyLengthLabel;

BOOL internet;
NSURLConnection* getAboutMeConnection;
NSURLConnection* setAboutMeConnection;
NSURLConnection* getPregnantConnection;
NSURLConnection* setPregnantConnection;
NSURLConnection* getDeliveryConnection;
NSURLConnection* setDeliveryConnection;

NSString* prevName;
NSDate* prevBirthdate;
NSString* prevZipcode;
bool prevIsPregnant;
NSDate* prevDueDate;
bool prevWasDelivered;
int prevBirthType;
NSDate* prevDeliveryDate;
NSString* prevBabyOunces;
NSString* prevBabyPounds;
NSString* prevBabyInches;

int isPregnant;
int delivered;
int birthTypeId;
NSMutableArray* complications;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    deliveredView.hidden = YES;
    NSString* fb_pic = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_profilePicture];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIColor *color = [UIColor colorWithRed:124 green:197 blue:189 alpha:1.0f];
    nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    zipCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip Code" attributes:@{NSForegroundColorAttributeName: color}];
    
    dueDate.datePickerMode = UIDatePickerModeDate;
    [dueDate setMinimumDate:[NSDate date]];
    deliveryDate.datePickerMode = UIDatePickerModeDate;
    birthday.datePickerMode = UIDatePickerModeDate;
    
    savedMessage.font = complication1Label.font = complication2Label.font = complication3Label.font = complication4Label.font = complication5Label.font = complication6Label.font = noPregnant.font = yesPregnant.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    
    nameLabel.font = birthdayLabel.font = zipCodeLabel.font = isPregnantLabel.font = dueDateLabel.font = wasDeliveredLabel.font = birthTypeLabel.font = complicationsLabel.font = deliveredDateLabel.font = babyLengthLabel.font = [UIFont fontWithName:@"MyriadPro-Bold" size:14];
    
    aboutMeHeader.font = pregnancyHeader.font = deliveryHeader.font = [UIFont fontWithName:@"MyriadPro-Bold" size:19];
    savedMessage.hidden = YES;
    
    if ([fb_pic length] > 0)
    {
        cameraImage.hidden = YES;
        profilePicture.imageView.layer.cornerRadius = 50.0;
        profilePicture.imageView.layer.masksToBounds = YES;
        profilePicture.imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *imageURL = [NSURL URLWithString:fb_pic];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        profilePicture.imageView.image = image;
        profilePicture.userInteractionEnabled = NO;
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[user_email stringByAppendingString:@"_latest_photo.png"]];
        
        NSData* picData = [NSData dataWithContentsOfFile:imagePath];
        if (picData != nil)
        {
            profilePicture.imageView.layer.cornerRadius = 50.0;
            profilePicture.imageView.layer.masksToBounds = YES;
            profilePicture.imageView.contentMode = UIViewContentModeScaleAspectFill;
            UIImage* picImage = [UIImage imageWithData:picData];
            [profilePicture setImage:picImage forState:UIControlStateNormal];
        }
    }
    
    Constants* constants = [[Constants alloc] init];
    
    NSString* getAboutMeURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_ABOUT_ME_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *getAboutMeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getAboutMeURL]];
    [getAboutMeRequest setHTTPMethod:@"POST"];
    [getAboutMeRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getAboutMeConnection = [[NSURLConnection alloc] initWithRequest:getAboutMeRequest delegate:self];
    
    NSString* getPregnantURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_PREGNANCY_PATH];
    postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *getPregnantRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getPregnantURL]];
    [getPregnantRequest setHTTPMethod:@"POST"];
    [getPregnantRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getPregnantConnection = [[NSURLConnection alloc] initWithRequest:getPregnantRequest delegate:self];
    
    delivered = -1;
    birthTypeId = -1;
    complications = [[NSMutableArray alloc] init];
    
    NSString* getDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DELIVERY_PATH];
    postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *getDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getDeliveryURL]];
    [getDeliveryRequest setHTTPMethod:@"POST"];
    [getDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getDeliveryConnection = [[NSURLConnection alloc] initWithRequest:getDeliveryRequest delegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [nameField resignFirstResponder];
    [zipCodeField resignFirstResponder];
    [babyOuncesField resignFirstResponder];
    [babyPoundsField resignFirstResponder];
    [babyInchesField resignFirstResponder];
    [babyFeetField resignFirstResponder];
}
- (IBAction)getPhoto
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"])
    {
        NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
        [picker dismissViewControllerAnimated:YES completion:nil];
        profilePicture.imageView.layer.cornerRadius = 50.0;
        profilePicture.imageView.layer.masksToBounds = YES;
        profilePicture.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [profilePicture setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        //obtaining saving path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[user_email stringByAppendingString:@"_latest_photo.png"]];
        
        //extracting image from the picker and saving it
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *profileImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            NSData *webData = UIImagePNGRepresentation(profileImage);
            [webData writeToFile:imagePath atomically:YES];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == getAboutMeConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        nameField.text = json_dictionary[@"Name"];
        prevName = json_dictionary[@"Name"];
        
        NSArray* dueDateSplit = [json_dictionary[@"Birthdate"] componentsSeparatedByString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* savedDueDate = [dateFormatter dateFromString:dueDateSplit[0]];
        birthday.date = savedDueDate;
        prevBirthdate = savedDueDate;
        
        zipCodeField.text = json_dictionary[@"ZipCode"];
        prevZipcode = json_dictionary[@"ZipCode"];
    } else if (connection == setAboutMeConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self dismissKeyboard];

            savedMessage.hidden = NO;
            [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 71+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            [UIView animateWithDuration:3.0f animations:^{
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            } completion:^(BOOL finished) {
                if (finished)
                    savedMessage.hidden = YES;
            }];
            
        }
    } else if (connection == getPregnantConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* getPregnantResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        NSArray* dueDateSplit = [getPregnantResponse[@"DueDate"] componentsSeparatedByString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* savedDueDate = [dateFormatter dateFromString:dueDateSplit[0]];
        dueDate.date = savedDueDate;
        prevDueDate = savedDueDate;
        
        if ([getPregnantResponse[@"IsPregnant"] isEqualToString:@"1"])
        {
                [yesPregnantButton setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, 428)];
            if ([(NSDate*)[prevDueDate dateByAddingTimeInterval:-60*60*24*14] compare:[NSDate date] ] == NSOrderedAscending )
            {
                deliveredView.hidden = NO;
                [self.scrollView setContentSize:CGSizeMake(320, 1425)];
            }
            else
            {
                deliveredView.hidden = YES;
                [self.scrollView setContentSize:CGSizeMake(320, 1075)];
            }
            
        }
        else if ([getPregnantResponse[@"IsPregnant"] isEqualToString:@"0"])
        {
            [noPregnantButton setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
            [self.scrollView setContentSize:CGSizeMake(320, 850)];
        }
        
    } else if (connection == setPregnantConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            savedMessage.hidden = NO;
            [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 71+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            [UIView animateWithDuration:2.0f animations:^{
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            } completion:^(BOOL finished) {
                if (finished)
                    savedMessage.hidden = YES;
            }];
            [self dismissKeyboard];
            
            if ([(NSDate*)[prevDueDate dateByAddingTimeInterval:-60*60*24*14] compare:[NSDate date] ] == NSOrderedAscending )
            {
                deliveredView.hidden = NO;
                [self.scrollView setContentSize:CGSizeMake(320, 1350)];
            }
            else
            {
                deliveredView.hidden = YES;
                [self.scrollView setContentSize:CGSizeMake(320, 1100)];
            }
        }
    } else if (connection == getDeliveryConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* getDeliveryResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        NSArray* dueDateSplit = [getDeliveryResponse[@"DeliveryDate"] componentsSeparatedByString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* savedDueDate = [dateFormatter dateFromString:dueDateSplit[0]];
        //deliveryDate.date = savedDueDate;
        //prevDeliveryDate = savedDueDate;
        
        if (getDeliveryResponse[@"BabyLengthInches"] != (id)[NSNull null])
        {
            prevBabyInches = getDeliveryResponse[@"BabyLengthInches"];
            babyInchesField.text = getDeliveryResponse[@"BabyLengthInches"];
        }
        if (getDeliveryResponse[@"BabyWeightOunces"] != (id)[NSNull null])
        {
            prevBabyOunces = getDeliveryResponse[@"BabyWeightOunces"];
            babyOuncesField.text = getDeliveryResponse[@"BabyWeightOunces"];
        }
        if (getDeliveryResponse[@"BabyWeightPounds"] != (id)[NSNull null])
        {
            prevBabyPounds = getDeliveryResponse[@"BabyWeightPounds"];
            babyPoundsField.text = getDeliveryResponse[@"BabyWeightPounds"];
        }
        if (getDeliveryResponse[@"Delivered"] != (id)[NSNull null])
        {
            if ([getDeliveryResponse[@"Delivered"] isEqualToString:@"1"])
            {
                delivered = 1;
                [yesDelivered setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                pregnancyView.hidden = YES;
                [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y-495, deliveredView.frame.size.width, 1042)];
                [scrollView setContentSize:CGSizeMake(320, 1800)];
            }
            else if ([getDeliveryResponse[@"Delivered"] isEqualToString:@"0"])
            {
                [noDelivered setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                delivered = 0;
            }
        }
        if (getDeliveryResponse[@"BirthTypeId"] != (id)[NSNull null])
        {
            if ([getDeliveryResponse[@"BirthTypeId"] isEqualToString:@"0"])
                [vaginalButton setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
            else if ([getDeliveryResponse[@"Delivered"] isEqualToString:@"1"])
                [cSectionButton setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        }
        if (getDeliveryResponse[@"ComplicationIds"] != (id)[NSNull null])
        {
            complications = [[getDeliveryResponse[@"ComplicationIds"] componentsSeparatedByString:@","] mutableCopy];
            for (NSString* tag in complications)
            {
                if ([tag isEqualToString:@"0"])
                    [complication1Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                else if ([tag isEqualToString:@"1"])
                    [complication2Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                else if ([tag isEqualToString:@"2"])
                    [complication3Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                else if ([tag isEqualToString:@"3"])
                    [complication4Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                else if ([tag isEqualToString:@"4"])
                    [complication5Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
                else if ([tag isEqualToString:@"5"])
                    [complication6Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
            }
        }
    } else if (connection == setDeliveryConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self dismissKeyboard];
            
            savedMessage.hidden = NO;
            [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 71+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            [UIView animateWithDuration:2.0f animations:^{
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            } completion:^(BOOL finished) {
                if (finished)
                    savedMessage.hidden = YES;
            }];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (IBAction)openSideSwipeView
{
    [self dismissKeyboard];
    [(MMDrawerController* )self.navigationController.topViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateFloatingViewFrame];
}

- (void)updateFloatingViewFrame {
    CGPoint contentOffset = scrollView.contentOffset;
    
    // The floating view should be at its original position or at top of
    // the visible area, whichever is lower.
    CGFloat labelY = contentOffset.y + 20;
    CGFloat buttonY = contentOffset.y + 30;
    
    CGRect labelFrame = headerLabel.frame;
    CGRect button1Frame = headerButton1.frame;
    CGRect button2Frame = headerButton2.frame;
    CGRect statusBGFrame = statusBarWhiteBG.frame;
    if (labelY != labelFrame.origin.y) {
        labelFrame.origin.y = labelY;
        button1Frame.origin.y = buttonY;
        button2Frame.origin.y = buttonY;
        statusBGFrame.origin.y = contentOffset.y;
        statusBarWhiteBG.frame = statusBGFrame;
        headerLabel.frame = labelFrame;
        headerButton1.frame = button1Frame;
        headerButton2.frame = button2Frame;
    }
    if (!savedMessage.hidden)
    {
        [savedMessage.layer removeAllAnimations];
        savedMessage.frame = CGRectMake(savedMessage.frame.origin.x, 71 + contentOffset.y,savedMessage.frame.size.width, savedMessage.frame.size.height);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            savedMessage.hidden = YES;
        });
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == nameField || textField == zipCodeField)
    {
        
    } else if (false)
    {
        
    } else if (false)
    {
        
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (false)
    {
        
    }
}

- (IBAction)saveAboutMeFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setAboutMeURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_ABOUT_ME_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&Name="] stringByAppendingString:nameField.text];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: birthday.date];
    postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:date];

    if ([zipCodeField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zipCodeField.text];
    else
        postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:@""];
    
    NSMutableURLRequest *setAboutMeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setAboutMeURL]];
    [setAboutMeRequest setHTTPMethod:@"POST"];
    [setAboutMeRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setAboutMeConnection = [[NSURLConnection alloc] initWithRequest:setAboutMeRequest delegate:self];
}

-(IBAction)cancelEditingAboutMeFields
{
    nameField.text = prevName;
    birthday.date = prevBirthdate;
    zipCodeField.text = prevZipcode;
    [nameField resignFirstResponder];
    [zipCodeField resignFirstResponder];
}

-(IBAction)savePregnantFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setPregnantURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_PREGNANCY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: dueDate.date];
    prevDueDate = dueDate.date;
    postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];

    
    NSMutableURLRequest *setPregnantRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setPregnantURL]];
    [setPregnantRequest setHTTPMethod:@"POST"];
    [setPregnantRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setPregnantConnection = [[NSURLConnection alloc] initWithRequest:setPregnantRequest delegate:self];
}


-(IBAction)cancelEditingPregnantFields
{
    isPregnant = prevIsPregnant;
    dueDate.date = prevDueDate;
}


-(IBAction)saveDeliveryFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DELIVERY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&Delivered="] stringByAppendingString:delivered ? @"1" : @"0"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: deliveryDate.date];
    prevDeliveryDate = deliveryDate.date;
    if (delivered)
        postData = [[postData stringByAppendingString:@"&DeliveryDate="] stringByAppendingString:date];
    else
        postData = [[postData stringByAppendingString:@"&DeliveryDate="] stringByAppendingString:@""];

    postData = [[postData stringByAppendingString:@"&BabyWeightPounds="] stringByAppendingString:@""];
    
    if ([babyPoundsField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&BabyWeightPounds="] stringByAppendingString:babyPoundsField.text];
    else
        postData = [[postData stringByAppendingString:@"&BabyWeightPounds="] stringByAppendingString:@""];
    if ([babyOuncesField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&BabyWeightOunces="] stringByAppendingString:babyOuncesField.text];
    else
        postData = [[postData stringByAppendingString:@"&BabyWeightOunces="] stringByAppendingString:@""];

    if ([babyInchesField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&BabyLengthInches="] stringByAppendingString:babyInchesField.text];
    else
        postData = [[postData stringByAppendingString:@"&BabyLengthInches="] stringByAppendingString:@""];
    
    if (birthTypeId >= 0)
        postData = [[postData stringByAppendingString:@"&BirthTypeId="] stringByAppendingString:[NSString stringWithFormat:@"%d", birthTypeId]];
    else
        postData = [[postData stringByAppendingString:@"&BirthTypeId="] stringByAppendingString:@""];
    if ([complications count] > 0)
    {
        NSString* complicationsString = [complications componentsJoinedByString:@","];
        postData = [[postData stringByAppendingString:@"&ComplicationIds="] stringByAppendingString:complicationsString];
    }
    else
        postData = [[postData stringByAppendingString:@"&ComplicationIds="] stringByAppendingString:@""];
    
    NSMutableURLRequest *setDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setDeliveryURL]];
    [setDeliveryRequest setHTTPMethod:@"POST"];
    [setDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeliveryConnection = [[NSURLConnection alloc] initWithRequest:setDeliveryRequest delegate:self];
}

-(IBAction)cancelEditingDeliveryFields
{
    [babyPoundsField resignFirstResponder];
    [babyOuncesField resignFirstResponder];
    [babyInchesField resignFirstResponder];
    deliveryDate.date = prevDeliveryDate;
    babyPoundsField.text = prevBabyPounds;
    babyOuncesField.text = prevBabyOunces;
    babyInchesField.text = prevBabyInches;
    [complication1Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    [complication2Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    [complication3Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    [complication4Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    [complication5Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    [complication6Button setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    for (NSString* tag in complications)
    {
        if ([tag isEqualToString:@"0"])
            [complication1Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        else if ([tag isEqualToString:@"1"])
            [complication2Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        else if ([tag isEqualToString:@"2"])
            [complication3Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        else if ([tag isEqualToString:@"3"])
            [complication4Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        else if ([tag isEqualToString:@"4"])
            [complication5Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
        else if ([tag isEqualToString:@"5"])
            [complication6Button setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
    }
    birthTypeId = prevBirthType;
    if (birthTypeId == 0)
        [cSectionButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    else
        [vaginalButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    if (survey_json == nil)
    {
        surveyController.question_number = @"1";
        surveyController.question_type = @"Multiple Choice";
    }
    else
    {
        if (extraQuestionsReached)
        {
            NSString* question_number = [NSString stringWithFormat:@"%lu", [selected_extra_answers count]+1];
            NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
            surveyController = [surveyScreens instantiateViewControllerWithIdentifier:@"SurveyQuestion"];
            NSString* type = survey_json[@"ExtraQuestions"][question_key][@"QuestionTypeDescription"];
            surveyController.question_number = question_number;
            surveyController.question_type = type;
        }
        else
        {
            surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
            surveyController.question_type = @"Multiple Choice";
        }
    }
    [self.navigationController pushViewController:surveyController animated:YES];
}

- (void)testInternetConnection
{
    Reachability* internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        internet = YES;
        offlineMessage.hidden = YES;
        headerButton2.enabled = YES;
        nameField.enabled = YES;
        zipCodeField.enabled = YES;
        babyPoundsField.enabled = YES;
        babyFeetField.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        headerButton2.enabled = NO;
        nameField.enabled = NO;
        zipCodeField.enabled = NO;
        babyPoundsField.enabled = NO;
        babyFeetField.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
}

-(IBAction)clickedIsPregnant:(UIButton*)sender
{
    isPregnant = (int) sender.tag;
    [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
    
    if (isPregnant == 1)
    {
        [noPregnantButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, 428)];
    }else
    {
        [yesPregnantButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, 132)];
        [self savePregnantFields];
    }
    if (!delivered && isPregnant)
        [self.scrollView setContentSize:CGSizeMake(320, 1100)];
    if (!delivered && !isPregnant)
        [self.scrollView setContentSize:CGSizeMake(320, 850)];
}

-(IBAction)clickedDelivered:(UIButton*)sender
{
    delivered = (int) sender.tag;
    [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
    if (delivered == 1)
    {
        pregnancyView.hidden = YES;
        [noDelivered setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y - 495, deliveredView.frame.size.width, 1042)];
        [self.scrollView setContentSize:CGSizeMake(320, 1850)];
        [self.scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - 500)];
    }else
    {
        pregnancyView.hidden = NO;
        [yesDelivered setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
        [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y+495, deliveredView.frame.size.width, 168)];
        [self.scrollView setContentSize:CGSizeMake(320, 1400)];
        [self saveDeliveryFields];
    }
}

-(IBAction)clickedBirthType:(UIButton*)sender
{
    birthTypeId = (int) sender.tag;
    prevBirthType = birthTypeId;
    [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
    if (birthTypeId == 0)
        [cSectionButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    else
        [vaginalButton setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
}

-(IBAction)clickedComplication:(UIButton*)sender
{
    NSString* tagString = [NSString stringWithFormat:@"%li",(long)sender.tag];
    if (![complications containsObject:tagString])
    {
        [complications addObject:tagString];
        [sender setImage:[UIImage imageNamed:@"babyq_circle_orange.png"] forState:UIControlStateNormal];
    }
    else
    {
        [complications removeObject:tagString];
        [sender setImage:[UIImage imageNamed:@"babyq_circle.png"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
