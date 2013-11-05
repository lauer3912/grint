//
//  GrintBHistoricalPerformance.m
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBHistoricalPerformance.h"
#import "GrintBWriteScore.h"
#import <QuartzCore/QuartzCore.h>

@implementation GrintBHistoricalPerformance
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
@synthesize teeID;
@synthesize spinnerView;
@synthesize holeOffset;
@synthesize connection;
@synthesize fname, lname, maxHole, numberHoles;

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
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursehist_iphone"]){
        
        NSLog(responseText);
        
       /* IBOutlet UILabel* labelCourseHandicap;
        IBOutlet UILabel* labelCourseAvgScore;
        IBOutlet UILabel* labelCourseAvgPutts;
        IBOutlet UILabel* labelCourseAvgGir;
        IBOutlet UILabel* labelCourseBestScore;
        IBOutlet UILabel* labelAvgScore;
        IBOutlet UILabel* labelAvgPutts;
        IBOutlet UILabel* labelAvgGir;
        IBOutlet UILabel* labelBestScore;*/

        
        labelCourseHandicap.text = [NSString stringWithFormat:@"Course Handicap: %.0f", [[self stringBetweenString:@"<coursehandicap>" andString:@"</coursehandicap>" forString:responseText]floatValue]];
        labelCourseAvgScore.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<courseavgscore>" andString:@"</courseavgscore>" forString:responseText]floatValue])];
        labelCourseAvgPutts.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<courseavgputts>" andString:@"</courseavgputts>" forString:responseText]floatValue])];
        labelCourseAvgGir.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<courseavggir>" andString:@"</courseavggir>" forString:responseText]floatValue])];
        labelCourseBestScore.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<coursebestscore>" andString:@"</coursebestscore>" forString:responseText]floatValue])];
        labelAvgScore.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<avgscore>" andString:@"</avgscore>" forString:responseText] floatValue])];
        labelAvgPutts.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<avgputts>" andString:@"</avgputts>" forString:responseText]floatValue])];
        labelAvgGir.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<avggir>" andString:@"</avggir>" forString:responseText]floatValue])];
        labelBestScore.text = [NSString stringWithFormat:@"%d", lroundf([[self stringBetweenString:@"<bestscore>" andString:@"</bestscore>" forString:responseText] floatValue])];
        
        
        if([labelCourseAvgScore.text isEqualToString:@"0"]){
            labelCourseAvgScore.text = @"N/A";
        }        
        if([labelAvgScore.text isEqualToString:@"0"]){
            labelAvgScore.text = @"N/A";
        }       
        if([labelCourseBestScore.text isEqualToString:@"0"]){
            labelCourseBestScore.text = @"N/A";
        }        
        if([labelBestScore.text isEqualToString:@"0"]){
            labelBestScore.text = @"N/A";
        }
        if([labelAvgPutts.text isEqualToString:@"0"]){
            labelAvgPutts.text = @"N/A";
        }
        if([labelCourseAvgPutts.text isEqualToString:@"0"]){
            labelCourseAvgPutts.text = @"N/A";
        }
        if([labelAvgPutts.text isEqualToString:@"0"]){
            labelAvgPutts.text = @"N/A";
        }
        if([labelCourseAvgGir.text isEqualToString:@"0%"]){
            labelCourseAvgGir.text = @"N/A";
        }
        if([labelAvgGir.text isEqualToString:@"0%"]){
            labelAvgGir.text = @"N/A";
        }


                      
    }
    
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

-(IBAction)nextScreen:(id)sender{
    
    if (spinnerView != nil)
        return;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintBWriteScore alloc] initWithNibName:@"GrintBWriteScore" bundle:nil];
    }
    
    ((GrintBWriteScore*)self.detailViewController).teeID = self.teeID;
    

    ((GrintBWriteScore*)self.detailViewController).username = self.username;
    ((GrintBWriteScore*)self.detailViewController).courseName= self.courseName;
    ((GrintBWriteScore*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintBWriteScore*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintBWriteScore*)self.detailViewController).date = self.date;
    ((GrintBWriteScore*)self.detailViewController).score = self.score;
    ((GrintBWriteScore*)self.detailViewController).putts = self.putts;
    ((GrintBWriteScore*)self.detailViewController).penalties = self.penalties;
    ((GrintBWriteScore*)self.detailViewController).accuracy = self.accuracy;
    ((GrintBWriteScore*)self.detailViewController).player1 = self.player1;
    ((GrintBWriteScore*)self.detailViewController).player2 = self.player2;
    ((GrintBWriteScore*)self.detailViewController).player3 = self.player3;
    ((GrintBWriteScore*)self.detailViewController).player4 = self.player4;
    ((GrintBWriteScore*)self.detailViewController).courseID = self.courseID;
    ((GrintBWriteScore*)self.detailViewController).holeOffset = self.holeOffset;
    ((GrintBWriteScore*)self.detailViewController).maxHole = self.maxHole;
    ((GrintBWriteScore*)self.detailViewController).numberHoles = self.numberHoles;
    
    ((GrintBWriteScore*)self.detailViewController).fname = fname;
    ((GrintBWriteScore*)self.detailViewController).lname = lname;
    
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursehist_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&tee_id=%@", self.username, [self.courseID intValue], self.teeID];
    if(self.numberHoles < 10){
        requestBody = [requestBody stringByAppendingString:@"&is_nine=1"];
    }
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
    }
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    [titleLabel setText:[NSString stringWithFormat:@"%@'S ROUND STATS", [self.fname uppercaseString]]];
    
    if(courseName.length > 20){
    //    [titleLabel setText:[[NSString stringWithFormat:@"You and %@", [courseName substringToIndex:20]] uppercaseString]];
    }
    else{
   //     [titleLabel setText:[[NSString stringWithFormat:@"You and %@", courseName] uppercaseString]];
    }
    
        
        UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
        [self.navigationItem setRightBarButtonItem:button];
        }

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    
    [titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    
   // [labelCourseHandicap.layer setCornerRadius:labelCourseHandicap.bounds.size.width];
    [labelCourseAvgScore.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelCourseAvgPutts.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelCourseAvgGir.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelCourseBestScore.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelAvgScore.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelAvgPutts.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelAvgGir.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    [labelBestScore.layer setCornerRadius:labelCourseAvgScore.bounds.size.width/2];
    
    [labelCourseAvgScore setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelCourseAvgPutts setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelCourseAvgGir setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelCourseBestScore setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgScore setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelBestScore setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
 
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
}

- (void)swipeRightDetected:(id)sender{
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }

    [[self navigationController]popViewControllerAnimated:YES];
    
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
