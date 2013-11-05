//
//  GrintBDetail5.m
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBDetail5.h"
#import "GrintBHistoricalPerformance.h"
#import "GrintBHistoricalPerformanceMultiplayer.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "GrintVerticalWebModalViewController.h"

#import "AddFriendsController.h"

@implementation GrintBDetail5
{
    int m_nIndex;
}
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
@synthesize pastUsers;
@synthesize teeID;
@synthesize friendList, friendFnameList, friendLnameList, data, holeOffset, handicapList, courseHandicapList, connection;
@synthesize username1, username2, username3, username4, userFname1, userFname2, userFname3, userFname4, userLname1, userLname2, userLname3, userLname4, maxHole, numberHoles;

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
        [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com/loginapp"]]];
        controller.webView1.scalesPageToFit = YES;
        
    }
    
}

-(IBAction)addFriendsClick:(id)sender{
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    [textField4 resignFirstResponder];
//    [[[UIAlertView alloc]initWithTitle:@"Feature Coming Soon" message:@"If you want to add friends now you can do so at our website www.TheGrint.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Go to site", nil] show];
    AddFriendsController* friendController = [[AddFriendsController alloc] initWithNibName: @"AddFriendsController" bundle: nil];
    friendController.m_strUserName = username;
    friendController.m_nType = 1;
    [self.navigationController pushViewController: friendController animated: YES];
}

- (IBAction)navigationDoneClick:(id)sender{
    
    NSInteger row = [pickerView1 selectedRowInComponent:0];
    
    [self tryAdd:self withText:[friendList objectAtIndex:row] andCourseHandicap:[courseHandicapList objectAtIndex:row] andHandicap:[handicapList objectAtIndex:row] andFname:[friendFnameList objectAtIndex:row] andLname:[friendLnameList objectAtIndex:row]];
    [pickerView1 setHidden:YES];
    [navigationBar1 setHidden:YES];
    
}

- (IBAction)clearField2:(id)sender{
    [textField2 setText:@""];
    username2 = nil;
    userFname2 = nil;
    userLname2 = nil;
    labelCourseHcp2.text = labelCourseHcp3.text;
    labelHcp2.text = labelHcp3.text;
    
    if(username3){
        [textField2 setText:textField3.text];
        username2 = username3;
        userFname2 = userFname3;
        userLname2 = userLname3;
        [self clearField3:sender];
    }
    
    
    
}

- (IBAction)clearField3:(id)sender{
    [textField3 setText:@""];
    username3 = nil;
    userFname3 = nil;
    userLname3 = nil;
    labelCourseHcp3.text = labelCourseHcp4.text;
    labelHcp3.text = labelHcp4.text;
    
    if(username4){
        [textField3 setText:textField4.text];
        username3 = username4;
        userFname3 = userFname4;
        userLname3 = userLname4;
        [self clearField4:sender];
    }
    
    
}

- (IBAction)clearField4:(id)sender{
    [textField4 setText:@""];
    username4 = nil;
    userFname4 = nil;
    userLname4 = nil;
    labelCourseHcp4.text = @"";
    labelHcp4.text = @"";
}

- (IBAction)beginTextEdit:(id)sender{
    
//    [sender resignFirstResponder];
//    
//    if(((UITextView*)sender).text.length < 1){
    int nIdx = ((UIView*)sender).tag - 100;
    if (nIdx < 0)
        return;
    
    int i = 0;
    for (i = 0; i < nIdx; i ++) {
        switch (i) {
            case 0:
                if (textField2.text == nil || [textField2.text isEqualToString: @""])
                    break;
                break;
            case 1:
                if (textField3.text == nil || [textField3.text isEqualToString: @""])
                    break;
                break;
            default:
                break;
        }
    }
    
    if (i == nIdx) {
        if(friendList && [friendList count] > 0){
            m_nIndex = nIdx;
            [pickerView1 setHidden:NO];
            [navigationBar1 setHidden:NO];
        }
    }
    
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [friendList count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [NSString stringWithFormat:@"%@ %@", [friendFnameList objectAtIndex:row], [friendLnameList objectAtIndex:row]];
    
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
    
    if(self.spinnerView1){
        [self.spinnerView1 removeSpinner];
        self.spinnerView1 = nil;
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if(self.spinnerView1){
        [self.spinnerView1 removeSpinner];
        self.spinnerView1 = nil;

    }
    
    friendList = [[NSMutableArray alloc]init];
    friendFnameList = [[NSMutableArray alloc]init];
    friendLnameList = [[NSMutableArray alloc]init];
    courseHandicapList = [[NSMutableArray alloc]init];
    handicapList = [[NSMutableArray alloc]init];
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    //  textField1.text = [self stringBetweenString:@"<self>" andString:@"</self>" forString:responseText];
    labelCourseHcp1.text = [self stringBetweenString:@"<self_coursehandicap>" andString:@"</self_coursehandicap>" forString:responseText];
    labelHcp1.text = [self stringBetweenString:@"<self_handicap>" andString:@"</self_handicap>" forString:responseText];
    
    
    NSLog(@"%@", responseText);
    
    for(NSString* s in [responseText componentsSeparatedByString:@"</friend>"]){
        
        if(s.length > 11){
            
            NSString* p = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
            
            if(p && p.length > 0)
                [friendList addObject:p];
            
            p = [self stringBetweenString:@"<handicap>" andString:@"</handicap>" forString:s];
            
            if(p && p.length > 0)
                [handicapList addObject:p];
            
            p = [self stringBetweenString:@"<coursehandicap>" andString:@"</coursehandicap>" forString:s];
            
            if(p && p.length > 0)
                [courseHandicapList addObject:p];
            
            p = [self stringBetweenString:@"<fname>" andString:@"</fname>" forString:s];
            if(p && p.length > 0)
                [friendFnameList addObject:p];
            p = [self stringBetweenString:@"<lname>" andString:@"</lname>" forString:s];
            if(p && p.length > 0)
                [friendLnameList addObject:p];
            
            
        }
    }
    
    if(friendList.count > 0){
        // button1.hidden = NO;
        [pickerView1 reloadAllComponents];
    }
    
}


- (IBAction)selectFriendList:(id)sender{
    
    [pickerView1 reloadAllComponents];
    pickerView1.hidden = NO;
    navigationBar1.hidden = NO;
}

- (void) tryAdd:(id)sender withText:(NSString*) string andCourseHandicap:(NSString*)courseHandicap andHandicap:(NSString*)handicap andFname:(NSString*)fname andLname:(NSString*)lname{
    
    if(textField1.text.length < 1){
        username1 = string;
        userFname1 = fname;
        userLname1 = lname;
        [textField1 setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
        labelHcp1.text = handicap;
        labelCourseHcp1.text = courseHandicap;
    }
    else if(m_nIndex == 0){
        username2 = string;
        userFname2 = fname;
        userLname2 = lname;
        [textField2 setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
        
        labelHcp2.text = handicap;
        labelCourseHcp2.text = courseHandicap;
    }
    else if(m_nIndex == 1){
        username3 = string;
        userFname3 = fname;
        userLname3 = lname;
        [textField3 setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
        
        labelHcp3.text = handicap;
        labelCourseHcp3.text = courseHandicap;
    }
    else if(m_nIndex == 2){
        username4 = string;
        userFname4 = fname;
        userLname4 = lname;
        [textField4 setText:[NSString stringWithFormat:@"%@ %@", fname, lname]];
        
        labelHcp4.text = handicap;
        labelCourseHcp4.text = courseHandicap;
    }
    
}

- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
}

-(IBAction)addUser:(id)sender{
    
    /*    switch (((UILabel*)sender).tag) {
     case 1:
     [self tryAdd:sender withText:label4.text];
     break;
     case 2:
     [self tryAdd:sender withText:label5.text];
     break;
     case 3:
     [self tryAdd:sender withText:label6.text];
     break;
     case 4:
     [self tryAdd:sender withText:label7.text];
     break;
     case 5:
     [self tryAdd:sender withText:label8.text];
     break;
     case 6:
     [self tryAdd:sender withText:label9.text];
     break;
     case 7:
     [self tryAdd:sender withText:label10.text];
     break;
     case 8:
     [self tryAdd:sender withText:label11.text];
     break;
     default:
     break;
     }*/
    
}

- (bool)historyContains:(NSString*) user{
    
    for(NSString* s in pastUsers){
        
        if([s isEqualToString:user]){
            return true;
        }
        
    }
    return false;
    
}

-(IBAction)nextScreen:(id)sender{
    if (self.spinnerView1)
        return;
    
    if(textField1.text.length > 0){
        if(![self historyContains:textField1.text] && ![textField1.text isEqualToString:username]){
            
            [pastUsers insertObject:textField1.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    if(textField2.text.length > 0){
        if(![self historyContains:textField2.text] && ![textField2.text isEqualToString:username]){
            
            [pastUsers insertObject:textField2.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
        
    }
    if(textField3.text.length > 0){
        if(![self historyContains:textField3.text] && ![textField3.text isEqualToString:username]){
            
            [pastUsers insertObject:textField3.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    if(textField4.text.length > 0){
        if(![self historyContains:textField4.text] && ![textField4.text isEqualToString:username]){
            
            [pastUsers insertObject:textField4.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:0] forKey:@"history1"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:1] forKey:@"history2"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:2] forKey:@"history3"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:3] forKey:@"history4"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:4] forKey:@"history5"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:5] forKey:@"history6"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:6] forKey:@"history7"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:7] forKey:@"history8"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    [Flurry logEvent:@"playgolf_begin"];
    
    if (textField2.text.length < 1 && textField3.text.length < 1 && textField4.text.length < 1) {
        self.detailViewController = [[GrintBHistoricalPerformance alloc] initWithNibName:@"GrintBHistoricalPerformance" bundle:nil];
        
        ((GrintBHistoricalPerformance*)self.detailViewController).teeID = self.teeID;
        
        ((GrintBHistoricalPerformance*)self.detailViewController).username = self.username;
        ((GrintBHistoricalPerformance*)self.detailViewController).courseName= self.courseName;
        ((GrintBHistoricalPerformance*)self.detailViewController).courseAddress= self.courseAddress;
        ((GrintBHistoricalPerformance*)self.detailViewController).teeboxColor= self.teeboxColor;
        ((GrintBHistoricalPerformance*)self.detailViewController).date = self.date;
        ((GrintBHistoricalPerformance*)self.detailViewController).score = self.score;
        ((GrintBHistoricalPerformance*)self.detailViewController).putts = self.putts;
        ((GrintBHistoricalPerformance*)self.detailViewController).penalties = self.penalties;
        ((GrintBHistoricalPerformance*)self.detailViewController).accuracy = self.accuracy;
        
        ((GrintBHistoricalPerformance*)self.detailViewController).username = username1;
        ((GrintBHistoricalPerformance*)self.detailViewController).fname = userFname1;
        ((GrintBHistoricalPerformance*)self.detailViewController).lname = userLname1;
        
        ((GrintBHistoricalPerformance*)self.detailViewController).player1 = username1;
        ((GrintBHistoricalPerformance*)self.detailViewController).player2 = username2;
        ((GrintBHistoricalPerformance*)self.detailViewController).player3 = username3;
        ((GrintBHistoricalPerformance*)self.detailViewController).player4 = username4;
        ((GrintBHistoricalPerformance*)self.detailViewController).courseID = self.courseID;
        ((GrintBHistoricalPerformance*)self.detailViewController).holeOffset = self.holeOffset;
        ((GrintBHistoricalPerformance*)self.detailViewController).maxHole = self.maxHole;
        ((GrintBHistoricalPerformance*)self.detailViewController).numberHoles = self.numberHoles;
        
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
    else{
        
        //check for duplicates
        
        NSArray* users = [[NSArray alloc]initWithObjects:textField1.text, textField2.text, textField3.text, textField4.text, nil];
        
        BOOL containsDupe = NO;
        
        for(NSString* user in users){
            
            int count = 0;
            for(NSString* user2 in users){
                
                if([user2 isEqualToString:user] && user2.length > 0){
                    count ++;
                }
                
            }
            if(count > 1){
                containsDupe = YES;
            }
            
            
        }
        
        if(containsDupe){
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Your list of players contains duplicates. Each player can only play once!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        }
        else{
            
            self.detailViewController = [[GrintBHistoricalPerformanceMultiplayer alloc] initWithNibName:@"GrintBHistoricalPerformanceMultiplayer" bundle:nil];
            
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).teeID = self.teeID;
            
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).username = self.username;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).courseName= self.courseName;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).courseAddress= self.courseAddress;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).date = self.date;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).score = self.score;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).putts = self.putts;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).penalties = self.penalties;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).accuracy = self.accuracy;
            
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).username = username1;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).player1 = username1;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).player2 = username2;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).player3 = username3;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).player4 = username4;
            
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userFname1 = userFname1;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userFname2 = userFname2;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userFname3 = userFname3;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userFname4 = userFname4;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userLname1 = userLname1;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userLname2 = userLname2;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userLname3 = userLname3;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).userLname4 = userLname4;
            
            
            
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).courseID = self.courseID;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).holeOffset = self.holeOffset;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).maxHole = self.maxHole;
            ((GrintBHistoricalPerformanceMultiplayer*)self.detailViewController).numberHoles = self.numberHoles;
            
            
            [self.navigationController pushViewController:self.detailViewController animated:YES];
        }
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Players", @"Select Players");
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
    if(self.spinnerView1){
        [self.spinnerView1 removeSpinner];
        self.spinnerView1 = nil;
        
    }
}

- (void) getFriendRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&course_id=%@&tee_id=%@", username, courseID, teeID];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];
    }
    
    self.spinnerView1 = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getFriendRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(getFriendRequest) name:@"refresh_friend_info" object:nil];
    
    /* [label1 setFont:[UIFont fontWithName:@"Merriweather-Bold" size:16]];
     [label2 setFont:[UIFont fontWithName:@"Merriweather" size:10]];
     [label3 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label4 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label5 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label6 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label7 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label8 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label9 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label10 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
     [label11 setFont:[UIFont fontWithName:@"Merriweather" size:12]];*/
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label12 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label13 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    button1.hidden = YES;
    
    [labelCourseHcp1 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelCourseHcp2 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelCourseHcp3 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelCourseHcp4 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelHcp1 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelHcp2 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelHcp3 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [labelHcp4 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    
    [labelCourseHcp1.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp2.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp3.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp4.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelHcp1.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelHcp2.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelHcp3.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelHcp4.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
    [self.navigationItem setRightBarButtonItem:button];
}


- (void)swipeRightDetected:(id)sender{
    if (self.spinnerView1) {
        [self.spinnerView1 removeSpinner];
        self.spinnerView1 = nil;
    }
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    [label4 setText:username];
    
    pastUsers = [[NSMutableArray alloc] init];
    
    [pastUsers addObject:username];
    
    NSString* temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history1"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history2"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history3"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history4"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history5"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history6"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history7"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history8"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    
    [label5 setText:[pastUsers objectAtIndex:1]];
    [label6 setText:[pastUsers objectAtIndex:2]];
    [label7 setText:[pastUsers objectAtIndex:3]];
    [label8 setText:[pastUsers objectAtIndex:4]];
    [label9 setText:[pastUsers objectAtIndex:5]];
    [label10 setText:[pastUsers objectAtIndex:6]];
    [label11 setText:[pastUsers objectAtIndex:7]];
    
    
    
    [textField1 setText:[NSString stringWithFormat:@"%@ %@", userFname1, userLname1]];
    //  [textField1 setText:@""];
    //  [textField2 setText:@""];
    //  [textField3 setText:@""];
    //  [textField4 setText:@""];
 
        UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
        [self.navigationItem setRightBarButtonItem:button];
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
