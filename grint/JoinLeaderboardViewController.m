//
//  JoinLeaderboardViewController.m
//  grint
//
//  Created by Peter Rocker on 13/05/2013.
//
//

#import "JoinLeaderboardViewController.h"
#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>
#import "LeaderboardCentralViewController.h"
#import "Flurry.h"
#import "LeaderboardStatsToTrackViewController.h"


@interface JoinLeaderboardViewController ()

@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* labelLeaderboardName;
@property (nonatomic, retain) IBOutlet UILabel* labelGolfCourse;
@property (nonatomic, retain) IBOutlet UILabel* labelTeeBox;
@property (nonatomic, retain) IBOutlet UILabel* labelDate;
@property (nonatomic, retain) IBOutlet UILabel* labelPlayers;
@property (nonatomic, retain) IBOutlet UILabel* labelPasscode;
@property (nonatomic, retain) IBOutlet UILabel* labelOrganiser;
@property (nonatomic, retain) IBOutlet UIView* bgView;

@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSMutableData* data;

@property (nonatomic, retain) NSString* courseID;

@end

@implementation JoinLeaderboardViewController



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
    if(_spinnerView){
        [_spinnerView removeSpinner];
        _spinnerView = nil;
    }
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    if([responseText rangeOfString:@"auth failure"].location != NSNotFound){
        [[[UIAlertView alloc]initWithTitle:@"Auth error" message:@"Sorry, your password seems to be incorrect. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        self.courseID = [self stringBetweenString:@"<course_ID>" andString:@"</course_ID>" forString:responseText];
        self.teeID = [self stringBetweenString:@"<teebox_ID>" andString:@"</teebox_ID>" forString:responseText];
       _labelLeaderboardName.text = [self stringBetweenString:@"<name>" andString:@"</name>" forString:responseText];
       _labelGolfCourse.text = [self stringBetweenString:@"<coursename>" andString:@"</coursename>" forString:responseText];
       _labelTeeBox.text = [NSString stringWithFormat:@"Tee Box: %@", [self stringBetweenString:@"<teebox_name>" andString:@"</teebox_name>" forString:responseText]];
       _labelDate.text = [NSString stringWithFormat:@"Date: %@", [self stringBetweenString:@"<date>" andString:@"</date>" forString:responseText]];
       _labelPlayers.text = [NSString stringWithFormat:@"Players joined: %@", [self stringBetweenString:@"<players_count>" andString:@"</players_count>" forString:responseText]];
       _labelPasscode.text = [NSString stringWithFormat:@"Passcode: %@", self.leaderboardPass];
       _labelOrganiser.text = [NSString stringWithFormat:@"Leaderboard organizer: %@ %@", [self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:responseText], [self stringBetweenString:@"<user_lname>" andString:@"</user_lname>" forString:responseText ]];
        
    }
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_spinnerView){
        _spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/join_leaderboard_iphone/"]];
     [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&user_password=%@&leaderboard_password=%@&leaderboard_id=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardPass, self.leaderboardID] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
    }

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(swipeRightDetected:)];
    
    [[self navigationItem] setLeftBarButtonItem:backButton];

    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)swipeRightDetected:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)nextScreen:(id)sender{
    
    [Flurry logEvent:@"leaderboard_leaderboard_joined"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: @"0" forKey: @"glance"];
    [defaults synchronize];
    
    LeaderboardStatsToTrackViewController* controller = [[LeaderboardStatsToTrackViewController alloc]initWithNibName:@"LeaderboardStatsToTrackViewController" bundle:nil];
    controller.nameString = self.nameString;
    controller.lastName = self.lastName;
    controller.leaderboardPass = self.leaderboardPass;
    controller.leaderboardID = self.leaderboardID;
    controller.courseID = self.courseID;
    controller.teeID = self.teeID;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    _bgView.layer.cornerRadius = 15.0f;
    _bgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _bgView.layer.borderWidth = 1.0f;
    [_labelLeaderboardName setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_labelGolfCourse setFont:[UIFont fontWithName:@"Oswald" size:20]];
    [_labelOrganiser setFont:[UIFont fontWithName:@"Oswald" size:12]];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];

    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
    [self.navigationItem setRightBarButtonItem:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
