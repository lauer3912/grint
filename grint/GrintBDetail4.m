//
//  GrintBDetail4.m
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBDetail4.h"
#import "GrintBDetail5.h"
#import "GrintBHistoricalPerformance.h"
#import "TDDatePickerController.h"
#import "GrintHowToUse.h"

@implementation GrintBDetail4
@synthesize detailViewController = _detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize courseID;
@synthesize teeID;
@synthesize fname, lname, maxHole, numberHoles;

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

- (IBAction)holesEdit:(id)sender{
    
    [sender resignFirstResponder];
    pickerViewHoles.hidden = NO;
    navBarPicker.hidden = NO;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (IBAction)holesSelect:(id)sender{
    switch ([pickerViewHoles selectedRowInComponent:0]) {
        case 0:
            textFieldHoles.text = @"18 holes";
            stepper1.maximumValue = 18;
            stepper1.minimumValue = 1;
            stepper1.value = 1;
            break;
        case 1:
            textFieldHoles.text = @"Front 9";
            stepper1.maximumValue = 9;
            stepper1.minimumValue = 1;
            stepper1.value = 1;
            break;
        case 2:
            textFieldHoles.text = @"Back 9";
            stepper1.maximumValue = 18;
            stepper1.minimumValue = 10;
            stepper1.value = 10;
            break;
        default:
            textFieldHoles.text = @"18 holes";
            stepper1.maximumValue = 18;
            stepper1.minimumValue = 1;
            stepper1.value = 1;
    }
    
    [self changeStartingHole:stepper1];
    pickerViewHoles.hidden = YES;
    navBarPicker.hidden = YES;
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    

    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if(_isNine){
        return 2;
    }
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    switch (row) {
        case 0:
            return @"18 holes";
            break;
        case 1:
            return @"Front 9";
            break;
        case 2:
            return @"Back 9";
            break;
        default:
            return @"18 holes";
    }
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
        self.detailViewController = [[GrintBDetail5 alloc] initWithNibName:@"GrintBDetail5" bundle:nil];
   //     self.detailViewController = [[GrintBHistoricalPerformance alloc] initWithNibName:@"GrintBHistoricalPerformance" bundle:nil];
 //   }
    
    ((GrintBDetail5*)self.detailViewController).teeID = self.teeID;

    ((GrintBDetail5*)self.detailViewController).username = self.username;
    ((GrintBDetail5*)self.detailViewController).username1 = self.username;
    ((GrintBDetail5*)self.detailViewController).courseName= self.courseName;
    ((GrintBDetail5*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintBDetail5*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintBDetail5*)self.detailViewController).date = dateField.text;
    ((GrintBDetail5*)self.detailViewController).score = switchScore.on ? @"YES" : @"NO";
    ((GrintBDetail5*)self.detailViewController).putts = switchPutts.on ? @"YES" : @"NO";
    ((GrintBDetail5*)self.detailViewController).penalties = switchPenalties.on ? @"YES" : @"NO";
    ((GrintBDetail5*)self.detailViewController).accuracy = switchTeeAccuracy.on ? @"YES" : @"NO";
    ((GrintBDetail5*)self.detailViewController).courseID = self.courseID;
    ((GrintBDetail5*)self.detailViewController).userFname1 = fname;
    ((GrintBDetail5*)self.detailViewController).userLname1 = lname;
    ((GrintBDetail5*)self.detailViewController).holeOffset = [NSNumber numberWithInt:(startingHole - 1)];
    if([textFieldHoles.text rangeOfString:@"18"].location != NSNotFound){
        ((GrintBDetail5*)self.detailViewController).maxHole = 17;
        ((GrintBDetail5*)self.detailViewController).numberHoles = 17;
    }
    else if([textFieldHoles.text rangeOfString:@"Front"].location != NSNotFound){
        ((GrintBDetail5*)self.detailViewController).maxHole = 8;
        ((GrintBDetail5*)self.detailViewController).numberHoles = 8;
    }
    else{
        ((GrintBDetail5*)self.detailViewController).maxHole = 17;
        ((GrintBDetail5*)self.detailViewController).numberHoles = 8;
    }
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
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
    
    textFieldHoles.inputView = pickerViewHoles;
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label5 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    [label9 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button1.layer setCornerRadius:5.0f];
    [label7.layer setCornerRadius:label7.frame.size.width / 2];
    NSLog(self.teeboxColor);
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
    
    [pickerViewHoles reloadAllComponents];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstrunHelp"]){
        
        GrintHowToUse* controller = [[GrintHowToUse alloc] initWithNibName:@"GrintHowToUse" bundle:nil];
        controller.delegate = self;
        [self presentModalViewController:controller animated:NO];
        
        
    }
    if(_isNine){
        
     textFieldHoles.text = @"Front 9";
        [pickerViewHoles selectRow:1 inComponent:0 animated:NO];
        stepper1.maximumValue = 9;
        
    }
    else{
        
        textFieldHoles.text = @"18 Holes";
        [pickerViewHoles selectRow:0 inComponent:0 animated:NO];
        textFieldHoles.enabled = YES;
        stepper1.maximumValue = 18;
    }
    
    
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
