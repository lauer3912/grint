//
//  GrintDetail4.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintDetail4.h"
#import "GrintDetail5.h"
#import "TDDatePickerController.h"


@implementation GrintDetail4
@synthesize detailViewController = _detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize courseID;



-(IBAction)nextScreen:(id)sender{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
  //  if (!self.detailViewController) {
        self.detailViewController = [[GrintDetail5 alloc] initWithNibName:@"GrintDetail5" bundle:nil];
  //  }
    ((GrintDetail5*)self.detailViewController).username = self.username;
    ((GrintDetail5*)self.detailViewController).courseName= self.courseName;
        ((GrintDetail5*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintDetail5*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintDetail5*)self.detailViewController).date = dateField.text;
    ((GrintDetail5*)self.detailViewController).score = switchScore.on ? @"YES" : @"NO";
    ((GrintDetail5*)self.detailViewController).putts = switchPutts.on ? @"YES" : @"NO";
    ((GrintDetail5*)self.detailViewController).penalties = switchPenalties.on ? @"YES" : @"NO";
    ((GrintDetail5*)self.detailViewController).accuracy = switchTeeAccuracy.on ? @"YES" : @"NO";
    ((GrintDetail5*)self.detailViewController).courseID = self.courseID;

    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
    [self.navigationItem setRightBarButtonItem:button];
    
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
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:16]];
     
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    
    NSLog(self.teeboxColor);
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
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
