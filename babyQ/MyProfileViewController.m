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

@synthesize scrollView,profilePicture,cameraImage,nameField,dobField,zipCodeField,editAboutMeButton,saveAboutMeButton,cancelAboutMeButton,isPregnant,dueDateField,editPregnantButton,savePregnantButton,cancelPregnantButton,editDeliveryButton,saveDeliveryButton,cancelDeliveryButton,wasDelivered,deliveryDateField,babyLengthField,babyWeightField;

NSURLConnection* getAboutMeConnection;
NSURLConnection* setAboutMeConnection;
NSURLConnection* getPregnantConnection;
NSURLConnection* setPregnantConnection;
NSURLConnection* getDeliveryConnection;
NSURLConnection* setDeliveryConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 1230)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    NSString* fb_pic = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_profilePicture];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    
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
            cameraImage.hidden = YES;
            UIImage* picImage = [UIImage imageWithData:picData];
            [profilePicture setImage:picImage forState:UIControlStateNormal];
        }
    }
    saveAboutMeButton.hidden = YES;
    cancelAboutMeButton.hidden = YES;
    savePregnantButton.hidden = YES;
    cancelPregnantButton.hidden = YES;
    saveDeliveryButton.hidden = YES;
    cancelDeliveryButton.hidden = YES;
    
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
    
    NSString* getDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DELIVERY_PATH];
    postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *getDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getDeliveryURL]];
    [getDeliveryRequest setHTTPMethod:@"POST"];
    [getDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getDeliveryConnection = [[NSURLConnection alloc] initWithRequest:getDeliveryRequest delegate:self];
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
        cameraImage.hidden = YES;
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
        NSArray* dobSplit = [json_dictionary[@"Birthdate"] componentsSeparatedByString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* birthdate = [dateFormatter dateFromString:dobSplit[0]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString* formatted_birthdate = [dateFormatter stringFromDate:birthdate];
        
        dobField.text = formatted_birthdate;
        
        zipCodeField.text = json_dictionary[@"ZipCode"];
    } else if (connection == setAboutMeConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self cancelEditingAboutMeFields];
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
        NSDate* dueDate = [dateFormatter dateFromString:dueDateSplit[0]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString* formatted_dueDate = [dateFormatter stringFromDate:dueDate];
        
        dueDateField.text = formatted_dueDate;
        
        if ([getPregnantResponse[@"IsPregnant"] isEqualToString:@"1"])
            isPregnant.on = YES;
        else
            isPregnant.on = NO;
    } else if (connection == setPregnantConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* setCompletedResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([setCompletedResponse[@"VALID"] isEqualToString:@"Success"])
        {
            [self cancelEditingPregnantFields];
        }
    } else if (connection == getDeliveryConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary* getDeliveryResponse = [NSJSONSerialization JSONObjectWithData: json_data
                                                                             options: NSJSONReadingMutableContainers
                                                                               error: nil];
        if ([getDeliveryResponse[@"Delivered"] isEqualToString:@"1"])
            wasDelivered.on = YES;
        else
            wasDelivered.on = NO;
        if (getDeliveryResponse[@"BabyLengthInches"] != (id)[NSNull null])
            babyLengthField.text = getDeliveryResponse[@"BabyLengthInches"];
        if (getDeliveryResponse[@"BabyWeightOunces"] != (id)[NSNull null])
            babyWeightField.text = getDeliveryResponse[@"BabyWeightOunces"];
        if (getDeliveryResponse[@"DeliveryDate"] != (id)[NSNull null])
        {
            NSArray* deliveryDateSplit = [getDeliveryResponse[@"DeliveryDate"] componentsSeparatedByString:@" "];
            deliveryDateField.text = deliveryDateSplit[0];
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
            [self cancelEditingDeliveryFields];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate* birthdate = [dateFormatter dateFromString:dobField.text];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* formatted_birthdate = [dateFormatter stringFromDate:birthdate];
    
    postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:formatted_birthdate];
    postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zipCodeField.text];
    NSMutableURLRequest *setAboutMeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setAboutMeURL]];
    [setAboutMeRequest setHTTPMethod:@"POST"];
    [setAboutMeRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setAboutMeConnection = [[NSURLConnection alloc] initWithRequest:setAboutMeRequest delegate:self];
}

-(IBAction)cancelEditingAboutMeFields
{
    editAboutMeButton.enabled = YES;
    saveAboutMeButton.hidden = YES;
    cancelAboutMeButton.hidden = YES;
    nameField.userInteractionEnabled = NO;
    dobField.userInteractionEnabled = NO;
    zipCodeField.userInteractionEnabled = NO;
}

-(IBAction)editAboutMeFields
{
    editAboutMeButton.enabled = NO;
    saveAboutMeButton.hidden = NO;
    cancelAboutMeButton.hidden = NO;
    nameField.userInteractionEnabled = YES;
    dobField.userInteractionEnabled = YES;
    zipCodeField.userInteractionEnabled = YES;
    
}

-(IBAction)savePregnantFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setPregnantURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_PREGNANCY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant.on ? @"1" : @"0"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate* dueDate = [dateFormatter dateFromString:dueDateField.text];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* formatted_dueDate = [dateFormatter stringFromDate:dueDate];
    
    postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:formatted_dueDate];
    NSMutableURLRequest *setPregnantRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setPregnantURL]];
    [setPregnantRequest setHTTPMethod:@"POST"];
    [setPregnantRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setPregnantConnection = [[NSURLConnection alloc] initWithRequest:setPregnantRequest delegate:self];
}

-(IBAction)editPregnantFields
{
    editPregnantButton.enabled = NO;
    savePregnantButton.hidden = NO;
    cancelPregnantButton.hidden = NO;
    isPregnant.userInteractionEnabled = YES;
    dueDateField.userInteractionEnabled = YES;
}

-(IBAction)cancelEditingPregnantFields
{
    editPregnantButton.enabled = YES;
    savePregnantButton.hidden = YES;
    cancelPregnantButton.hidden = YES;
    isPregnant.userInteractionEnabled = NO;
    dueDateField.userInteractionEnabled = NO;
}

-(IBAction)editDeliveryFields
{
    editDeliveryButton.enabled = NO;
    saveDeliveryButton.hidden = NO;
    cancelDeliveryButton.hidden = NO;
    wasDelivered.userInteractionEnabled = YES;
    deliveryDateField.userInteractionEnabled = YES;
    babyWeightField.userInteractionEnabled = YES;
    babyLengthField.userInteractionEnabled = YES;
}

-(IBAction)saveDeliveryFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DELIVERY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&Delivered="] stringByAppendingString:wasDelivered.on ? @"1" : @"0"];
    postData = [[postData stringByAppendingString:@"&DeliveryDate="] stringByAppendingString:deliveryDateField.text];
    postData = [[postData stringByAppendingString:@"&BabyWeightPounds="] stringByAppendingString:@""];
    postData = [[postData stringByAppendingString:@"&BabyWeightOunces="] stringByAppendingString:babyWeightField.text];
    postData = [[postData stringByAppendingString:@"&BabyLengthInches="] stringByAppendingString:babyLengthField.text];
    postData = [[postData stringByAppendingString:@"&BirthTypeId="] stringByAppendingString:@""];
    postData = [[postData stringByAppendingString:@"&ComplicationIds="] stringByAppendingString:@""];
    NSMutableURLRequest *setDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setDeliveryURL]];
    [setDeliveryRequest setHTTPMethod:@"POST"];
    [setDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeliveryConnection = [[NSURLConnection alloc] initWithRequest:setDeliveryRequest delegate:self];
}

-(IBAction)cancelEditingDeliveryFields
{
    editDeliveryButton.enabled = YES;
    saveDeliveryButton.hidden = YES;
    cancelDeliveryButton.hidden = YES;
    wasDelivered.userInteractionEnabled = NO;
    deliveryDateField.userInteractionEnabled = NO;
    babyWeightField.userInteractionEnabled = NO;
    babyLengthField.userInteractionEnabled = NO;
}

- (IBAction)startSurvey
{
    UIStoryboard* surveyScreens = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    SurveyViewController* surveyController = [surveyScreens instantiateInitialViewController];
    if (survey_json == nil)
        surveyController.question_number = @"1";
    else
    {
        if (extraQuestionsReached)
        {
            NSString* question_number = [NSString stringWithFormat:@"%lu", [selected_extra_answers count]+1];
            NSString* question_key = [[survey_json[@"ExtraQuestions"] allKeys] objectAtIndex:([question_number intValue]-1)];
            NSString* type = survey_json[@"ExtraQuestions"][question_key][@"QuestionTypeDescription"];
            surveyController = [surveyScreens instantiateViewControllerWithIdentifier:type];
            surveyController.question_number = question_number;
            surveyController.question_type = type;
        }
        else
            surveyController.question_number = [NSString stringWithFormat:@"%lu", [selected_answers count] + 1];
    }
    [self.navigationController pushViewController:surveyController animated:YES];
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
