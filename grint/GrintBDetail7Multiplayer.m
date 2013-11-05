//
//  GrintBDetail7Multiplayer.m
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//
#import "GrintBDetail7Multiplayer.h"
#import "SKPSMTPMessage.h"
#import "GrintBReviewStatsMultiplayer.h"

#import "NSData+Base64Additions.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#import "SpinnerView.h"
#import "Flurry.h"
#import "GrintScore.h"

#include <netinet/in.h>

@implementation GrintBDetail7Multiplayer
@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize score;
@synthesize putts;
@synthesize penalties;
@synthesize accuracy;
@synthesize date;
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize spinnerView;
@synthesize courseID;
@synthesize data;
@synthesize detailViewController;
@synthesize scores;
@synthesize teeID;
@synthesize attachedScorecard;
@synthesize holeOffset;
@synthesize connection;

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return nil;
}


- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    CGPoint frameOrigin = CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y+40);
    
    if (!CGRectContainsPoint(aRect, frameOrigin) ) {
        
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+20);
        
        [scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    activeField = textField;
}

- (IBAction)backToStart:(id)sender{
    
    
    NSLog(@"Start Sending");
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    
    if([attachedScorecard intValue] == 0){
        
        NSLog(@"submitting without scorecard");
        
        
        for(GrintScore* s in [self.scores objectAtIndex:0]){
            [s removeNulls];
        }
        
        NSMutableString* parameters = [NSMutableString stringWithFormat:@"username=%@&creator=%@", self.username, self.username];
        [parameters appendFormat:@"&course_id=%@", self.courseID];
        [parameters appendFormat:@"&date=%@-%@-%@", [[self.date componentsSeparatedByString:@"/"] objectAtIndex:2], [[self.date componentsSeparatedByString:@"/"] objectAtIndex:0],[[self.date componentsSeparatedByString:@"/"] objectAtIndex:1]];
        [parameters appendFormat:@"&tees=%@", self.teeID];
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&scH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).score];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&pH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).penalty];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&ptH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).putts];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&fH%d=%@", i, [[[[[[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).fairway stringByReplacingOccurrencesOfString:@"Shank" withString:@"5" ]  stringByReplacingOccurrencesOfString:@"Lo" withString:@"6" ]stringByReplacingOccurrencesOfString:@"H" withString:@"3"] stringByReplacingOccurrencesOfString:@"R" withString:@"2"]stringByReplacingOccurrencesOfString:@"L" withString:@"1"] stringByReplacingOccurrencesOfString:@"S" withString:@"4" ]];
            
        }
        
        
        if(self.leaderboardID){
            [parameters appendFormat:@"&leaderboard_id=%@", self.leaderboardID];
        }
        
        
        [parameters appendFormat:@"&nine_hole_type=%@", self.nineType];
        [parameters replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[parameters length]}];
        
        NSLog(parameters);
        
        NSMutableURLRequest* request;
        if(_isNine){
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/uploadscore_iphone_nine/"]];
        }
        else{
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/uploadscore_iphone/"]];
        }
        NSString* requestBody = parameters;
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            data = [NSMutableData data];
        }
        
    }
    
    else{
        NSLog(@"submitting with scorecard");
        
        for(GrintScore* s in [self.scores objectAtIndex:0]){
            [s removeNulls];
        }
        NSString *urlString;
        
        if(_isNine){
            urlString = @"https://www.thegrint.com/uploadscore_iphone_nine/";
        }
        else{
            urlString = @"https://www.thegrint.com/uploadscore_iphone/";
        }
        
        NSMutableDictionary* _params = [NSMutableDictionary dictionaryWithObjectsAndKeys:username, @"username", username, @"creator", self.courseID, @"course_id", [NSString stringWithFormat:@"%@-%@-%@", [[self.date componentsSeparatedByString:@"/"] objectAtIndex:2], [[self.date componentsSeparatedByString:@"/"] objectAtIndex:0],[[self.date componentsSeparatedByString:@"/"] objectAtIndex:1]], @"date", self.teeID, @"tees", self.nineType, @"nine_hole_type", nil];
        
        for(int i = 1; i <= 18; i++){
            
            [_params setObject:[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).score stringByReplacingOccurrencesOfString:@"(null)" withString:@""] forKey:[NSString stringWithFormat:@"scH%d", i]];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [_params setObject:[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).penalty stringByReplacingOccurrencesOfString:@"(null)" withString:@""]  forKey:[NSString stringWithFormat:@"pH%d", i]];
            
            
        }
        for(int i = 1; i <= 18; i++){
            
            [_params setObject:[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).putts stringByReplacingOccurrencesOfString:@"(null)" withString:@""]  forKey:[NSString stringWithFormat:@"ptH%d", i]];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [_params setObject:[[[[[[[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).fairway stringByReplacingOccurrencesOfString:@"Shank" withString:@"5" ]  stringByReplacingOccurrencesOfString:@"Lo" withString:@"6" ]stringByReplacingOccurrencesOfString:@"H" withString:@"3"] stringByReplacingOccurrencesOfString:@"R" withString:@"2"]stringByReplacingOccurrencesOfString:@"L" withString:@"1"] stringByReplacingOccurrencesOfString:@"S" withString:@"4" ] stringByReplacingOccurrencesOfString:@"(null)" withString:@""]  forKey:[NSString stringWithFormat:@"fH%d", i]];
            
            
        }
        
        if(self.leaderboardID){
            [_params setObject:self.leaderboardID forKey:@"leaderboard_id"];
            
        }
        
        NSLog([_params description]);
        
        // create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"0xKhTmLbOuNdArY";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        NSString* FileParamConstant = @"Filedata";
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // add image data
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"] ], 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set URL
        [request setURL:[NSURL URLWithString:urlString]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            data = [NSMutableData data];
        }
        
    }
    
}



- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
    [spinnerView removeSpinner];
    
    // open an alert with just an OK button
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send email"
                          
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    
    
    NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
    
}



- (void)messageSent:(SKPSMTPMessage *)message{
    
    [spinnerView removeSpinner];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    NSLog(@"delegate - message sent");
    
}


/*
 - (IBAction)backToStart:(id)sender{
 MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
 picker.mailComposeDelegate = (id)self;
 
 // Set the subject of email
 [picker setSubject:@"The GrintB - scorecard submission"];
 
 [picker setToRecipients:[NSArray arrayWithObjects:@"josetorbay@gmail.com", nil]];
 
 NSString *emailBody = [NSString stringWithFormat:@"This is an auto-generated message, please do not modify before sending!\n-------------\n\nusername: %@\ncourseName: %@\ncourseAddress: %@\nteeboxColor: %@\nscore: %@\nputts: %@\npenalties: %@\naccuracy: %@\ndate: %@\nplayer1: %@\nplayer2: %@\nplayer3: %@\nplayer4: %@", username, courseName, courseAddress, teeboxColor, score, putts, penalties, accuracy, date, player1, player2, player3, player4];
 
 [picker setMessageBody:emailBody isHTML:NO];
 
 NSString * jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
 
 UIImage* image = [UIImage imageWithContentsOfFile:jpgPath];
 
 NSData *data = UIImageJPEGRepresentation(image, 0.9);
 
 [picker addAttachmentData:data mimeType:@"image/jpg" fileName:@"CameraImage"];
 
 // Show email view
 [self presentModalViewController:picker animated:YES];
 
 }
 
 
 - (IBAction)submitFeedback:(id)sender{
 MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
 picker.mailComposeDelegate = (id)self;
 
 // Set the subject of email
 [picker setSubject:@"The GrintB - scorecard submission"];
 
 [picker setToRecipients:[NSArray arrayWithObjects:@"josetorbay@gmail.com", nil]];
 
 NSString *emailBody = [NSString stringWithFormat:@"This is an auto-generated message, please do not modify before sending!\n-------------\n\nusername: %@\ncourseName: %@\ncourseAddress: %@\nteeboxColor: %@\nscore: %@\nputts: %@\npenalties: %@\naccuracy: %@\ndate: %@\nplayer1: %@\nplayer2: %@\nplayer3: %@\nplayer4: %@", username, courseName, courseAddress, teeboxColor, score, putts, penalties, accuracy, date, player1, player2, player3, player4];
 
 emailBody = [emailBody stringByAppendingFormat:@"\nfunRating: %d\nconditionRating: %d\ncomments: %@", funRating, conditionRating, textField1.text];
 
 [picker setMessageBody:emailBody isHTML:NO];
 
 
 NSString * jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
 
 UIImage* image = [UIImage imageWithContentsOfFile:jpgPath];
 
 NSData *data = UIImageJPEGRepresentation(image, 0.9);
 
 [picker addAttachmentData:data mimeType:@"image/jpg" fileName:@"CameraImage"];
 // Show email view
 [self presentModalViewController:picker animated:YES];
 }*/

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    
    if(result == MFMailComposeResultSent){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}


- (IBAction)starClick:(id)sender{
    
    switch ([sender tag]) {
        case 1:
            funRating = 1;
            [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 2:
            funRating = 2;
            [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 3:
            funRating = 3;
            [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 4:
            funRating = 4;
            [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 5:
            funRating = 5;
            [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            break;
        case 101:
            conditionRating = 1;
            [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 102:
            conditionRating = 2;
            [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 103:
            conditionRating = 3;
            [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 104:
            conditionRating = 4;
            [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
            break;
        case 105:
            conditionRating = 5;
            [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = NSLocalizedString(@"Ready to Upload", @"Ready to Upload");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    /*  [label2 setFont:[UIFont fontWithName:@"Oswald" size:14]];
     [label3 setFont:[UIFont fontWithName:@"Oswald" size:14]];
     
     [label4 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label5 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label6 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label7 setFont:[UIFont fontWithName:@"Merriweather" size:12]];*/
    
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button2.layer setCornerRadius:5.0f];
    
    [background1.layer setCornerRadius:5.0f];
    
    funRating = 0;
    conditionRating = 0;
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
}


- (void)swipeRightDetected:(id)sender{
    
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.frame = CGRectMake(0,20,320,44);
    self.navigationController.navigationBar.hidden = NO;
    
    [label3 setText:[@"Rate " stringByAppendingString:courseName]];
    
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width,scrollView.bounds.size.height + 50);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f)animated:YES];
    
    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    
    funRating = 0;
    conditionRating = 0;
    
    textField1.text = @"";
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/courserating_iphone/"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d", self.username, [self.courseID intValue]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/courserating_iphone/"]){
        
        NSLog(responseText);
        
        if(![responseText isEqualToString:@"null"]){
            
            textField1.text = [self stringBetweenString:@"<review>" andString:@"</review>" forString:responseText];
            funRating = [[self stringBetweenString:@"<fun>" andString:@"</fun>" forString:responseText] intValue];
            conditionRating = [[self stringBetweenString:@"<shape>" andString:@"</shape>" forString:responseText] intValue];
            
            switch (funRating) {
                case 1:
                    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 4:
                    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 5:
                    [(UIButton*)[self.view viewWithTag:1] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:2] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:3] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:4] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:5] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            switch (conditionRating) {
                case 1:
                    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 4:
                    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
                    break;
                case 5:
                    [(UIButton*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:104] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            
            
        }
        
        
        
        
    }
    
        else if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/uploadscore_iphone/"] || [[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/uploadscore_iphone_nine/"])
    {
        NSLog(responseText);
     
        
        if(currentUploadIndex >= 3){
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/courserating_iphone/upload"]];
        NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&fun=%d&shape=%d&review=%@", self.username, [self.courseID intValue], funRating, conditionRating, [textField1.text stringByReplacingOccurrencesOfString:@"&" withString:@"+"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            data = [NSMutableData data];
        }
        
    }
    else{
                
        currentUploadIndex ++;
        
        NSString* currentPlayer;
        
        if(currentUploadIndex == 1){
            currentPlayer = player2;
        }
        else if(currentUploadIndex == 2){
            currentPlayer = player3;
        }
        else if(currentUploadIndex == 3){
            currentPlayer = player4;
        }
                
        NSMutableString* parameters = [NSMutableString stringWithFormat:@"username=%@&creator=%@",currentPlayer, self.username];
        [parameters appendFormat:@"&course_id=%@", self.courseID];
        [parameters appendFormat:@"&date=%@-%@-%@", [[self.date componentsSeparatedByString:@"/"] objectAtIndex:2], [[self.date componentsSeparatedByString:@"/"] objectAtIndex:0],[[self.date componentsSeparatedByString:@"/"] objectAtIndex:1]];
        [parameters appendFormat:@"&tees=%@", self.teeID];
        if([responseText rangeOfString:@"previous_upload"].location != NSNotFound){
            [parameters appendFormat:@"&previous_upload=%@", [self stringBetweenString:@"<previous_upload>" andString:@"</previous_upload>" forString:responseText]];
            [parameters appendFormat:@"&previous_upload_thumb=%@", [self stringBetweenString:@"<previous_upload_thumb>" andString:@"</previous_upload_thumb>" forString:responseText]];
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&scH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).score];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&pH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).penalty];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&ptH%d=%@", i, ((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).putts];
            
        }
        for(int i = 1; i <= 18; i++){
            
            [parameters appendFormat:@"&fH%d=%@", i, [[[[[[((GrintScore*)[[self.scores objectAtIndex:currentUploadIndex] objectAtIndex:i-1]).fairway stringByReplacingOccurrencesOfString:@"Shank" withString:@"5" ]  stringByReplacingOccurrencesOfString:@"Lo" withString:@"6" ]stringByReplacingOccurrencesOfString:@"H" withString:@"3"] stringByReplacingOccurrencesOfString:@"R" withString:@"2"]stringByReplacingOccurrencesOfString:@"L" withString:@"1"] stringByReplacingOccurrencesOfString:@"S" withString:@"4" ]];
            
        }
        
        if(self.leaderboardID){
            [parameters appendFormat:@"&leaderboard_id=%@", self.leaderboardID];
        }
        
        [parameters appendFormat:@"&nine_hole_type=%@", self.nineType];
        [parameters replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[parameters length]}];
        NSLog(parameters);
        
        NSMutableURLRequest* request;
        if(_isNine){
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/uploadscore_iphone_nine/"]];
        }
        else{
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/uploadscore_iphone/"]];
        }
        NSString* requestBody = parameters;
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            data = [NSMutableData data];
        }

        
        
    }
    
    }
    else {
        [spinnerView removeSpinner];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"resetScore"];
        
        
        [Flurry logEvent:@"playgolf_round_uploaded"];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        
        if (!self.detailViewController) {
            self.detailViewController = [[GrintBReviewStatsMultiplayer alloc] initWithNibName:@"GrintBReviewStatsMultiplayer" bundle:nil];
        }
        
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).username = self.username;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).courseName= self.courseName;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).courseAddress= self.courseAddress;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).date = self.date;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).score = self.score;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).putts = self.putts;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).penalties = self.penalties;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).accuracy = self.accuracy;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).player1 = self.player1;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).player2 = self.player2;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).player3 = self.player3;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).player4 = self.player4;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).courseID = self.courseID;
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:[self.attachedScorecard intValue]];
        ((GrintBReviewStatsMultiplayer*)self.detailViewController).isNine = self.isNine;
        
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
