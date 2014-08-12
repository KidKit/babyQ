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

@synthesize scrollView,headerLabel,statusBarWhiteBG,headerButton1,headerButton2,profilePicture,cameraImage,aboutMeView,nameField,dobField,zipCodeField,saveAboutMeButton,cancelAboutMeButton,pregnancyView,isPregnant,dueDateField,savePregnantButton,cancelPregnantButton,deliveredView,saveDeliveryButton,cancelDeliveryButton,wasDelivered,deliveryDateField,babyLengthField,babyWeightField,nameLabel,birthdayLabel,zipCodeLabel,isPregnantLabel,dueDateLabel,wasDeliveredLabel,deliveredDateLabel,babyWeightLabel,babyLengthLabel,savedMessage,offlineMessage;

BOOL internet;
NSURLConnection* getAboutMeConnection;
NSURLConnection* setAboutMeConnection;
NSURLConnection* getPregnantConnection;
NSURLConnection* setPregnantConnection;
NSURLConnection* getDeliveryConnection;
NSURLConnection* setDeliveryConnection;

NSString* prevName;
NSString* prevBirthdate;
NSString* prevZipcode;
bool prevIsPregnant;
NSString* prevDueDate;
bool prevWasDelivered;
NSString* prevDeliveryDate;
NSString* prevBabyWeight;
NSString* prevBabyLength;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self testInternetConnection];
    [self.scrollView setContentSize:CGSizeMake(320, 1150-366)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
    NSString* fb_pic = [(AppDelegate *)[UIApplication sharedApplication].delegate fb_profilePicture];
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    
    headerButton1.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    headerButton2.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    
    UIColor *color = [UIColor colorWithRed:124 green:197 blue:189 alpha:1.0f];
    nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    dobField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"mm-dd-yyyy" attributes:@{NSForegroundColorAttributeName: color}];
    zipCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip Code" attributes:@{NSForegroundColorAttributeName: color}];
    dueDateField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Due Date" attributes:@{NSForegroundColorAttributeName: color}];
    deliveryDateField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Delivery Date" attributes:@{NSForegroundColorAttributeName: color}];
    babyLengthField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Baby Length (in)" attributes:@{NSForegroundColorAttributeName: color}];
    babyWeightField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Baby Weight (oz)" attributes:@{NSForegroundColorAttributeName: color}];
    

    
    nameLabel.font = birthdayLabel.font = zipCodeLabel.font = isPregnantLabel.font = dueDateLabel.font = wasDeliveredLabel.font = deliveredDateLabel.font = babyWeightLabel.font = babyLengthLabel.font = savedMessage.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:15];
    
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
    
    NSString* getDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.GET_DELIVERY_PATH];
    postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    NSMutableURLRequest *getDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getDeliveryURL]];
    [getDeliveryRequest setHTTPMethod:@"POST"];
    [getDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    getDeliveryConnection = [[NSURLConnection alloc] initWithRequest:getDeliveryRequest delegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    isPregnant.transform = CGAffineTransformMakeScale(0.9, 0.9);
    wasDelivered.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [nameField resignFirstResponder];
    [dobField resignFirstResponder];
    [zipCodeField resignFirstResponder];
    [dueDateField resignFirstResponder];
    [deliveryDateField resignFirstResponder];
    [babyWeightField resignFirstResponder];
    [babyLengthField resignFirstResponder];
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
        
        NSArray* dobSplit = [json_dictionary[@"Birthdate"] componentsSeparatedByString:@" "];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* birthdate = [dateFormatter dateFromString:dobSplit[0]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString* formatted_birthdate = [dateFormatter stringFromDate:birthdate];
        
        dobField.text = formatted_birthdate;
        prevBirthdate = formatted_birthdate;
        
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
            [UIView animateWithDuration:0.5f animations:^{
                [aboutMeView setFrame:CGRectMake(aboutMeView.frame.origin.x, aboutMeView.frame.origin.y, aboutMeView.frame.size.width, aboutMeView.frame.size.height - 75)];
            }];
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
        NSDate* dueDate = [dateFormatter dateFromString:dueDateSplit[0]];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSString* formatted_dueDate = [dateFormatter stringFromDate:dueDate];
        
        dueDateField.text = formatted_dueDate;
        if ([(NSDate*)[dueDate dateByAddingTimeInterval:-60*60*24*14] compare:[NSDate date] ] == NSOrderedAscending )
        {
            deliveredView.hidden = NO;
            [self.scrollView setContentSize:CGSizeMake(320, 1230)];
        }
        else
            deliveredView.hidden = YES;
        
        if ([getPregnantResponse[@"IsPregnant"] isEqualToString:@"1"])
        {
            isPregnant.on = YES;
            prevIsPregnant = YES;
        }
        else
        {
            isPregnant.on = NO;
            prevIsPregnant = NO;
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
            [UIView animateWithDuration:0.5f animations:^{
                [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, pregnancyView.frame.size.height - 75)];
            }];
            
            savedMessage.hidden = NO;
            [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, 71+scrollView.contentOffset.y, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            [UIView animateWithDuration:2.0f animations:^{
                [savedMessage setFrame:CGRectMake(savedMessage.frame.origin.x, savedMessage.frame.origin.y-38, savedMessage.frame.size.width, savedMessage.frame.size.height)];
            } completion:^(BOOL finished) {
                if (finished)
                    savedMessage.hidden = YES;
            }];
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
        {
            babyLengthField.text = getDeliveryResponse[@"BabyLengthInches"];
            prevBabyLength = getDeliveryResponse[@"BabyLengthInches"];
        }
        if (getDeliveryResponse[@"BabyWeightOunces"] != (id)[NSNull null])
        {
            babyWeightField.text = getDeliveryResponse[@"BabyWeightOunces"];
            prevBabyWeight = getDeliveryResponse[@"BabyWeightOunces"];
        }
        if (getDeliveryResponse[@"DeliveryDate"] != (id)[NSNull null])
        {
            NSArray* deliveryDateSplit = [getDeliveryResponse[@"DeliveryDate"] componentsSeparatedByString:@" "];
            deliveryDateField.text = deliveryDateSplit[0];
            prevDeliveryDate = deliveryDateSplit[0];
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
            [UIView animateWithDuration:0.5f animations:^{
                [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y, deliveredView.frame.size.width, deliveredView.frame.size.height - 75)];
                
            }];
            
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == nameField || textField == dobField || textField == zipCodeField)
    {
        if (aboutMeView.frame.size.height < 300)
        {
            [UIView animateWithDuration:0.5f animations:^{
                [aboutMeView setFrame:CGRectMake(aboutMeView.frame.origin.x, aboutMeView.frame.origin.y, aboutMeView.frame.size.width, aboutMeView.frame.size.height + 75)];
                [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y+75, pregnancyView.frame.size.width, pregnancyView.frame.size.height)];
            }];
        }
    } else if (textField == dueDateField)
    {
        if (pregnancyView.frame.size.height < 250)
        {
            [UIView animateWithDuration:0.5f animations:^{
                [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, pregnancyView.frame.size.height + 75)];
            }];
        }
        [UIView animateWithDuration:0.5f animations:^{
            [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y-75, pregnancyView.frame.size.width, pregnancyView.frame.size.height)];
            [aboutMeView setFrame:CGRectMake(aboutMeView.frame.origin.x, aboutMeView.frame.origin.y-75, aboutMeView.frame.size.width, aboutMeView.frame.size.height)];
            [profilePicture setFrame:CGRectMake(profilePicture.frame.origin.x, profilePicture.frame.origin.y-75, profilePicture.frame.size.width, profilePicture.frame.size.height)];
        }];
    } else if (textField == deliveryDateField || textField == babyWeightField || textField == babyLengthField)
        if (deliveredView.frame.size.height < 400)
        {
            [UIView animateWithDuration:0.5f animations:^{
                [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y-75, deliveredView.frame.size.width, deliveredView.frame.size.height + 75)];
            }];
        }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == dueDateField)
    {
        if (pregnancyView.frame.size.height < 300)
        {
            [UIView animateWithDuration:0.5f animations:^{
                [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y+75, pregnancyView.frame.size.width, pregnancyView.frame.size.height)];
                [aboutMeView setFrame:CGRectMake(aboutMeView.frame.origin.x, aboutMeView.frame.origin.y+75, aboutMeView.frame.size.width, aboutMeView.frame.size.height)];
                [profilePicture setFrame:CGRectMake(profilePicture.frame.origin.x, profilePicture.frame.origin.y+75, profilePicture.frame.size.width, profilePicture.frame.size.height)];
            }];
        }
    } else if (textField == deliveryDateField || textField == babyWeightField || textField == babyLengthField)
    {
        if (deliveredView.frame.size.height < 400)
        {
            [UIView animateWithDuration:0.5f animations:^{
                [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y+75, deliveredView.frame.size.width, deliveredView.frame.size.height)];
            }];
        }
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
    
    if ([dobField.text length] > 0 )
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate* birthdate = [dateFormatter dateFromString:dobField.text];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* formatted_birthdate = [dateFormatter stringFromDate:birthdate];
        postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:formatted_birthdate];
    }
    else
        postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:@""
                    ];
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
    dobField.text = prevBirthdate;
    zipCodeField.text = prevZipcode;
    [nameField resignFirstResponder];
    [dobField resignFirstResponder];
    [zipCodeField resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        [aboutMeView setFrame:CGRectMake(aboutMeView.frame.origin.x, aboutMeView.frame.origin.y, aboutMeView.frame.size.width, aboutMeView.frame.size.height - 75)];
        [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y-75, pregnancyView.frame.size.width, pregnancyView.frame.size.height)];
    }];
}

-(IBAction)savePregnantFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setPregnantURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_PREGNANCY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant.on ? @"1" : @"0"];
    
    if ([dueDateField.text length] > 0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate* dueDate = [dateFormatter dateFromString:dueDateField.text];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* formatted_dueDate = [dateFormatter stringFromDate:dueDate];
        postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:formatted_dueDate];
    }
    else
        postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:@""];
    
    NSMutableURLRequest *setPregnantRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setPregnantURL]];
    [setPregnantRequest setHTTPMethod:@"POST"];
    [setPregnantRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setPregnantConnection = [[NSURLConnection alloc] initWithRequest:setPregnantRequest delegate:self];
}


-(IBAction)cancelEditingPregnantFields
{
    isPregnant.on = prevIsPregnant;
    dueDateField.text = prevDueDate;
    [dueDateField resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        [pregnancyView setFrame:CGRectMake(pregnancyView.frame.origin.x, pregnancyView.frame.origin.y, pregnancyView.frame.size.width, pregnancyView.frame.size.height - 75)];
    }];
}


-(IBAction)saveDeliveryFields
{
    NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
    NSString* user_email = [(AppDelegate *)[[UIApplication sharedApplication] delegate] user_email];
    Constants* constants = [[Constants alloc] init];
    NSString* setDeliveryURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.SET_DELIVERY_PATH];
    NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:user_email];
    postData = [[postData stringByAppendingString:@"&Delivered="] stringByAppendingString:wasDelivered.on ? @"1" : @"0"];
    if ([deliveryDateField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&DeliveryDate="] stringByAppendingString:deliveryDateField.text];
    else
        postData = [[postData stringByAppendingString:@"&DeliveryDate="] stringByAppendingString:@""];
    postData = [[postData stringByAppendingString:@"&BabyWeightPounds="] stringByAppendingString:@""];
    if ([babyWeightField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&BabyWeightOunces="] stringByAppendingString:babyWeightField.text];
    else
        postData = [[postData stringByAppendingString:@"&BabyWeightOunces="] stringByAppendingString:@""];
    if ([babyLengthField.text length] > 0)
        postData = [[postData stringByAppendingString:@"&BabyLengthInches="] stringByAppendingString:babyLengthField.text];
    else
        postData = [[postData stringByAppendingString:@"&BabyLengthInches="] stringByAppendingString:@""];
    postData = [[postData stringByAppendingString:@"&BirthTypeId="] stringByAppendingString:@""];
    postData = [[postData stringByAppendingString:@"&ComplicationIds="] stringByAppendingString:@""];
    NSMutableURLRequest *setDeliveryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:setDeliveryURL]];
    [setDeliveryRequest setHTTPMethod:@"POST"];
    [setDeliveryRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    setDeliveryConnection = [[NSURLConnection alloc] initWithRequest:setDeliveryRequest delegate:self];
}

-(IBAction)cancelEditingDeliveryFields
{
    wasDelivered.on = prevWasDelivered;
    deliveryDateField.text = prevDeliveryDate;
    babyLengthField.text = prevBabyLength;
    babyWeightField.text = prevBabyWeight;
    [deliveryDateField resignFirstResponder];
    [babyWeightField resignFirstResponder];
    [babyLengthField resignFirstResponder];
    [UIView animateWithDuration:0.5f animations:^{
        [deliveredView setFrame:CGRectMake(deliveredView.frame.origin.x, deliveredView.frame.origin.y, deliveredView.frame.size.width, deliveredView.frame.size.height - 75)];
    }];
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
        dobField.enabled = YES;
        zipCodeField.enabled = YES;
        isPregnant.enabled = YES;
        dueDateField.enabled = YES;
        wasDelivered.enabled = YES;
        deliveryDateField.enabled = YES;
        babyLengthField.enabled = YES;
        babyWeightField.enabled = YES;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        internet = NO;
        offlineMessage.hidden = NO;
        headerButton2.enabled = NO;
        nameField.enabled = NO;
        dobField.enabled = NO;
        zipCodeField.enabled = NO;
        isPregnant.enabled = NO;
        dueDateField.enabled = NO;
        wasDelivered.enabled = NO;
        deliveryDateField.enabled = NO;
        babyLengthField.enabled = NO;
        babyWeightField.enabled = NO;
    };
    
    [internetReachableFoo startNotifier];
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
