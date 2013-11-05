//
//  LeaderboardStatsToTrackViewController.m
//  grint
//
//  Created by Peter Rocker on 05/06/2013.
//
//

#import "LeaderboardStatsToTrackViewController.h"
#import "TDDatePickerController.h"
#import "LeaderboardPlayerSelectViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LeaderboardStatsToTrackViewController ()

@end

@implementation LeaderboardStatsToTrackViewController

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize courseID;
@synthesize teeID;
@synthesize fname, lname;

- (IBAction)changeStartingHole:(id)sender{
    startingHole = [stepper1 value];
    label7.text = [NSString stringWithFormat:@"%d", startingHole];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


-(IBAction)dismissKeyboard:(id)sender{
    [sender resignFirstResponder];
    TDDatePickerController* datePickerView = [[TDDatePickerController alloc]
                                              initWithNibName:@"TDDatePickerController"
                                              bundle:nil];
    datePickerView.delegate = self;
    
    datePickerView.datePicker.minimumDate = [[NSDate alloc]init];
    datePickerView.datePicker.maximumDate = [NSDate date];
    [self presentModalViewController:datePickerView animated:YES];
}


-(IBAction)nextScreen:(id)sender{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    /*-------------------------
     * To convert to free version
     * proceed straight to
     * GrintBHistoricalPerformance
     * instead of GrintBDetail5
     *-------------------------
     */
    
    //  if (!self.detailViewController) {
    LeaderboardPlayerSelectViewController* controller = [[LeaderboardPlayerSelectViewController alloc] initWithNibName:@"LeaderboardPlayerSelectViewController" bundle:nil];
    //     self.detailViewController = [[GrintBHistoricalPerformance alloc] initWithNibName:@"GrintBHistoricalPerformance" bundle:nil];
    //   }
    
    controller.teeID = self.teeID;
    controller.nameString = self.nameString;
    controller.userFname1 = self.nameString;
    controller.lastName = self.lastName;
    controller.userLname1 = self.lastName;
    controller.leaderboardPass = self.leaderboardPass;
    controller.leaderboardID = self.leaderboardID;
    controller.courseID = self.courseID;
    controller.teeID = self.teeID;
    controller.username = self.username;
    controller.username1 = self.username;
    controller.courseName= self.courseName;
    controller.courseAddress= self.courseAddress;
    controller.teeboxColor= self.teeboxColor;
    controller.date = dateField.text;
    controller.score = switchScore.on ? @"YES" : @"NO";
    controller.putts = switchPutts.on ? @"YES" : @"NO";
    controller.penalties = switchPenalties.on ? @"YES" : @"NO";
    controller.accuracy = switchTeeAccuracy.on ? @"YES" : @"NO";
    controller.holeOffset = [NSNumber numberWithInt:(startingHole - 1)];
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView firstOtherButtonIndex])
    {
        teeboxColor = ((UITextField *)[alertView viewWithTag:99]).text;
    }
    else{
        teeboxColor = @"Other";
    }
}

- (void)datePickerSetDate:(TDDatePickerController*)sender{
    
    NSDate *date = sender.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dateField setText:dateString];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Data", @"Select Data");
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
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dateField setText:dateString];
    
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label5 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button1.layer setCornerRadius:5.0f];
    [label7.layer setCornerRadius:label7.frame.size.width / 2];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    startingHole = 1;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
        
        UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
        [self.navigationItem setRightBarButtonItem:button];
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
