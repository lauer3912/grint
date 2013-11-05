//
//  SearchLeaderboardViewController.m
//  grint
//
//  Created by Peter Rocker on 08/05/2013.
//
//

#import "SearchLeaderboardViewController.h"
#import "SpinnerView.h"
#import "JoinLeaderboardViewController.h"

@interface SearchLeaderboardViewController ()

@property (strong, nonatomic) IBOutlet UILabel* label1;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableArray* rows;
@property (nonatomic, retain) NSMutableArray* filteredRows;
@property (nonatomic, retain) NSString* leaderboardToJoin;

@end

@implementation SearchLeaderboardViewController

@synthesize rows, filteredRows;


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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Join Leaderboard" message:@"Enter the passkey for this leaderboard to join" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Join", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = indexPath.row;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != alertView.cancelButtonIndex){
    
        JoinLeaderboardViewController* controller = [[JoinLeaderboardViewController alloc]initWithNibName:@"JoinLeaderboardViewController" bundle:nil];
        controller.leaderboardID = [[filteredRows objectAtIndex:alertView.tag]objectForKey:@"id"];
        controller.leaderboardPass = [[alertView textFieldAtIndex:0] text];
        controller.nameString = self.nameString;
        controller.lastName = self.lastName;
        [self.navigationController pushViewController:controller animated:YES];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([filteredRows count] < 1){
        return 1;
    }
    
    return [filteredRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UILabel* labelA = [[UILabel alloc]initWithFrame:CGRectMake(5, 00, 300, 20)];
        labelA.tag = 11;
        labelA.font = [UIFont fontWithName:@"Oswald" size:14.0];
        [cell addSubview:labelA];
        
        UILabel* labelB = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 300, 20)];
        labelB.tag = 12;
        labelB.font = [UIFont systemFontOfSize:12.0];
        [cell addSubview:labelB];
                
    }
    
    if([rows count] < 1){
        
        [(UILabel*)[cell viewWithTag:11] setText:@"Loading..."];
        
    }
    else if(filteredRows.count < 1){
        
        [(UILabel*)[cell viewWithTag:11] setText:@"No search results"];
        [(UILabel*)[cell viewWithTag:12] setText:@""];
    }
    else{
        
        [(UILabel*)[cell viewWithTag:11] setText:[NSString stringWithFormat:@"%@ | organizer: %@ %@", [[filteredRows objectAtIndex:indexPath.row]objectForKey:@"name"],[[filteredRows objectAtIndex:indexPath.row]objectForKey:@"user_fname"], [[filteredRows objectAtIndex:indexPath.row]objectForKey:@"user_lname" ]]];
        
        [(UILabel*)[cell viewWithTag:12] setText:[NSString stringWithFormat:@"%@ | %@", [[filteredRows objectAtIndex:indexPath.row]objectForKey:@"date"], [[filteredRows objectAtIndex:indexPath.row]objectForKey:@"coursename"]]];
        
               
    }
    return cell;
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
    
    NSLog(responseText);
    
    if([[[[connection originalRequest] URL]absoluteString]rangeOfString:@"join_leaderboard_iphone"].location != NSNotFound){
 
    }
    else{
        NSArray* rowsXml = [responseText componentsSeparatedByString:@"</leaderboard>"];
        
        rows = [[NSMutableArray alloc]init];
        
        for(NSString* rowXml in rowsXml){
            
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
            [tempDict setValue:[self stringBetweenString:@"<id>" andString:@"</id>" forString:rowXml] forKey:@"id"];
            [tempDict setValue:[self stringBetweenString:@"<name>" andString:@"</name>" forString:rowXml] forKey:@"name"];
            [tempDict setValue:[self stringBetweenString:@"<ownder_ID>" andString:@"</ownder_ID>" forString:rowXml] forKey:@"ownder_ID"];
            [tempDict setValue:[self stringBetweenString:@"<course_ID>" andString:@"</course_ID>" forString:rowXml] forKey:@"course_ID"];
            [tempDict setValue:[self stringBetweenString:@"<teebox_ID>" andString:@"</teebox_ID>" forString:rowXml] forKey:@"teebox_ID"];
            [tempDict setValue:[self stringBetweenString:@"<date>" andString:@"</date>" forString:rowXml] forKey:@"date"];
            [tempDict setValue:[self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:rowXml] forKey:@"user_fname"];
            [tempDict setValue:[self stringBetweenString:@"<user_lname>" andString:@"</user_lname>" forString:rowXml] forKey:@"user_lname"];
            [tempDict setValue:[self stringBetweenString:@"<coursename>" andString:@"</coursename>" forString:rowXml] forKey:@"coursename"];
            
            if ([tempDict objectForKey:@"id"]) {
                [rows addObject:tempDict];
            }
            
        }
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"course_yardage"
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        rows = [NSMutableArray arrayWithArray:[rows sortedArrayUsingDescriptors:sortDescriptors]];
        
        [self generateRows];
        
    }
    
}

- (void) generateRows{
    
    filteredRows = nil;
    filteredRows = [[NSMutableArray alloc]init];
    
    
    for(NSMutableDictionary* s in rows){
        
        if(searchBar1.text.length > 0){
            
            NSRange textRange;
            textRange =[[[s objectForKey:@"name"] lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
            NSRange textRange2 = [[[s objectForKey:@"user_fname"] lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
            NSRange textRange3 = [[[s objectForKey:@"user_lname"] lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
            NSRange textRange4 = [[[s objectForKey:@"coursename"] lowercaseString] rangeOfString:[searchBar1.text lowercaseString]];
            
            if(textRange.location == NSNotFound && textRange2.location == NSNotFound && textRange3.location == NSNotFound && textRange4.location == NSNotFound )
            {
                //do nothing
                
            }
            else{
                     
                [filteredRows addObject:s];
                
            }
            
        }
        else{
                [filteredRows addObject:s ];
        }
        
        
        
    }
    
    
    [tableView1 reloadData];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
       [self generateRows];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self generateRows];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [self generateRows];
    [searchBar resignFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
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
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    if(!_spinnerView)
        _spinnerView = [SpinnerView loadSpinnerIntoView:self.view];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/list_leaderboards_iphone/"]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection* connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        _data = [NSMutableData data];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
