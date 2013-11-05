//
//  GrintBDetail3.m
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBDetail3.h"
#import "GrintBDetail4.h"
#import <MessageUI/MessageUI.h>
#import "JoinLeaderboardViewController.h"

@implementation GrintBDetail3
@synthesize detailViewController = _detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize courseID, data, rows, teeID;
@synthesize spinnerView;
@synthesize connection;
@synthesize fname, lname;
@synthesize isLeaderboard, leaderboardName, leaderboardPass;

- (IBAction)missingTeebox:(id)sender{
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    
    mail.mailComposeDelegate = self;
    
    [mail setToRecipients:[NSArray arrayWithObject:@"courses@thegrint.com"]];
    [mail setSubject:@"Teebox request"];
    [mail setMessageBody:[NSString stringWithFormat:@"Please let us know the name of your missing teebox, and any other info:\n\n\n\nCourse name: %@\n%@", courseName, courseAddress] isHTML:NO];
    
    [self presentModalViewController:mail animated:YES];
    
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    [self dismissModalViewControllerAnimated:YES];
    
    if(result == MFMailComposeResultSent){
        
        
        //    [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    self.teeID = [[rows objectAtIndex:indexPath.row]objectForKey:@"teeid"];
    
    [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if(self.isLeaderboard){
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/create_leaderboard_iphone/"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&name=%@&password=%@&courseid=%d&teebox_ID=%@", self.username, self.leaderboardName, self.leaderboardPass, [self.courseID intValue], self.teeID] dataUsingEncoding:NSUTF8StringEncoding]];
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            data = [NSMutableData data];
        }
        
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];

        
    }
    else{
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintBDetail4 alloc] initWithNibName:@"GrintBDetail4" bundle:nil];
    }
    
    ((GrintBDetail4*)self.detailViewController).teeID = self.teeID;
    
    ((GrintBDetail4*)self.detailViewController).username = self.username;
    ((GrintBDetail4*)self.detailViewController).courseName= self.courseName;    
    ((GrintBDetail4*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintBDetail4*)self.detailViewController).fname = fname;
    ((GrintBDetail4*)self.detailViewController).lname = lname;
        ((GrintBDetail4*)self.detailViewController).teeboxColor= [NSString stringWithFormat:@"%@ (%@)", [[rows objectAtIndex:indexPath.row] objectForKey:@"tees"], [[rows objectAtIndex:indexPath.row] objectForKey:@"sex"]];
        ((GrintBDetail4*)self.detailViewController).courseID = self.courseID;
        ((GrintBDetail4*)self.detailViewController).isNine = [[[rows objectAtIndex:indexPath.row] objectForKey:@"isNine"] intValue];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: @"0" forKey: @"glance"];
        [defaults synchronize];
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([rows count] < 1){
        return 1;
    }
    
    return [rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UILabel* labelA = [[UILabel alloc]initWithFrame:CGRectMake(40, 00, 300, 20)];
        labelA.tag = 11;
        labelA.font = [UIFont systemFontOfSize:16.0];
        [cell addSubview:labelA];
        
        UILabel* labelB = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 300, 20)];
        labelB.tag = 12;
        labelB.font = [UIFont systemFontOfSize:12.0];
        [cell addSubview:labelB];
        
        UILabel* labelTee = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 19, 22)];
        [labelTee setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        labelTee.tag = 10;
        labelTee.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
        labelTee.layer.borderWidth = 1.0;
        [cell.contentView addSubview:labelTee];   
        [cell bringSubviewToFront:labelTee];
        [cell bringSubviewToFront:labelA];
        [cell bringSubviewToFront:labelB];
        
    }
    
    if([rows count] < 1){
        
        [(UILabel*)[cell viewWithTag:11] setText:@"Loading..."];
        
    }
    else{
        
        [(UILabel*)[cell viewWithTag:11] setText:[NSString stringWithFormat:@"%@ (%@)- %@ yds", [[rows objectAtIndex:indexPath.row]objectForKey:@"tees"],[[rows objectAtIndex:indexPath.row]objectForKey:@"sex" ], [[rows objectAtIndex:indexPath.row]objectForKey:@"course_yardage" ]]];
        
        [(UILabel*)[cell viewWithTag:12] setText:[NSString stringWithFormat:@"Rating %@ / Slope %@",[[rows objectAtIndex:indexPath.row]objectForKey:@"rating"], [[rows objectAtIndex:indexPath.row]objectForKey:@"slope" ]]];
        
        if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Blue" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.75 alpha:1.0];
        }
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Black" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Gold" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.1 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"White" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Silver" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Orange" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.05 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Red" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Green" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
        }
        
        else if([[(UILabel*)[cell viewWithTag:11] text] rangeOfString:@"Yellow" options:NSCaseInsensitiveSearch].location != NSNotFound){
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.1 alpha:1.0];
        }
        
        
        else{
            [cell viewWithTag:10].backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        
    }
    return cell;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView firstOtherButtonIndex])
    {
        courseName = ((UITextField *)[alertView viewWithTag:99]).text;
        [label2 setText:courseName];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Tee", @"Select Tee");
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
    
    [label2 setText:courseName];
    
    NSLog([NSString stringWithFormat:@"selected course with id %d", [courseID intValue]]);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/yardage_iphone/"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"course_id=%d", [courseID intValue]] dataUsingEncoding:NSUTF8StringEncoding]];
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
    }
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    

    
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
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSLog(responseText);
    
    if([[[[connection originalRequest] URL]absoluteString]rangeOfString:@"create_leaderboard_iphone"].location != NSNotFound){
        JoinLeaderboardViewController* controller = [[JoinLeaderboardViewController alloc]initWithNibName:@"JoinLeaderboardViewController" bundle:nil];
        controller.leaderboardID = [self stringBetweenString:@"<id>" andString:@"</id>" forString:responseText];
        controller.leaderboardPass = [self stringBetweenString:@"<password>" andString:@"</password>" forString:responseText];
        controller.nameString = self.fname;
        controller.lastName = self.lname;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else{
    NSArray* rowsXml = [responseText componentsSeparatedByString:@"</item>"];
    
    
    rows = [[NSMutableArray alloc]init];
    
    for(NSString* rowXml in rowsXml){
        
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setValue:[self stringBetweenString:@"<id>" andString:@"</id>" forString:rowXml] forKey:@"id"];
        [tempDict setValue:[self stringBetweenString:@"<tees>" andString:@"</tees>" forString:rowXml] forKey:@"tees"];
        [tempDict setValue:[self stringBetweenString:@"<sex>" andString:@"</sex>" forString:rowXml] forKey:@"sex"];
        [tempDict setValue:[self stringBetweenString:@"<course_yardage>" andString:@"</course_yardage>" forString:rowXml] forKey:@"course_yardage"];
        [tempDict setValue:[self stringBetweenString:@"<rating>" andString:@"</rating>" forString:rowXml] forKey:@"rating"];
        [tempDict setValue:[self stringBetweenString:@"<slope>" andString:@"</slope>" forString:rowXml] forKey:@"slope"];
        [tempDict setValue:[self stringBetweenString:@"<teeid>" andString:@"</teeid>" forString:rowXml] forKey:@"teeid"];
        [tempDict setValue:[NSNumber numberWithBool:([[self stringBetweenString:@"<holes>" andString:@"</holes>" forString:rowXml] isEqualToString:@"9"])] forKey:@"isNine"];
        
        if ([tempDict objectForKey:@"id"]) {
            [rows addObject:tempDict];
        }
        
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"course_yardage"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    rows = [NSMutableArray arrayWithArray:[rows sortedArrayUsingDescriptors:sortDescriptors]];
    
    [tableView1 reloadData];
    
//    [tableView1 reloadData];
    
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:16]];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    
}


- (void)swipeRightDetected:(id)sender{
    
    if (spinnerView) {
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
