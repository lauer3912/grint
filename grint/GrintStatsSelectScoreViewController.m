//
//  GrintStatsSelectScoreViewController.m
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import "GrintStatsSelectScoreViewController.h"
#import "GrintScore.h"
#import "GrintCourseScore.h"
#import "GrintStatsScorecardDetailViewController.h"

#import "GrintBNewReviewScore.h"

@interface GrintStatsSelectScoreViewController ()

@end

@implementation GrintStatsSelectScoreViewController

@synthesize username, tableData, receivedData, connection, nameString, spinnerView, lastName;

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

- (void)tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
//    GrintStatsScorecardDetailViewController* controller = [[GrintStatsScorecardDetailViewController alloc]initWithNibName:@"GrintStatsScorecardDetailViewController" bundle:nil];
//    controller.scores = [tableData objectAtIndex:indexPath.row];
//    controller.username = self.username;

    GrintCourseScore* score = [tableData objectAtIndex: indexPath.row];
    GrintBNewReviewScore* controller;
    
    if ([UIScreen mainScreen].bounds.size.height > 490 || [UIScreen mainScreen].bounds.size.width > 490) {
        controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore5" bundle:nil];
    } else
        controller = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore" bundle:nil];
    
    controller.courseScores = score;
    controller.m_strCourseName = score.courseName;
    controller.courseID = [NSNumber numberWithInt: score.courseId.integerValue];
    controller.username = self.username;
    controller.m_strUserName = [[NSString stringWithFormat: @"%@ %@", self.nameString, lastName] uppercaseString];
    controller.m_scores = score.scores;
    controller.m_nViewType = 1;
    
//    controller.isNine = self.numberHoles > 8 ? NO : YES;
//    controller.nineType = self.maxHole > 8 ? @"back" : @"front";
//    //
//    //
//    controller.username = self.username;
//    controller.courseName= self.courseName;
//    controller.courseAddress= self.courseAddress;
//    controller.teeboxColor= self.teeboxColor;
//    controller.date = self.date;
//    controller.score = self.score;
//    controller.putts = self.putts;
//    controller.penalties = self.penalties;
//    controller.accuracy = self.accuracy;
//    controller.player1 = self.player1;
//    controller.player2 = self.player2;
//    controller.player3 = self.player3;
//    controller.player4 = self.player4;
//    controller.courseID = self.courseID;
//    controller.scores = self.scores;
//    controller.holeOffset = self.holeOffset;

    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]).isShort && [((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]).isShort isEqualToString:@"1"]){
         cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]) shortScore], ((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]).courseName];
    }else{
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]) getTotalScore], ((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]).courseName];
    }
    cell.detailTextLabel.text = ((GrintCourseScore*)[tableData objectAtIndex:indexPath.row]).date;
    
    return cell;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    tableData = [[NSMutableArray alloc]init];
    
    NSString* downloadTemp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    for(NSString* s in [downloadTemp componentsSeparatedByString:@"</score>"]){
        
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
        
        [tableData addObject:item];
        }
    }
    
    [tableData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        GrintCourseScore* item1 = (GrintCourseScore*)obj1;
        GrintCourseScore* item2 = (GrintCourseScore*)obj2;
        
        return -1 * [item1.date compare: item2.date];
    }];
    
    [tableView1 reloadData];
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}

- (void) reloadTableData{
    [tableView1 reloadData];
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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    label1.text = [NSString stringWithFormat:@"%@'S LATEST SCORES", [nameString uppercaseString] ];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getscores_iphone"]];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.177/grintsite2/getscores_iphone"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&limit=%d&is_nine=2", self.username, 50];
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
