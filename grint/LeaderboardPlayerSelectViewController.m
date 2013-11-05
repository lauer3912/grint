//
//  LeaderboardPlayerSelectViewController.m
//  grint
//
//  Created by Peter Rocker on 30/05/2013.
//
//

#import "LeaderboardPlayerSelectViewController.h"
#import "GrintVerticalWebModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeaderboardCentralViewController.h"
#import "LeaderboardCentralMultiplayerViewController.h"

#import "AddFriendsController.h"

#import "SpinnerView.h"

@interface LeaderboardPlayerSelectViewController ()

@end

@implementation LeaderboardPlayerSelectViewController
{
    SpinnerView* spinnerView;
}

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
@synthesize username1, username2, username3, username4, userFname1, userFname2, userFname3, userFname4, userLname1, userLname2, userLname3, userLname4;

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
//    [[[UIAlertView alloc]initWithTitle:@"Feature Coming Soon" message:@"If you want to add friends now you can do so at our website www.TheGrint.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Go to site", nil] show];
    AddFriendsController* friendController = [[AddFriendsController alloc] initWithNibName: @"AddFriendsController" bundle: nil];
    friendController.m_strUserName = username;
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursehist_iphone_multiplayer"]){
        NSMutableArray* playerData = [[NSMutableArray alloc]init];
        
        for (int i = 1; i <= 4; i++){
            
            NSString* playerString = [self stringBetweenString:[NSString stringWithFormat:@"<player%i>", i] andString:[NSString stringWithFormat:@"</player%i>", i] forString:responseText];
            
            if(playerString && playerString.length > 0){
                NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
                
                if(i == 1){
                    [tempDict setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"username"] forKey:@"Username"];
                    [tempDict setValue:userFname1 forKey:@"fname"];
                    [tempDict setValue:userLname1 forKey:@"lname"];
                }
                else if(i == 2){
                    [tempDict setValue:username2 forKey:@"Username"];
                    [tempDict setValue:userFname2 forKey:@"fname"];
                    [tempDict setValue:userLname2 forKey:@"lname"];
                }
                else if(i == 3){
                    [tempDict setValue:username3 forKey:@"Username"];
                    [tempDict setValue:userFname3 forKey:@"fname"];
                    [tempDict setValue:userLname3 forKey:@"lname"];
                }
                else if(i == 4){
                    [tempDict setValue:username4 forKey:@"Username"];
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

        if (spinnerView) {
            [spinnerView removeSpinner];
            spinnerView = nil;
        }
        
        LeaderboardCentralMultiplayerViewController* controller = [[LeaderboardCentralMultiplayerViewController alloc]initWithNibName:@"LeaderboardCentralMultiplayerViewController" bundle:nil];
        controller.nameString = self.nameString;
        controller.lastName = self.lastName;
        controller.leaderboardPass = self.leaderboardPass;
        controller.leaderboardID = self.leaderboardID;
        controller.courseID = self.courseID;
        controller.teeID = self.teeID;
        controller.player1 = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
        controller.player2 = self.username2;
        controller.player3 = self.username3 ? self.username3 : @"";
        controller.player4 = self.username4 ? self.username4 : @"";
        controller.playerData = playerData;
        controller.date = self.date;
        controller.score = self.score;
        controller.putts = self.putts;
        controller.penalties = self.penalties;
        controller.accuracy = self.accuracy;
        controller.holeOffset = self.holeOffset;

        [self.navigationController pushViewController:controller animated:YES];
        

    } else if([connection.originalRequest.URL.absoluteString rangeOfString:@"leaderboard_join_additional_members"].location != NSNotFound){
        if([responseText rangeOfString:@"auth failure"].location != NSNotFound){
            [[[UIAlertView alloc]initWithTitle:@"Auth error" message:@"Sorry, your password seems to be incorrect. Please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursehist_iphone_multiplayer"]];
            NSString* requestBody = [NSString stringWithFormat:@"username1=%@&username2=%@&username3=%@&username4=%@&course_id=%d&tee_id=%@", self.username, self.username2, self.username3, self.username4, [self.courseID intValue], self.teeID];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
            
           connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (connection ) {
                data = [NSMutableData data];
            }
            
        }
    } else {
        friendList = [[NSMutableArray alloc]init];
        friendFnameList = [[NSMutableArray alloc]init];
        friendLnameList = [[NSMutableArray alloc]init];
        courseHandicapList = [[NSMutableArray alloc]init];
        handicapList = [[NSMutableArray alloc]init];
        
        
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
    
    
    if (textField2.text.length < 1 && textField3.text.length < 1 && textField4.text.length < 1) {
     
        
        LeaderboardCentralViewController* controller = [[LeaderboardCentralViewController alloc]initWithNibName:@"LeaderboardCentralViewController" bundle:nil];
        controller.nameString = self.nameString;
        controller.lastName = self.lastName;
        controller.leaderboardPass = self.leaderboardPass;
        controller.leaderboardID = self.leaderboardID;
        controller.courseID = self.courseID;
        controller.teeID = self.teeID;
        controller.date = self.date;
        controller.score = self.score;
        controller.putts = self.putts;
        controller.penalties = self.penalties;
        controller.accuracy = self.accuracy;
        controller.holeOffset = self.holeOffset;
        [self.navigationController pushViewController:controller animated:YES];
        
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
            
            spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/leaderboard_join_additional_members/"]];
            [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&user_password=%@&leaderboard_password=%@&leaderboard_id=%@&username2=%@&username3=%@&username4=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username" ],  [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], self.leaderboardPass, self.leaderboardID, self.username2, self.username3, self.username4] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (connection ) {
                data = [NSMutableData data];
            }
            
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
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    // Do any additional setup after loading the view from its nib.
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&course_id=%@&tee_id=%@", username, courseID, teeID];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];
    }
    
    
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
    
}


- (void)swipeRightDetected:(id)sender{
    
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
