//
//  GrintCheckStatsViewController.m
//  grint
//
//  Created by Peter Rocker on 06/12/2012.
//
//

#import "GrintCheckStatsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintWebModalViewController.h"

@interface GrintCheckStatsViewController ()

@end

@implementation GrintCheckStatsViewController

@synthesize courseList, courseIdList, receivedData, spinnerView, connection, nameString;

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


- (IBAction)moreStatsClick:(id)sender{
    
    GrintWebModalViewController* controller = [[GrintWebModalViewController alloc] initWithNibName:@"GrintWebModalViewController" bundle:nil];
    controller.delegate = self;
    [self presentViewController: controller animated: YES completion:nil];
    [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/trend"]]];
    controller.webView1.scalesPageToFit = YES;
}

- (IBAction)navigationDoneClick:(id)senzder{
    textField1.text = [courseList objectAtIndex:[picker1 selectedRowInComponent:0]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%@", self.username, [courseIdList objectAtIndex:[picker1 selectedRowInComponent:0]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        receivedData = [NSMutableData data];
    }
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    [picker1 setHidden:YES];
    [navigationBar1 setHidden:YES];

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }

    
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
    
        [picker1 reloadAllComponents];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone"]];
        NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%@", self.username, @"-1"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            receivedData = [NSMutableData data];
        }
        
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
        
        [picker1 setHidden:YES];
        
        [navigationBar1 setHidden:YES];
        
        
        
    }
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursestats_iphone"]){
        NSString* responseText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        labelScore.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_course>" andString:@"</avgscore_course>" forString:responseText]floatValue]];
        labelPutts.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_course>" andString:@"</avgputts_course>" forString:responseText]floatValue]];
        labelHazards.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_course>" andString:@"</avgpenalty_course>" forString:responseText]floatValue]];
        labelTeeAcc.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_course>" andString:@"</teeaccuracy_course>" forString:responseText]floatValue])];
        labelGIR.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_course>" andString:@"</avggir_course>" forString:responseText]floatValue])];
        labelGrints.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_course>" andString:@"</grints_course>" forString:responseText]floatValue])];
        if(![labelGrints.text isEqualToString:@"0"]){
            labelGrints.hidden = NO;
            labelGrintsLabel.hidden = NO;
        }
        
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

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        
       
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [courseList count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [courseList objectAtIndex:row];
    
}

- (IBAction)textfieldBeginEditing:(id)sender{
    [(UITextField*)sender resignFirstResponder];
    
    if(courseList && courseList.count > 0){
    [picker1 setHidden:NO];
    
    [navigationBar1 setHidden:NO];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"No scores" message:@"You haven't yet submitted a score to TheGrint! Please play at least one round, then your stats will appear here." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }
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
    
    [labelScore.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelPutts.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelGIR.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelGrints.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelHazards.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelTeeAcc.layer setCornerRadius: labelScore.bounds.size.width/2];
   
    [labelGIR setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelHazards setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelScore setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAcc setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelTitle setFont:[UIFont fontWithName:@"Oswald" size:18.0]];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/pastcourses_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@", self.username];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        receivedData = [NSMutableData data];
    }
    
    [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button3.layer setCornerRadius:5.0f];
    
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
