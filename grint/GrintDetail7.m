//
//  GrintDetail7.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintDetail7.h"
#import "SKPSMTPMessage.h"

#import "NSData+Base64Additions.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#import "SpinnerView.h"
#import "GrintSocialViewController.h"
#import "Flurry.h"
#include <netinet/in.h>

@implementation GrintDetail7
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
@synthesize data, connection;


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


- (IBAction)    FieldShouldReturn:(UITextField *)theTextField {
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
    
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
    
    
    
    NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
    
 /*   SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    
    testMsg.fromEmail = @"grintapp@gmail.com";
    
    testMsg.toEmail = @"scores@thegrint.com";
 //   testMsg.toEmail = @"peter.rocker@gmail.com";
    
    testMsg.relayHost = @"smtp.gmail.com";
    
    testMsg.requiresAuth = YES;
    
    testMsg.login = @"grintapp@gmail.com";
    
    testMsg.pass = @"scorecard1";
    
    testMsg.subject = @"The Grint - scorecard submission";
    
    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    // Only do this for self-signed certs!
    
    // testMsg.validateSSLChain = NO;
    
    testMsg.delegate = self;
    
    NSString *emailBody = [NSString stringWithFormat:@"This is an auto-generated message, please do not modify before sending!\n-------------\n\nusername: %@\ncourseName: %@\ncourseAddress: %@\nteeboxColor: %@\nscore: %@\nputts: %@\npenalties: %@\naccuracy: %@\ndate: %@\nplayer1: %@\nplayer2: %@\nplayer3: %@\nplayer4: %@", username, courseName, courseAddress, teeboxColor, score, putts, penalties, accuracy, date, player1, player2, player3, player4];
    
  //  emailBody = [emailBody stringByAppendingFormat:@"\nfunRating: %d\nconditionRating: %d\ncomments: %@", funRating, conditionRating, textField1.text];

    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               
                               emailBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"scorecard.jpg\"",kSKPSMTPPartContentTypeKey,
                             
                             @"attachment;\r\n\tfilename=\"scorecard.jpg\"",kSKPSMTPPartContentDispositionKey,[dataObj encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,
                
                     vcfPart,
                     
                     nil];
    
    [testMsg send];*/
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/courserating_iphone/upload"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&fun=%d&shape=%d&review=%@", self.username, [self.courseID intValue], funRating, conditionRating, [textField1.text stringByReplacingOccurrencesOfString:@"&" withString:@"+"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
    }
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
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
    [picker setSubject:@"The Grint - scorecard submission"];
    
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
    [picker setSubject:@"The Grint - scorecard submission"];
    
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
        
         [[[UIAlertView alloc] initWithTitle:@"Scorecard Submitted"
                                       message:@"Your Scorecard is in our hands. We will process it shortly, you will receive an email when ready"
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                             otherButtonTitles:nil] show];
        
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
    //    [[self navigationItem] setHidesBackButton:YES];
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

   /* [label2 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
        [label4 setFont:[UIFont fontWithName:@"Oswald" size:12]];
        [label5 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:12]];*/
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
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

- (IBAction)shareClick:(id)sender{
       
    GrintSocialViewController* controller = [[GrintSocialViewController alloc] initWithNibName:@"GrintSocialViewController" bundle:nil];
    controller.delegate = self;
    controller.tweetText = [NSString stringWithFormat:@"I just finished a great round at %@", courseName];
     controller.tweetImage = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]];
    
    [self presentModalViewController:controller animated:YES];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
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
        else{
            NSLog(responseText);
        }
        
        
        
    }
    else if ([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/courserating_iphone/upload"]){
        
        NSLog(@"back from uploading course rating");
        
        NSString *urlString = @"https://www.thegrint.com/iphone_scorecard_upload/";
        
        // set up the form keys and values (revise using 1 NSDictionary at some point - neater than 2 arrays)
       
         NSString *emailBody = [NSString stringWithFormat:@"<BR>username: %@<BR>courseName: %@<BR>courseAddress: %@<BR>teeboxColor: %@<BR>score: %@<BR>putts: %@<BR>penalties: %@<BR>accuracy: %@<BR>date: %@<BR>player1: %@<BR>player2: %@<BR>player3: %@<BR>player4: %@", username, courseName, courseAddress, teeboxColor, score, putts, penalties, accuracy, date, player1, player2, player3, player4];
        
        NSDictionary* _params = [NSDictionary dictionaryWithObjectsAndKeys:emailBody, @"message", username, @"username", nil];
        
        // create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"0xKhTmLbOuNdArY";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        NSString* FileParamConstant = @"file";
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
    else{
        
        NSLog(@"back from uploading scorecard");

        [Flurry logEvent:@"scorecard_pic_uploaded"];
        
        [spinnerView removeSpinner];
        [[[UIAlertView alloc] initWithTitle:@"Scorecard Submitted"
                                    message:@"Your Scorecard is in our hands. We will process it shortly, you will receive an email when ready"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                          otherButtonTitles:nil] show];

        [self.navigationController popToRootViewControllerAnimated:YES];
        

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
