//
//  GrintStatsScorecardDetailViewController2.m
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import "GrintStatsScorecardDetailViewController2.h"

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "GrintAppDelegate.h"
#import "GrintSocialViewController.h"

@interface GrintStatsScorecardDetailViewController2 ()

@end

@implementation GrintStatsScorecardDetailViewController2

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
@synthesize delegate, connection, nameString;

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
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSLog(responseText);
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursestats_iphone"]){
        
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
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&date=%@", self.username, [self.courseID intValue], self.date];
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
       
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, 460.0, 320.0);
    
    
    [labelCap setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button2.layer setCornerRadius:5.0f];
    
    [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
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
