//
//  GrintStatsHandicapsViewController.m
//  grint
//
//  Created by Peter Rocker on 10/12/2012.
//
//

#import "GrintStatsHandicapsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintVerticalWebModalViewController.h"

@interface GrintStatsHandicapsViewController ()

@end

@implementation GrintStatsHandicapsViewController

@synthesize username, courseIdList, courseList, friendsList, spinnerView, receivedData, handicapList, courseHandicapList, currentHandicapField, currentCourseHandicapField, currentPlayerField, connection, nameString, friendFnameList, friendLnameList;

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

-(IBAction)addFriendsClick:(id)sender{
    [[[UIAlertView alloc]initWithTitle:@"Feature Coming Soon" message:@"If you want to add friends now you can do so at our website www.TheGrint.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Go to site", nil] show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != alertView.cancelButtonIndex){
        GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
        [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com/loginapp"]]];
        controller.webView1.scalesPageToFit = YES;
        
    }
    
}


- (IBAction)navigationBack:(id)sender{

    if(!pickerViewCourses.hidden){
        
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone"]];
        NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%@", self.username, [courseIdList objectAtIndex:[pickerViewCourses selectedRowInComponent:0]]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            receivedData = [NSMutableData data];
        }
        
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
        
        textFieldCourse.text = [courseList objectAtIndex:[pickerViewCourses selectedRowInComponent:0]];
        
    }
    else if (!pickerViewFriends.hidden){
        
        currentCourseHandicapField.text = [courseHandicapList objectAtIndex:[pickerViewFriends selectedRowInComponent:0]];
        currentHandicapField.text = [handicapList objectAtIndex:[pickerViewFriends selectedRowInComponent:0]];
        currentPlayerField.text = [friendsList objectAtIndex:[pickerViewFriends selectedRowInComponent:0]];
        
        currentPlayerField.text = [NSString stringWithFormat:@"%@ %@", [friendFnameList objectAtIndex:[pickerViewFriends selectedRowInComponent:0]], [friendLnameList objectAtIndex:[pickerViewFriends selectedRowInComponent:0]]];
    }
    
    pickerViewFriends.hidden = YES;
    pickerViewCourses.hidden = YES;
    navigationBar1.hidden = YES;
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if([[[connection.originalRequest URL] absoluteString] rangeOfString:@"pastcourses_iphone"].location != NSNotFound){
        
        courseList = [[NSMutableArray alloc]init];
        courseIdList = [[NSMutableArray alloc]init];
        
        NSString* downloadTemp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        for(NSString* s in [downloadTemp componentsSeparatedByString:@"</item>"]){
            
            NSString* t = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
            NSString* u = [self stringBetweenString:@"<id>" andString:@"</id>" forString:s];
            
            if(t && u && t.length > 0 && u.length > 0){
                [courseList addObject:t];
                [courseIdList addObject:u];
            }
            
        }
        
        [pickerViewCourses reloadAllComponents];
        
    }
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/getfriends_iphone"]){       
        
        NSString *responseText = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseText);
        
        friendsList = [[NSMutableArray alloc]init];
        handicapList = [[NSMutableArray alloc]init];
        courseHandicapList = [[NSMutableArray alloc]init];
        friendFnameList = [[NSMutableArray alloc]init];
        friendLnameList = [[NSMutableArray alloc]init];
        
        textField1.text = [self stringBetweenString:@"<self>" andString:@"</self>" forString:responseText];
        labelCourseHcp1.text = [self stringBetweenString:@"<self_coursehandicap>" andString:@"</self_coursehandicap>" forString:responseText];
        labelHcp1.text = [self stringBetweenString:@"<self_handicap>" andString:@"</self_handicap>" forString:responseText];
        
        for(NSString* s in [responseText componentsSeparatedByString:@"</friend>"]){
            
            if(s.length > 11){
                
                NSString* p = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
                
                if(p && p.length > 0)
                    [friendsList addObject:p];
                
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
        
        if(textField2.text.length > 0){
            
            int ix = [friendsList indexOfObject:textField2.text];
            labelCourseHcp2.text = [courseHandicapList objectAtIndex:ix];
            labelHcp2.text = [handicapList objectAtIndex:ix];
            
        }
        
        if(textField3.text.length > 0){
            
            int ix = [friendsList indexOfObject:textField3.text];
            labelCourseHcp3.text = [courseHandicapList objectAtIndex:ix];
            labelHcp3.text = [handicapList objectAtIndex:ix];
            
        }
        
        if(textField4.text.length > 0){
            
            int ix = [friendsList indexOfObject:textField4.text];
            labelCourseHcp4.text = [courseHandicapList objectAtIndex:ix];
            labelHcp4.text = [handicapList objectAtIndex:ix];
            
        }
        
        if(friendsList.count > 0){
            // button1.hidden = NO;
            [pickerViewFriends reloadAllComponents];
        }

        [pickerViewFriends reloadAllComponents];

    }
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (IBAction)beginTextEdit:(id)sender{
    
    [sender resignFirstResponder];
    
    if(sender == textFieldCourse){
        [pickerViewCourses setHidden:NO];
        
        navigationBar1.hidden = NO;

    }
    else if(friendsList && friendsList.count > 0){
        [pickerViewFriends setHidden:NO];
        navigationBar1.hidden = NO;

        currentPlayerField = sender;
        
        if(sender == textField2){
            currentHandicapField = labelHcp2;
            currentCourseHandicapField = labelCourseHcp2;
        }
        else if (sender == textField3){
            currentHandicapField = labelHcp3;
            currentCourseHandicapField = labelCourseHcp3;
        }
        else if (sender == textField4){
            currentHandicapField = labelHcp4;
            currentCourseHandicapField = labelCourseHcp4;
        }
    }
    else{
      //  [[[UIAlertView alloc]initWithTitle:@"Select course" message:@"Please select a course first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (void) pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
   
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView == pickerViewCourses){
        return [courseList count];
    }
    else if (pickerView == pickerViewFriends){
        return [friendsList count];
    }
    
    return 0;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(pickerView == pickerViewCourses){
        return [courseList objectAtIndex:row];
    }
    else if (pickerView == pickerViewFriends){
  //      return [friendsList objectAtIndex:row];
        
        return [NSString stringWithFormat:@"%@ %@", [friendFnameList objectAtIndex:row], [friendLnameList objectAtIndex:row]];
    }
    
    return @"";
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}

- (IBAction)clearField2:(id)sender{
    [textField2 setText:@""];
    [labelCourseHcp2 setText:@""];
    [labelHcp2 setText:@""];
}

- (IBAction)clearField3:(id)sender{
    [textField3 setText:@""];
    [labelCourseHcp3 setText:@""];
    [labelHcp3 setText:@""];
}

- (IBAction)clearField4:(id)sender{
    [textField4 setText:@""];
    [labelCourseHcp4 setText:@""];
    [labelHcp4 setText:@""];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/pastcourses_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@", self.username];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        receivedData = [NSMutableData data];
    }
    
    [labelCourseHcp1.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp2.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp3.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelCourseHcp4.layer setCornerRadius:labelCourseHcp1.frame.size.height / 2];
    [labelHcp1.layer setCornerRadius:labelHcp1.frame.size.height / 2];
    [labelHcp2.layer setCornerRadius:labelHcp1.frame.size.height / 2];
    [labelHcp3.layer setCornerRadius:labelHcp1.frame.size.height / 2];
    [labelHcp4.layer setCornerRadius:labelHcp1.frame.size.height / 2];
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [labelHcp1 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelHcp2 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelHcp3 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelHcp4 setFont:[UIFont fontWithName:@"Oswald" size:23]];
       
    friendsList = [[NSMutableArray alloc]init];
    courseList = [[NSMutableArray alloc]init];
    courseIdList = [[NSMutableArray alloc]init];
    handicapList = [[NSMutableArray alloc]init];
    courseHandicapList = [[NSMutableArray alloc]init];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone"]];
    requestBody = [NSString stringWithFormat:@"username=%@&course_id=%@", self.username, @"1"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        receivedData = [NSMutableData data];
    }
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
