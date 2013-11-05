//
//  GrintActivityFeedViewController.m
//  grint
//
//  Created by Peter Rocker on 05/12/2012.
//
//

#import "GrintActivityFeedViewController.h"
#import "GrintActivityFeedItem.h"
#import "GrintCourseScore.h"
#import "GrintScore.h"
#import "GrintStatsScorecardDetailViewController.h"

#import "GrintBNewReviewScore.h"

@interface GrintActivityFeedViewController ()

@end

@implementation GrintActivityFeedViewController

@synthesize username, nameString, tableData, receivedData, connection, currentID, currentUser, spinnerView1;


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

- (CGFloat)tableView:(UITableView*) tableView  heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 85.0f;
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
                
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getscore_iphone"]];
        NSString* requestBody = [NSString stringWithFormat:@"score_id=%@", self.currentID];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (connection ) {
            receivedData = [NSMutableData data];
        }
        
        spinnerView1 = [SpinnerView loadSpinnerIntoView:self.view];

        
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
   if([[connection.originalRequest.URL absoluteString] rangeOfString:@"activityfeed_iphone"].location != NSNotFound){
        
        tableData = [[NSMutableArray alloc]init];
        
        NSString* downloadTemp = [[[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"<activity>" withString:@""] stringByReplacingOccurrencesOfString:@"</activity>" withString:@""];
        
        NSLog(@"%@", downloadTemp);
        
        for(NSString* s in [downloadTemp componentsSeparatedByString:@"</item>"]){
            
            GrintActivityFeedItem* item = [[GrintActivityFeedItem alloc]init];
            
            item.title = [self stringBetweenString:@"<owner_name>" andString:@"</owner_name>" forString:s];
            item.subTitle = [self stringBetweenString:@"<message>" andString:@"</message>" forString:s];
            item.image_loc = [self stringBetweenString:@"<image>" andString:@"</image>" forString:s];
            item.scorecardId = [self stringBetweenString:@"<scorecard_id>" andString:@"</scorecard_id>" forString:s];
            item.date = [[self stringBetweenString:@"<date>" andString:@"</date>" forString:s] substringToIndex:[[self stringBetweenString:@"<date>" andString:@"</date>" forString:s]rangeOfString:@" "].location ];
            item.delegate = self;
            [item downloadThumbnail];
            [tableData addObject:item];
            
        }
        
        [tableView1 reloadData];
       
    }
    
      else{
    
          NSString* downloadTemp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
          NSString* s = downloadTemp;
          
  //  for(NSString* s in [downloadTemp componentsSeparatedByString:@"</score>"]){
        
        NSLog(s);
        
        if([s rangeOfString:@"coursename"].location != NSNotFound){
            
            GrintCourseScore* item = [[GrintCourseScore alloc]init];
            
            item.courseName = [self stringBetweenString:@"<coursename>" andString:@"</coursename>" forString:s];
                   item.date = [self stringBetweenString:@"<date>" andString:@"</date>" forString:s];
            item.courseId = [self stringBetweenString:@"<courseid>" andString:@"</courseid>" forString:s];
            item.isShort = [self stringBetweenString:@"<shortscore>" andString:@"</shortscore>" forString:s];
            item.shortScore = [self stringBetweenString:@"<scround>" andString:@"</scround>" forString:s];
            
            item.scores = [[NSMutableArray alloc]init];
            
            for(int i = 1; i <= 18; i++){
                
                GrintScore* score = [[GrintScore alloc]init];
                
                score.score = [self stringBetweenString:[NSString stringWithFormat:@"<scH%d>", i] andString:[NSString stringWithFormat:@"</scH%d>", i] forString:s];
                score.par = [self stringBetweenString:[NSString stringWithFormat:@"<par%d>", i] andString:[NSString stringWithFormat:@"</par%d>", i] forString:s];
                score.putts = [self stringBetweenString:[NSString stringWithFormat:@"<ptH%d>", i] andString:[NSString stringWithFormat:@"</ptH%d>", i] forString:s];
                score.penalty = [self stringBetweenString:[NSString stringWithFormat:@"<pH%d>", i] andString:[NSString stringWithFormat:@"</pH%d>", i] forString:s];
                score.penalty = [score.penalty uppercaseString];
              //  if([score.par intValue] > 3){
                if(YES){
                    score.fairway = [self stringBetweenString:[NSString stringWithFormat:@"<fH%d>", i] andString:[NSString stringWithFormat:@"</fH%d>", i] forString:s];
                }
                else{
                    score.fairway = @" ";
                }
                
                [item.scores addObject:score];
                
            }
            
            [item removeNulls];
        
            
//            GrintStatsScorecardDetailViewController* controller = [[GrintStatsScorecardDetailViewController alloc]initWithNibName:@"GrintStatsScorecardDetailViewController" bundle:nil];
//            controller.scores = item;
//            controller.username = currentUser;
//            [self.navigationController pushViewController:controller animated:YES];
//            [controller disableFurtherStats];
            
            GrintBNewReviewScore* controller;
            
            if ([UIScreen mainScreen].bounds.size.height > 490 || [UIScreen mainScreen].bounds.size.width > 490) {
                controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore5" bundle:nil];
            } else
                controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore" bundle:nil];
            
            controller.courseScores = item;
            controller.m_strCourseName = item.courseName;
            controller.username = self.username;
            controller.m_strUserName = [currentUser uppercaseString];
            controller.m_scores = item.scores;
            controller.m_nViewType = 2;

            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    [tableView1 reloadData];
    
    if(spinnerView1){
        [spinnerView1 removeSpinner];
        spinnerView1 = nil;
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
    
    if(spinnerView1){
        [spinnerView1 removeSpinner];
        spinnerView1 = nil;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
}

- (void)tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentID = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).scorecardId;
    currentUser = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).title;
    
    [[[UIAlertView alloc]initWithTitle:@"Full message" message:((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).subTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"View Scorecard", nil]show];
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
        UIImage* dummyImage = [UIImage imageNamed:@"grint_logo_114"];
        cell.imageView.image = dummyImage;
        cell.imageView.hidden = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 75.0,75.0)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 1;
        imageView.image = dummyImage;
        [cell addSubview:imageView];
        
        cell.detailTextLabel.numberOfLines = 3;
        
        UILabel* labelDate = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 100, 20)];
        labelDate.font = [UIFont systemFontOfSize:12];
        labelDate.tag = 2;
        [cell addSubview:labelDate];
        
        UILabel* labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(94, 5, 150, 20)];
        labelTitle.font = [UIFont boldSystemFontOfSize:16];
        labelTitle.tag = 3;
        [cell addSubview:labelTitle];
        
    }
    
    cell.textLabel.text = @" ";
    ((UILabel*)[cell viewWithTag:3]).text = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).title;
    ((UILabel*)[cell viewWithTag:2]).text = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).date;
    cell.detailTextLabel.text = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).subTitle;
    ((UIImageView*)[cell viewWithTag:1]).image = ((GrintActivityFeedItem*)[tableData objectAtIndex:indexPath.row]).thumbnail;
    return cell;
}




- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}

- (void) reloadTableData{
    [tableView1 reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/activityfeed_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@", self.username];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        receivedData = [NSMutableData data];
    }
 

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
    for(GrintActivityFeedItem* item in tableData){
        [item cancelConnection];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
 //   [label1 setText:[nameString uppercaseString]];
    [label1 setText:@"Activity Feed"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
