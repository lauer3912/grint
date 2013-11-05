//
//  GrintBHistoricalPerformanceMultiplayer.m
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

#import "GrintBHistoricalPerformanceMultiplayer.h"
#import "GrintBWriteScoreMultiplayer.h"
#import <QuartzCore/QuartzCore.h>

@interface GrintBHistoricalPerformanceMultiplayer ()

@end

@implementation GrintBHistoricalPerformanceMultiplayer
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
@synthesize playerData;
@synthesize connection;
@synthesize userFname1, userLname1, userLname3, userFname3, userLname2, userFname2, userFname4, userLname4, maxHole, numberHoles;

- (void) displayStats{
    
    NSMutableDictionary* dict = [playerData objectAtIndex:playerIndex - 1];
        
    titleLabel.text = [NSString stringWithFormat:@"%@'S STATS",[[dict valueForKey:@"fname"] uppercaseString]];
    labelCourseHandicap.text = [dict valueForKey:@"CourseHandicap"];
    labelCourseAvgScore.text = [dict valueForKey:@"CourseAvgScore"];
    labelCourseAvgPutts.text = [dict valueForKey:@"CourseAvgPutts"];
    labelCourseAvgGir.text = [dict valueForKey:@"CourseAvgGir"];
    labelCourseBestScore.text = [dict valueForKey:@"CourseBestScore"];
    labelAvgScore.text = [dict valueForKey:@"AvgScore"];
    labelAvgPutts.text = [dict valueForKey:@"AvgPutts"];
    labelAvgGir.text = [dict valueForKey:@"AvgGir"];
    labelBestScore.text = [dict valueForKey:@"BestScore"];
    
    
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

- (void)nextPlayer:(id)sender{
    
    if (playerIndex < 4 && playerData.count > playerIndex){
        playerIndex ++;
        [self displayStats];
    }
    
}

- (void)previousPlayer:(id)sender{
    
    if (playerIndex > 1){
        playerIndex --;
        [self displayStats];
    }
    
}

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
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursehist_iphone_multiplayer"]){
        
        playerIndex = 0;
        
        playerData = [[NSMutableArray alloc]init];
        
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
        
        for (int i = 1; i <= 4; i++){
            
            NSString* playerString = [self stringBetweenString:[NSString stringWithFormat:@"<player%i>", i] andString:[NSString stringWithFormat:@"</player%i>", i] forString:responseText];
            
            if(playerString && playerString.length > 0){
                
                NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
                
                if(i == 1){
                    [tempDict setValue:player1 forKey:@"Username"];
                    [tempDict setValue:userFname1 forKey:@"fname"];
                    [tempDict setValue:userLname1 forKey:@"lname"];
                }
                else if(i == 2){
                    [tempDict setValue:player2 forKey:@"Username"];
                    [tempDict setValue:userFname2 forKey:@"fname"];
                    [tempDict setValue:userLname2 forKey:@"lname"];
                }
                else if(i == 3){
                    [tempDict setValue:player3 forKey:@"Username"];
                    [tempDict setValue:userFname3 forKey:@"fname"];
                    [tempDict setValue:userLname3 forKey:@"lname"];
                }
                else if(i == 4){
                    [tempDict setValue:player4 forKey:@"Username"];
                    [tempDict setValue:userFname4 forKey:@"fname"];
                    [tempDict setValue:userLname4 forKey:@"lname"];
                }
                
                [tempDict setValue:[NSString stringWithFormat:@"Course Handicap: %.0f", [[self stringBetweenString:@"<coursehandicap>" andString:@"</coursehandicap>" forString:playerString]floatValue]] forKey:@"CourseHandicap"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<courseavgscore>" andString:@"</courseavgscore>" forString:playerString]floatValue]) ]forKey:@"CourseAvgScore"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<courseavgputts>" andString:@"</courseavgputts>" forString:playerString]floatValue])]forKey:@"CourseAvgPutts"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<courseavggir>" andString:@"</courseavggir>" forString:playerString]floatValue])]forKey:@"CourseAvgGir"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<coursebestscore>" andString:@"</coursebestscore>" forString:playerString]floatValue])]forKey:@"CourseBestScore"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avgscore>" andString:@"</avgscore>" forString:playerString] floatValue])]forKey:@"AvgScore"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avgputts>" andString:@"</avgputts>" forString:playerString]floatValue])]forKey:@"AvgPutts"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir>" andString:@"</avggir>" forString:playerString]floatValue])]forKey:@"AvgGir"];
                [tempDict setValue:[NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<bestscore>" andString:@"</bestscore>" forString:playerString] floatValue])]forKey:@"BestScore"];
                    
                [playerData addObject:tempDict];
                
            }
            
        }
        
        
        
        if(playerIndex == 0){
            [self nextPlayer:self];
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
        self.detailViewController = [[GrintBWriteScoreMultiplayer alloc] initWithNibName:@"GrintBWriteScoreMultiplayer" bundle:nil];
    }
    
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).teeID = self.teeID;
    
    
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).username = self.username;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).fname = self.userFname1;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).lname = self.userLname1;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).courseName= self.courseName;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).date = self.date;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).score = self.score;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).putts = self.putts;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).penalties = self.penalties;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).accuracy = self.accuracy;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).player1 = self.player1;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).player2 = self.player2;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).player3 = self.player3;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).player4 = self.player4;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).courseID = self.courseID;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).holeOffset = self.holeOffset;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).playerData = self.playerData;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).maxHole = self.maxHole;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).numberHoles = self.numberHoles;
    ((GrintBWriteScoreMultiplayer*)self.detailViewController).isNine = self.numberHoles > 8 ? NO : YES;
    
    
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
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursehist_iphone_multiplayer"]];
    NSString* requestBody = [NSString stringWithFormat:@"username1=%@&username2=%@&username3=%@&username4=%@&course_id=%d&tee_id=%@", self.player1, self.player2, self.player3, self.player4, [self.courseID intValue], self.teeID];
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
    
    
    [labelUsername setText:courseName];
    [labelUsername setFont: [UIFont fontWithName:@"Oswald" size:16.0]];
    
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextPlayer:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(previousPlayer:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}

- (void)swipeRightDetected:(id)sender{
    
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