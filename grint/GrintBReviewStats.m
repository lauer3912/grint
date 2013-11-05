//
//  GrintBReviewStats.m
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBReviewStats.h"
#import "GrintBDetail7.h"
#import <MessageUI/MessageUI.h>
#import "GrintAppDelegate.h"
#import "GrintSocialViewController.h"

@implementation GrintBReviewStats

@synthesize detailViewController = _detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize score;
@synthesize putts;
@synthesize penalties;
@synthesize accuracy;
@synthesize date;
@synthesize courseID;
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize data;
@synthesize attachedScorecard;
@synthesize connection;
@synthesize spinnerView;

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
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    if([[connection.originalRequest.URL description]rangeOfString: @"coursestats_iphone"].location != NSNotFound){
                
        labelAvgScoreToday.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_today>" andString:@"</avgscore_today>" forString:responseText]floatValue]];
        labelAvgPuttsToday.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_today>" andString:@"</avgputts_today>" forString:responseText]floatValue]];
        labelAvgPenaltyToday.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_today>" andString:@"</avgpenalty_today>" forString:responseText]floatValue]];
        labelTeeAccuracyToday.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_today>" andString:@"</teeaccuracy_today>" forString:responseText]floatValue])];
        labelAvgGirToday.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_today>" andString:@"</avggir_today>" forString:responseText]floatValue])];
        labelGrintsToday.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_today>" andString:@"</grints_today>" forString:responseText]floatValue])];
        
        labelAvgScoreCourse.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_course>" andString:@"</avgscore_course>" forString:responseText]floatValue]];
        labelAvgPuttsCourse.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_course>" andString:@"</avgputts_course>" forString:responseText]floatValue]];
        labelAvgPenaltyCourse.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_course>" andString:@"</avgpenalty_course>" forString:responseText]floatValue]];
        labelTeeAccuracyCourse.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_course>" andString:@"</teeaccuracy_course>" forString:responseText]floatValue])];
        labelAvgGirCourse.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_course>" andString:@"</avggir_course>" forString:responseText]floatValue])];
        labelGrintsCourse.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_course>" andString:@"</grints_course>" forString:responseText]floatValue])];
        
        labelAvgScoreHistorical.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_historic>" andString:@"</avgscore_historic>" forString:responseText]floatValue]];
        labelAvgPuttsHistorical.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_historic>" andString:@"</avgputts_historic>" forString:responseText]floatValue]];
        labelAvgPenaltyHistorical.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_historic>" andString:@"</avgpenalty_historic>" forString:responseText]floatValue]];
        labelTeeAccuracyHistorical.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_historic>" andString:@"</teeaccuracy_historic>" forString:responseText]floatValue])];
        labelAvgGirHistorical.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_historic>" andString:@"</avggir_historic>" forString:responseText]floatValue])];
        labelGrintsHistorical.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_historic>" andString:@"</grints_historic>" forString:responseText]floatValue])];
             
    }
}


-(IBAction)nextScreen:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults]integerForKey:@"number_times_uploaded"] +1 forKey:@"number_times_uploaded"];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
   /* UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintBDetail7 alloc] initWithNibName:@"GrintBDetail7" bundle:nil];
    }
        
    ((GrintBDetail7*)self.detailViewController).username = self.username;
    ((GrintBDetail7*)self.detailViewController).courseName= self.courseName;
    ((GrintBDetail7*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintBDetail7*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintBDetail7*)self.detailViewController).date = self.date;
    ((GrintBDetail7*)self.detailViewController).score = self.score;
    ((GrintBDetail7*)self.detailViewController).putts = self.putts;
    ((GrintBDetail7*)self.detailViewController).penalties = self.penalties;
    ((GrintBDetail7*)self.detailViewController).accuracy = self.accuracy;
    ((GrintBDetail7*)self.detailViewController).player1 = self.player1;
    ((GrintBDetail7*)self.detailViewController).player2 = self.player2;
    ((GrintBDetail7*)self.detailViewController).player3 = self.player3;
    ((GrintBDetail7*)self.detailViewController).player4 = self.player4;
    ((GrintBDetail7*)self.detailViewController).courseID = self.courseID;
    
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    */
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[self navigationItem] setHidesBackButton:YES];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
        
  //  [labelCourseName setText:self.courseName];
    
    [labelCourseName setFont:[UIFont fontWithName:@"Oswald" size:18]];
  
    if(!spinnerView)
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];

    NSMutableURLRequest* request;
    
    if(_isNine){
       request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone_nine"]];
    }
    else{
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone"]];
    }
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d", self.username, [self.courseID intValue]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
    }

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"savedState"];
    [defaults synchronize];
    
}

- (void) postImageToFB:(UIImage*)image withDescription:(NSString*)description
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData* imageData = UIImageJPEGRepresentation(image, 90);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    description, @"message",
                                    imageData, @"source",
                                    nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              NSLog(@"%@", [error description]);
                              
                              if(!error){
                                  
                                  [[[UIAlertView alloc]initWithTitle:@"Posted!" message:@"your stats have been posted to your wall" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                  
                                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              }
                              
                          }];
}

- (IBAction)shareClick:(id)sender{
    
    NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %.0f at %@. ",[labelAvgScoreToday.text floatValue], courseName];
    
    bool addedI = NO;
    
    if ([putts isEqualToString:@"YES"]) {
        [tweetText appendFormat:@" I made %.0f putts", [labelAvgPuttsToday.text floatValue]];
        addedI = YES;
    }
    
    if([putts isEqualToString:@"YES"]){
        if(!addedI){
            [tweetText appendString:@" I "];
            addedI = YES;
        }
        else{
            [tweetText appendString:@", "];
        }
        [tweetText appendFormat:@"hit %@%% of greens", labelAvgGirToday.text];
        
    }
    
    if([accuracy isEqualToString:@"YES"]){
        if(!addedI){
            [tweetText appendString:@" I hit "];
            addedI = YES;
        }
        else{
            [tweetText appendString:@" and "];
        }
        [tweetText appendFormat:@"%@%% of tee shots", labelTeeAccuracyToday.text];
        
    }
    
    GrintSocialViewController* controller = [[GrintSocialViewController alloc] initWithNibName:@"GrintSocialViewController" bundle:nil];
    controller.delegate = self;
    controller.tweetText = tweetText;
    
    if([attachedScorecard intValue] == 1){
        
        controller.tweetImage = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]];
    }
    else{
        
        controller.tweetImage = [UIImage imageNamed:@"grint_logo.png"];
        
    }
    
    [self presentModalViewController:controller animated:YES];
    
}

- (IBAction)openSession:(id)sender
{
    GrintAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.fbDelegate = self;
    
    [appDelegate openSession];
}

- (IBAction)facebookScore:(id)sender{

    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error)
         {
             // If permissions granted, publish the story
             if (!error) [self facebookScore:self];
         }];
    }
    // If permissions present, publish the story
    else {
    
    
    NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %.0f at %@. ",[labelAvgScoreToday.text floatValue], courseName];
    
    bool addedI = NO;
    
    if ([putts isEqualToString:@"YES"]) {
        [tweetText appendFormat:@" I made %.0f putts", [labelAvgPuttsToday.text floatValue]];
        addedI = YES;
    }
    
    if([putts isEqualToString:@"YES"]){
        if(!addedI){
            [tweetText appendString:@" I "];
            addedI = YES;
        }
        else{
            [tweetText appendString:@", "];
        }
        [tweetText appendFormat:@"hit %@%% of greens", labelAvgGirToday.text];
        
    }
    
    if([accuracy isEqualToString:@"YES"]){
        if(!addedI){
            [tweetText appendString:@" I hit "];
            addedI = YES;
        }
        else{
            [tweetText appendString:@" and "];
        }
        [tweetText appendFormat:@"%@%% of tee shots", labelTeeAccuracyToday.text];
        
    }

    if([attachedScorecard intValue] == 1){
        
          [self postImageToFB:[UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]] withDescription:tweetText];
    }
    else{
        
        [self postImageToFB:[UIImage imageNamed:@"grint_logo.png"] withDescription:tweetText];

    }
    }
    /*
    
    
if(NSClassFromString(@"SLComposeViewController")){
    
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }};
        
        NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %.0f at %@. ",[labelAvgScoreToday.text floatValue], courseName];
        
        bool addedI = NO;
        
        if ([putts isEqualToString:@"YES"]) {
            [tweetText appendFormat:@" I made %.0f putts", [labelAvgPuttsToday.text floatValue]];
            addedI = YES;
        }
        
        if([putts isEqualToString:@"YES"]){
            if(!addedI){
                [tweetText appendString:@" I "];
                addedI = YES;
            }
            else{
                [tweetText appendString:@", "];
            }
            [tweetText appendFormat:@"hit %@%% of greens", labelAvgGirToday.text];
            
        }
        
        if([accuracy isEqualToString:@"YES"]){
            if(!addedI){
                [tweetText appendString:@" I hit "];
                addedI = YES;
            }
            else{
                [tweetText appendString:@" and "];
            }
            [tweetText appendFormat:@"%@%% of tee shots", labelTeeAccuracyToday.text];
            
        }
        
        [fbController setInitialText:tweetText];
        
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }//}

else{
    [[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Facebook posting only available from iOS 6+" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

     */


}

- (IBAction)tweetScore:(id)sender{
    
 /*   if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        
        NSString* tempCourse;
        
        if(courseName.length > 45){
            tempCourse = [[courseName substringToIndex:45] stringByAppendingString:@"..."];
        }
        else{
            tempCourse = courseName;
        }
        
        NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %.0f at %@. ",[labelAvgScoreToday.text floatValue], tempCourse];
        
        bool addedI = NO;
        
        if ([putts isEqualToString:@"YES"]) {
            [tweetText appendFormat:@" I made %.0f putts", [labelAvgPuttsToday.text floatValue]];
            addedI = YES;
        }
        
        if([putts isEqualToString:@"YES"]){
            if(!addedI){
                [tweetText appendString:@" I "];
                addedI = YES;
            }
            else{
                [tweetText appendString:@", "];
            }
            [tweetText appendFormat:@"hit %@%% of greens", labelAvgGirToday.text];
        
        }
        
        if([accuracy isEqualToString:@"YES"]){
            if(!addedI){
                [tweetText appendString:@" I hit "];
                addedI = YES;
            }
            else{
                [tweetText appendString:@" and "];
            }
            [tweetText appendFormat:@"%@%% of tee shots", labelTeeAccuracyToday.text];
            
        }
        
        [tweetSheet setInitialText:tweetText];
        
        [self presentModalViewController:tweetSheet animated:YES];
    }*/
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, 460.0, 320.0);
    
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button2.layer setCornerRadius:5.0f];
    
    [labelCap setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button3.layer setCornerRadius:5.0f];
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label5 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label9 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    
    [labelAvgScoreToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    [labelAvgPuttsToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    [labelAvgPenaltyToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    [labelTeeAccuracyToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    [labelAvgGirToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    [labelGrintsToday.layer setCornerRadius: labelAvgScoreToday.bounds.size.width/2];
    
    [labelAvgScoreHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgPuttsHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgPenaltyHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelTeeAccuracyHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgGirHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelGrintsHistorical.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    
    [labelAvgScoreCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgPuttsCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgPenaltyCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelTeeAccuracyCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelAvgGirCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];
    [labelGrintsCourse.layer setCornerRadius: labelAvgScoreHistorical.bounds.size.width/2];

    [labelAvgScoreToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPuttsToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenaltyToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracyToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGirToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrintsToday setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScoreHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPuttsHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenaltyHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracyHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGirHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrintsHistorical setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScoreCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPuttsCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenaltyCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracyCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGirCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrintsCourse setFont: [UIFont fontWithName:@"Oswald" size:23.0]];

    
    
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
