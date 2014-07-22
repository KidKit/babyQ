//
//  JoinViewController.m
//  babyQ
//
//  Created by Chris Wood on 6/13/14.
//  Copyright (c) 2014 babyQ. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()

@end

@implementation JoinViewController

@synthesize background,datePicker,email,fb_email,profilePicture,fb_profilePicture,cameraImage,password,zipcode,currentlyPregnantLabel,yesButton,noButton,yesLabel,noLabel,whenDueLabel,joinButton,termsCheckbox,termsLabelText,termsLabelLink,hiddenNoticeLabel;

BOOL madePregnantSelection;
BOOL isPregnant;
BOOL agreedToTerms;
UIImage* profileImage;
NSURLConnection* createAccountConnection;
NSURLConnection* facebookFinalizeConnection;
NSURLConnection* registerDeviceConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 550)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.datePicker setFrame:CGRectMake(32, 395, 240, 150)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    hiddenNoticeLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    email.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    email.delegate = self;
    password.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    password.delegate = self;
    if ([fb_email length] > 0)
    {
        email.text = fb_email;
        password.enabled = NO;
        password.placeholder = @"Facebook login: no password required.";
        
        cameraImage.hidden = YES;
        profilePicture.userInteractionEnabled = NO;
        
        NSURL *imageURL = [NSURL URLWithString:fb_profilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        profilePicture.imageView.image = image;
        
        profilePicture.imageView.layer.cornerRadius = 50.0;
        profilePicture.imageView.layer.masksToBounds = YES;
        profilePicture.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    zipcode.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    zipcode.delegate = self;
    currentlyPregnantLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    yesLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    noLabel.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:14];
    whenDueLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
    whenDueLabel.hidden = YES;
    datePicker.hidden = YES;
    [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-180)];
    [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-180, joinButton.frame.size.width, joinButton.frame.size.height)];
    [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y-180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
    [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y-180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
    [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y-180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    agreedToTerms = NO;
    madePregnantSelection = NO;
    isPregnant = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [email resignFirstResponder];
    [password resignFirstResponder];
    [zipcode resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)getPhoto
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;

    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
    profilePicture.imageView.layer.cornerRadius = 50.0;
    profilePicture.imageView.layer.masksToBounds = YES;
    profilePicture.imageView.contentMode = UIViewContentModeScaleAspectFill;
	[profilePicture setImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
    cameraImage.hidden = YES;
    //obtaining saving path
    
    //extracting image from the picker and saving it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        profileImage =  [info objectForKey:UIImagePickerControllerOriginalImage]; ;
    }
}

- (IBAction)clickedYes:(id)sender
{
    madePregnantSelection = YES;
    if (!isPregnant)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 700)];
        [yesButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal] ;
        [noButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
        whenDueLabel.hidden = NO;
        datePicker.hidden = NO;
        isPregnant = YES;
        [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height+180)];
        [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y+180, joinButton.frame.size.width, joinButton.frame.size.height)];
        [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y+180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
        [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y+180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
        [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y+180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    }
}

- (IBAction)clickedNo:(id)sender
{
    madePregnantSelection = YES;
    [noButton setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    if (isPregnant)
    {
        [self.scrollView setContentSize:CGSizeMake(320, 550)];
        whenDueLabel.hidden = YES;
        datePicker.hidden = YES;
        isPregnant = NO;
        [background setFrame:CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.size.width, background.frame.size.height-180)];
        [joinButton setFrame:CGRectMake(joinButton.frame.origin.x, joinButton.frame.origin.y-180, joinButton.frame.size.width, joinButton.frame.size.height)];
        [termsCheckbox setFrame:CGRectMake(termsCheckbox.frame.origin.x, termsCheckbox.frame.origin.y-180, termsCheckbox.frame.size.width, termsCheckbox.frame.size.height)];
        [termsLabelText setFrame:CGRectMake(termsLabelText.frame.origin.x, termsLabelText.frame.origin.y-180, termsLabelText.frame.size.width, termsLabelText.frame.size.height)];
        [termsLabelLink setFrame:CGRectMake(termsLabelLink.frame.origin.x, termsLabelLink.frame.origin.y-180, termsLabelLink.frame.size.width, termsLabelLink.frame.size.height)];
    }
}

- (IBAction)clickedTermsCheckbox:(id)sender
{
    agreedToTerms = !agreedToTerms;
    agreedToTerms ? [termsCheckbox setImage:[UIImage imageNamed:@"babyq_check_mark.png"] forState:UIControlStateNormal] :
                    [termsCheckbox setImage:[UIImage imageNamed:@"babyq_check_box.png"] forState:UIControlStateNormal];
    
}

- (IBAction)clickedTermsLink:(id)sender
{
    UIStoryboard * settingsScreens = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UIViewController* termsOfUse = [settingsScreens instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    [self.navigationController pushViewController:termsOfUse animated:YES];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateZipcode: (NSString*) zipCode {
    NSString *zipcodeRegex = @"\\d{5}(?:[-\\s]\\d{4})?$";
    NSPredicate *zipcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipcodeRegex];
    
    return [zipcodeTest evaluateWithObject:zipCode];
}

- (BOOL) validateFields
{
    if (![self validateEmail:self.email.text])
    {
        hiddenNoticeLabel.text = @"Invalid email address";
        return NO;
    }
    else if (self.password.enabled && [self.password.text length] < 6)
    {
        hiddenNoticeLabel.text = @"Password too short";
        return NO;
    }
    else if (![self validateZipcode:self.zipcode.text])
    {
        hiddenNoticeLabel.text = @"Invalid zipcode";
        return NO;
    }
    else if (!madePregnantSelection)
    {
        hiddenNoticeLabel.text = @"Tell us are you currently pregnant";
        return NO;
    }
    else if (!agreedToTerms)
    {
        hiddenNoticeLabel.text = @"You must agree to the terms & conditions";
        return NO;
    }
    return YES;
}

- (IBAction)clickedJoin
{
    NSString* em = self.email.text;
    NSString* pwd = self.password.text;
    NSString* zip = self.zipcode.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* date = [dateFormatter stringFromDate: datePicker.date];
    Constants* constants = [[Constants alloc] init];
    if (self.password.enabled)
    {
        if ([self validateFields])
        {
            NSString* joinURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.CREATE_ACCOUNT_PATH];
            NSString* postData = [[[@"Email=" stringByAppendingString:em] stringByAppendingString:@"&Password="] stringByAppendingString:pwd];
            postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zip];
            postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
            
            postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:joinURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            createAccountConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[email.text stringByAppendingString:@"_latest_photo.png"]];
            NSData *webData = UIImagePNGRepresentation(profileImage);
            [webData writeToFile:imagePath atomically:YES];
        }
    } else {
        if ([self validateFields])
        {
            NSString* api_token = [(AppDelegate *)[[UIApplication sharedApplication] delegate] api_token];
            NSString* fb_name = [(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_name];
            NSString* joinURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.FACEBOOK_FINALIZE_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:api_token] stringByAppendingString:@"&Email="] stringByAppendingString:em];
            postData = [[postData stringByAppendingString:@"&ZipCode="] stringByAppendingString:zip];
            postData = [[postData stringByAppendingString:@"&IsPregnant="] stringByAppendingString:isPregnant ? @"1" : @"0"];
            postData = [[postData stringByAppendingString:@"&DueDate="] stringByAppendingString:date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate* fb_bday = [dateFormatter dateFromString:[(AppDelegate *)[[UIApplication sharedApplication] delegate] fb_birthday]];
            if (fb_bday != nil && fb_bday != (id)[NSNull null])
            {
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* formatted_bday =  [dateFormatter stringFromDate:fb_bday];
                postData = [[postData stringByAppendingString:@"&Birthdate="] stringByAppendingString:formatted_bday];
            }
            
            if ([fb_name length] > 0)
                postData = [[postData stringByAppendingString:@"&Name="] stringByAppendingString:fb_name];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:joinURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            facebookFinalizeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if (connection == createAccountConnection || connection == facebookFinalizeConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.user_email = self.email.text;
            if ([json_dictionary[@"API TOKEN"] length] != 0)
                appDelegate.api_token = json_dictionary[@"API TOKEN"];
            
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.user_email forKey:@"babyQ_email"];
            [[NSUserDefaults standardUserDefaults] setValue:appDelegate.api_token forKey:@"babyQ_api_token"];
            
            NSString* em = self.email.text;
            Constants* constants = [[Constants alloc] init];
            NSString* registerDeviceURL = [[constants.HOST stringByAppendingString:constants.VERSION] stringByAppendingString:constants.REGISTER_DEVICE_PATH];
            NSString* postData = [[[@"ApiToken=" stringByAppendingString:appDelegate.api_token] stringByAppendingString:@"&Email="] stringByAppendingString:em];
            postData = [[postData stringByAppendingString:@"&IsActive=1&DeviceId="] stringByAppendingString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
            postData = [postData stringByAppendingString:@"&DeviceToken="];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:registerDeviceURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            registerDeviceConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            UIStoryboard * homeScreens = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
            SideSwipeTableViewController* sideSwipeTableView = [homeScreens instantiateViewControllerWithIdentifier:@"SideSwipeTableView"];
            
            CurrentScoreViewController* currentScoreView = [homeScreens instantiateViewControllerWithIdentifier:@"CurrentScoreView"];
            
            MMDrawerController * swipeController = [[MMDrawerController alloc]
                                                    initWithCenterViewController:currentScoreView
                                                    leftDrawerViewController:sideSwipeTableView
                                                    rightDrawerViewController:nil];
            [swipeController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeBezelPanningCenterView];
            [swipeController setShowsShadow:NO];
            
            [self.navigationController pushViewController:swipeController animated:YES];
        } else if ([json_dictionary[@"ERROR"] isEqualToString:@"Email Address Already In Use"])
        {
            hiddenNoticeLabel.text = @"Email Address Already In Use";
        }
    } else if (connection == registerDeviceConnection)
    {
        NSString* json_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* json_data = [json_response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json_dictionary = [NSJSONSerialization JSONObjectWithData: json_data
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: nil];
        if ([json_dictionary[@"VALID"] isEqualToString:@"Success"])
        {
            NSLog(@"Device registered");
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0f green:120.0/255.0f blue:120.0/255.0f alpha:1.0f];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"JOIN";
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
