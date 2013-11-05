//
//  StatsController.m
//  grint
//
//  Created by Mountain on 8/20/13.
//
//

#import "StatsController.h"
#import "SpinnerView.h"
#import "GrintWebModalViewController.h"
#import "Communication.h"

#import "GrintCourseScore.h"
#import "GrintScore.h"

#import "KxMenu.h"

//subview headers
#import "HandicapView.h"
#import "ScoreView.h"
#import "DrivingView.h"
#import "IronsView.h"
#import "GrintView.h"
#import "PenaltyView.h"
#import "ScramblingView.h"

@interface StatsController ()

@end

@implementation StatsController
{
    NSMutableArray* menuItems;
    int m_nContentType;
    int m_nPickerType;
    
    SpinnerView* spinnerView;
    
    NSMutableData* receivedData;
    
    //course list
    NSMutableArray* m_courseList;
    NSMutableArray* m_courseIdList;
    
    //handicap & friend list
    NSMutableArray* friendsList;
    NSMutableArray* handicapList;
    NSMutableArray* courseHandicapList;
    NSMutableArray* friendFnameList;
    NSMutableArray* friendLnameList;
    
    //bottom bar values
    int m_nGolferIndex;
    int m_nCourseIndex;
    int m_nRoundIndex;
    int m_nHoleIndex;
    
    Communication* m_comm;
    
    float m_rHcpValues[6];
    NSArray* arrayContents;
    
    BOOL m_FShow;
    
    GrintWebModalViewController* m_trendController;
    
    //score data
    NSMutableArray* m_arrayScoreList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initContentType];
        
        m_comm = [[Communication alloc] init];
        
        m_arrayScoreList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) initContentType
{
    arrayContents = [[NSArray alloc]  initWithObjects:@"TYPE OF GRAPH", @"Handicap", @"Scoring", @"Putting", @"Greens in Regulation", @"Driving Accuracy", @"Irons Accuracy", @"Grints", @"Penalties", @"Scrambling", @"Trend Graphs", nil];
    menuItems = [[NSMutableArray alloc] init];
    KxMenuItem* item;
    for (int nIdx = 0; nIdx < [arrayContents count]; nIdx ++) {
        if (nIdx == 0) {
            item = [KxMenuItem menuItem: [arrayContents objectAtIndex: nIdx]
                                  image:nil
                                 target:nil
                                 action:NULL
                                    tag: nIdx];
        } else {
            item = [KxMenuItem menuItem: [arrayContents objectAtIndex: nIdx]
                                  image:nil
                                 target:self
                                 action:@selector(pushMenuItem:)
                                    tag: nIdx];
        }
        
        [menuItems addObject: item];
    }
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateDots];
    
    [_m_labelCaption setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [_m_labelTitle setFont:[UIFont fontWithName:@"Oswald" size:22.0]];
    [_m_labelExtra setFont:[UIFont fontWithName:@"Oswald" size:17.0]];

    [_m_labelGolfer setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_m_labelCourse setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_m_labelRounds setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [_m_labelType setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    
    [_m_labelTop setFont:[UIFont fontWithName:@"Calibri" size:16.0]];
    [_m_label11 setFont:[UIFont fontWithName:@"Calibri" size:15.0]];
    [_m_label12 setFont:[UIFont fontWithName:@"Calibri" size:15.0]];
    [_m_label13 setFont:[UIFont fontWithName:@"Calibri" size:15.0]];
    [_m_label14 setFont:[UIFont fontWithName:@"Calibri" size:15.0]];
    
    //handicap view
    [m_hcpView.m_labelHcpIndex setFont:[UIFont fontWithName:@"Oswald" size:30.0]];
    [m_hcpView.m_labelTrendHcp setFont:[UIFont fontWithName:@"Oswald" size:17.0]];
    
    ///score view
    [m_scoreView.m_label1 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scoreView.m_label2 setFont: [UIFont fontWithName: @"Oswald" size: 28]];
    [m_scoreView.m_label3 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scoreView.m_label4 setFont: [UIFont fontWithName: @"Oswald" size: 16]];
    [m_scoreView.m_label5 setFont: [UIFont fontWithName: @"Oswald" size: 16]];
    [m_scoreView.m_label6 setFont: [UIFont fontWithName: @"Oswald" size: 16]];
    [m_scoreView.m_label7 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scoreView.m_label8 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scoreView.m_label9 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    
    //scrambling view
    [m_scramblingView.m_label1 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scramblingView.m_label2 setFont: [UIFont fontWithName: @"Oswald" size: 28]];
    [m_scramblingView.m_label3 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_scramblingView.m_label4 setFont: [UIFont fontWithName: @"Oswald" size: 19]];
    [m_scramblingView.m_label5 setFont: [UIFont fontWithName: @"Oswald" size: 19]];
    [m_scramblingView.m_label6 setFont: [UIFont fontWithName: @"Oswald" size: 19]];
    
    //driving view
    [m_drivingView.m_labelLeft setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_drivingView.m_labelHit setFont: [UIFont fontWithName: @"Oswald" size: 30]];
    [m_drivingView.m_labelRight setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_drivingView.m_labelShort setFont: [UIFont fontWithName: @"Oswald" size: 20]];

    [m_drivingView.m_labelPar4 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    [m_drivingView.m_labelPar5 setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    
    //iron view
    [m_ironsView.m_labelHit setFont: [UIFont fontWithName: @"Oswald" size: 25]];
    [m_ironsView.m_labelLeft setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_ironsView.m_labelRight setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_ironsView.m_labelLong setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_ironsView.m_labelShort setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [m_ironsView.m_labelMissed setFont: [UIFont fontWithName: @"Oswald" size: 18]];
    
    for (int i = 1; i < 6; i++)
         [((UILabel*)[m_ironsView viewWithTag: i]) setFont: [UIFont fontWithName: @"Oswald" size: 17]];
    
    //grint view
    [m_grintView.m_labelCenterCircle setFont: [UIFont fontWithName: @"Oswald" size: 28]];
    for (int i = 4; i < 7; i++)
        [((UILabel*)[m_grintView viewWithTag: i]) setFont: [UIFont fontWithName: @"Oswald" size: 19]];

    //penalty view
    [m_penaltyView.m_labelTop setFont: [UIFont fontWithName: @"Oswald" size: 30]];
    for (int i = 4; i < 7; i++)
        [((UILabel*)[m_penaltyView viewWithTag: i]) setFont: [UIFont fontWithName: @"Oswald" size: 19]];

    UISwipeGestureRecognizer* swipeNext = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(goNextGraph:)];
    swipeNext.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeNext];

    UISwipeGestureRecognizer* swipePrev = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(goPrevGraph:)];
    swipePrev.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipePrev];
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    _m_labelExtra.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    if (!m_FShow) {
        m_trendController = [[GrintWebModalViewController alloc] initWithNibName:@"GrintWebModalViewController" bundle:nil];
        m_trendController.m_strURL = @"https://www.thegrint.com/trend";

        [self loadInitData];
        
        [self loadScoreData];
        [self showGraphScreen];
        
        [spinnerView removeSpinner];
        spinnerView = nil;
        
        m_FShow = YES;
        
        [self updateDots];
    }
}

- (void) loadScoreData
{
    if (m_arrayScoreList && [m_arrayScoreList count] > 0) {
        [m_arrayScoreList removeAllObjects];
    }
    int anLimits[] = {20, 10, 5, 500};
    int nLimit = anLimits[m_nRoundIndex];
    
    NSMutableString* requestBody;
    
    NSString* strUser = (m_nGolferIndex == 0) ? self.username : [friendsList objectAtIndex: m_nGolferIndex-1];
    
    if (m_nHoleIndex == 0) {
        requestBody = [NSMutableString stringWithFormat:@"username=%@&limit=%d&is_nine=0", strUser, nLimit];
    } else if (m_nHoleIndex == 1) {
        requestBody = [NSMutableString stringWithFormat:@"username=%@&limit=%d&is_nine=1", strUser, nLimit];
    } else {
        requestBody = [NSMutableString stringWithFormat:@"username=%@&limit=%d&is_nine=2", strUser, nLimit];
    }
    
    if (m_nCourseIndex > 0) {
        [requestBody appendFormat:@"&course_id=%@", (NSString*)[m_courseIdList objectAtIndex: m_nCourseIndex - 1]];
    }
    
    NSString* downloadTemp = [m_comm sendRequest:@"https://www.thegrint.com/getscores_iphone" PARAM: requestBody];
//    NSString* downloadTemp = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/getscores_iphone" PARAM: requestBody];
    if (downloadTemp == nil || [downloadTemp isEqualToString: @""])
        return;
    
    for(NSString* s in [downloadTemp componentsSeparatedByString:@"</score>"]){
        
        NSLog(@"Scores : %@", s);
        
        if([s rangeOfString:@"coursename"].location != NSNotFound){
            
            GrintCourseScore* item = [[GrintCourseScore alloc] init];
            
            item.courseName = [self stringBetweenString:@"<coursename>" andString:@"</coursename>" forString:s];
            item.date = [self stringBetweenString:@"<date>" andString:@"</date>" forString:s];
            item.courseId = [self stringBetweenString:@"<courseid>" andString:@"</courseid>" forString:s];
            item.isShort = [self stringBetweenString:@"<shortscore>" andString:@"</shortscore>" forString:s];
//            if ([item.isShort integerValue] > 0) {
//                [item removeNulls];
//                continue;
//            }
            item.shortScore = [self stringBetweenString:@"<scround>" andString:@"</scround>" forString:s];
            
            item.scores = [[NSMutableArray alloc]init];
            
            for(int i = 1; i <= 18; i++){
                
                GrintScore* score = [[GrintScore alloc]init];
                
                score.score = [self stringBetweenString:[NSString stringWithFormat:@"<scH%d>", i] andString:[NSString stringWithFormat:@"</scH%d>", i] forString:s];
                score.par = [self stringBetweenString:[NSString stringWithFormat:@"<par%d>", i] andString:[NSString stringWithFormat:@"</par%d>", i] forString:s];
                score.gir = [self stringBetweenString:[NSString stringWithFormat:@"<girH%d>", i] andString:[NSString stringWithFormat:@"</girH%d>", i] forString:s];
                score.putts = [self stringBetweenString:[NSString stringWithFormat:@"<ptH%d>", i] andString:[NSString stringWithFormat:@"</ptH%d>", i] forString:s];
                score.penalty = [self stringBetweenString:[NSString stringWithFormat:@"<pH%d>", i] andString:[NSString stringWithFormat:@"</pH%d>", i] forString:s];
                score.penalty = [score.penalty uppercaseString];
                //  if([score.par intValue] > 3){
                score.fairway = [self stringBetweenString:[NSString stringWithFormat:@"<fH%d>", i] andString:[NSString stringWithFormat:@"</fH%d>", i] forString:s];
                score.yard = [self stringBetweenString:[NSString stringWithFormat:@"<yardH%d>", i] andString:[NSString stringWithFormat:@"</yardH%d>", i] forString:s];

//                if(YES){
//                }
//                else{
//                    score.fairway = @" ";
//                }
                [item.scores addObject:score];
            }
            
            [m_arrayScoreList addObject: item];
            //[item removeNulls];
        }
    }
}

- (void) showGraph: (UIView*) view
{
    if (_m_contentView.frame.size.height >= view.frame.size.height) {
        [_m_contentView setContentSize: CGSizeMake(320, _m_contentView.frame.size.height)];
    } else {
        [_m_contentView setContentSize: CGSizeMake(320, view.frame.size.height)];
    }
    
    [self.m_contentView addSubview: view];
}

- (void) loadInitData
{
    if (![self loadCourseInfo])
        return;
//    if (![self loadCourseStatsInfo:self.username COURSE_ID: -1])
//        return;
    if (![self loadFriendInfo: 1])//[[m_courseIdList objectAtIndex: 0] integerValue]])
        return;
}

- (BOOL) loadCourseInfo
{
    //get course information
    NSString* requestBody = [NSString stringWithFormat:@"username=%@", self.username];
    NSString* strResult = [m_comm sendRequest:@"https://www.thegrint.com/pastcourses_iphone" PARAM: requestBody];
//    NSString* strResult = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/pastcourses_iphone" PARAM: requestBody];
    if (strResult == nil || [strResult isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
        
    m_courseList = [[NSMutableArray alloc]init];
    m_courseIdList = [[NSMutableArray alloc]init];
    
    NSLog(@"Received Data : %@", strResult);
    
    for (NSString* s in [strResult componentsSeparatedByString:@"</item>"]) {
        NSString* t = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
        NSString* u = [self stringBetweenString:@"<id>" andString:@"</id>" forString:s];
        
        if(t && u && t.length > 0 && u.length > 0){
            [m_courseList addObject:t];
            [m_courseIdList addObject:u];
        }
    }
    
    return YES;
}

- (BOOL) loadCourseStatsInfo: (NSString*) strUserName COURSE_ID: (int) nCourseId
{
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d", strUserName, nCourseId];
    NSString* strResult = [m_comm sendRequest:@"https://www.thegrint.com/coursestats_iphone" PARAM: requestBody];
    if (strResult == nil || [strResult isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    //        labelScore.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_course>" andString:@"</avgscore_course>" forString:responseText]floatValue]];
    //        labelPutts.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_course>" andString:@"</avgputts_course>" forString:responseText]floatValue]];
    //        labelHazards.text  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_course>" andString:@"</avgpenalty_course>" forString:responseText]floatValue]];
    //        labelTeeAcc.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_course>" andString:@"</teeaccuracy_course>" forString:responseText]floatValue])];
    //        labelGIR.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_course>" andString:@"</avggir_course>" forString:responseText]floatValue])];
    //        labelGrints.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_course>" andString:@"</grints_course>" forString:responseText]floatValue])];
    //        if(![labelGrints.text isEqualToString:@"0"]){
    //            labelGrints.hidden = NO;
    //            labelGrintsLabel.hidden = NO;
    //        }
    
    return YES;
}

- (BOOL) loadFriendInfo: (int) nCourseId
{
    
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d", self.username, nCourseId];
    NSString* responseText = [m_comm sendRequest:@"https://www.thegrint.com/getfriends_iphone" PARAM: requestBody];
//    NSString* responseText = [m_comm sendRequest:@"http://192.168.1.177/grintsite2/getfriends_iphone" PARAM: requestBody];
    if (responseText == nil || [responseText isEqualToString: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    NSLog(@"%@", responseText);
    
    friendsList = [[NSMutableArray alloc]init];
    handicapList = [[NSMutableArray alloc]init];
    courseHandicapList = [[NSMutableArray alloc]init];
    friendFnameList = [[NSMutableArray alloc]init];
    friendLnameList = [[NSMutableArray alloc]init];
    
    m_rHcpValues[0] = [[self stringBetweenString:@"<self_handicap>" andString:@"</self_handicap>" forString:responseText] floatValue];
    m_rHcpValues[1] = [[self stringBetweenString:@"<self_official_index>" andString:@"</self_official_index>" forString:responseText] floatValue];
    m_rHcpValues[2] = [[self stringBetweenString:@"<self_handicap_n>" andString:@"</self_handicap_n>" forString:responseText] floatValue];
    m_rHcpValues[3] = [[self stringBetweenString:@"<self_official_index_n>" andString:@"</self_official_index_n>" forString:responseText] floatValue];
    m_rHcpValues[4] = [[self stringBetweenString:@"<self_trend_handicap>" andString:@"</self_trend_handicap>" forString:responseText] floatValue];
    m_rHcpValues[5] = [[self stringBetweenString:@"<self_coursehandicap_n>" andString:@"</self_trend_handicap_n>" forString:responseText] floatValue];
    
//    m_hcpView.m_rTrendHcpValue = m_rTrendHcpValue;
//    m_rHcpValue = [[self stringBetweenString:@"<self_handicap>" andString:@"</self_handicap>" forString:responseText] floatValue];
//    m_hcpView.m_rHcpValue = m_rHcpValue;
    m_hcpView.m_rTrendHcpValue = m_rHcpValues[4];
    m_hcpView.m_rHcpValue = m_rHcpValues[0];
    m_hcpView.m_nHoleType = 0;
    m_hcpView.m_FGrayHcp = ((int)m_rHcpValues[1] > 0) ? YES : NO;
    
    if (m_nContentType == 0) {
        [m_hcpView setNeedsDisplay];
    }
    
    for(NSString* s in [responseText componentsSeparatedByString:@"</friend>"]){
        
        if(s.length > 11){
            
            NSString* p = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
            
            if(p && p.length > 0)
                [friendsList addObject:p];
            
            p = [self stringBetweenString:@"<handicap>" andString:@"</handicap>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];

            p = [self stringBetweenString:@"<official_index>" andString:@"</official_index>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];

            p = [self stringBetweenString:@"<handicap_n>" andString:@"</handicap_n>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];

            p = [self stringBetweenString:@"<official_index_n>" andString:@"</official_index_n>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];

            p = [self stringBetweenString:@"<trend_handicap>" andString:@"</trend_handicap>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];

            p = [self stringBetweenString:@"<trend_handicap_n>" andString:@"</trend_handicap_n>" forString:s];
            if(p && p.length > 0)
                [handicapList addObject:p];
            else
                [handicapList addObject:@"0"];
            
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
    
    return YES;
}

- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
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
//
//- (void)connectionDidFinishLoading:(NSURLConnection *) connection
//{
//    
//    if(spinnerView){
//        [spinnerView removeSpinner];
//        spinnerView = nil;
//    }
//    
//    if([[[connection.originalRequest URL] absoluteString] rangeOfString:@"pastcourses_iphone"].location != NSNotFound) {
//        
//        
////        [picker1 reloadAllComponents];
//        
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLConnection* conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];
//        if (conn) {
//            receivedData = [NSMutableData data];
//        }
//        
//        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
//        
////        [picker1 setHidden:YES];
////        [navigationBar1 setHidden:YES];
//    }
//    
//    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/coursestats_iphone"]) {
//        NSString* responseText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//        NSLog(@"Received Data : %@", responseText);
//        
//        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone"]];
//        NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%@", self.username, @"1"];
//        [request setHTTPMethod:@"POST"];
//        [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSURLConnection* conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];
//        if (conn) {
//            receivedData = [NSMutableData data];
//        }
//        
//        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
//    }
//    
//    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/getfriends_iphone"]){
//        
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [receivedData setLength:0];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [receivedData appendData:data];
//    
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    
//    if(spinnerView){
//        [spinnerView removeSpinner];
//        spinnerView = nil;
//    }
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    
//}


- (void) updateDots
{
    self.m_currentPage.currentPage = m_nContentType;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL isAtLeast7 = [version floatValue] >= 7.0;
    
    for (int nIdx = 0; nIdx < [self.m_currentPage.subviews count]; nIdx ++) {
        UIImageView* item = [[self.m_currentPage subviews] objectAtIndex: nIdx];
        if (!isAtLeast7) {
            if (self.m_currentPage.currentPage == nIdx) {
                [item setImage: [UIImage imageNamed: @"page_item_select.png"]];
            } else {
                [item setImage: [UIImage imageNamed: @"page_item_normal.png"]];
            }
        } else {
            UIImageView* imgView = nil;
            for (UIView* subview in item.subviews) {
                if ([subview isKindOfClass: [UIImageView class]]) {
                    imgView = (UIImageView*)subview;
                    break;
                }
            }
            if (imgView == nil) {
                imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, item.frame.size.width, item.frame.size.height)];
                [item addSubview:imgView];
            }
            if (self.m_currentPage.currentPage == nIdx) {
                [imgView setImage: [UIImage imageNamed: @"page_item_select.png"]];
            } else {
                [imgView setImage: [UIImage imageNamed: @"page_item_normal.png"]];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.m_pickerView.hidden = YES;
    self.m_navBar.hidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];

    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showActivity
{
    spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
}
- (IBAction)actionDone:(id)sender {
    
    _m_pickerView.hidden = YES;
    _m_navBar.hidden = YES;
    
    int nRow = [_m_pickerView selectedRowInComponent: 0];
    if (nRow < 0)
        return;
    
    switch (m_nPickerType) {
        case 0:
        {
            if (m_nGolferIndex == nRow)
                return;
            [NSThread detachNewThreadSelector:@selector(showActivity) toTarget: self withObject: nil];
            m_nGolferIndex = nRow;
            NSString* strGolfer;
            if (nRow == 0) {
                strGolfer = @"Me";
            } else {
                strGolfer = [NSString stringWithFormat:@"%@ %@", [friendFnameList objectAtIndex:nRow-1], [friendLnameList objectAtIndex:nRow-1]];
            }
            _m_labelGolfer.text =  strGolfer;
            
            [self changeGolfer];
            
            break;
        }
        case 1:
        {
            if (m_nCourseIndex == nRow)
                return;
            [NSThread detachNewThreadSelector:@selector(showActivity) toTarget: self withObject: nil];
            m_nCourseIndex = nRow;
            if (nRow == 0) {
                _m_labelCourse.text = @"All Golf Courses";
            } else
                _m_labelCourse.text = [m_courseList objectAtIndex: nRow-1];
            
            [self changeCourse];
            break;
        }
        case 2: //rounds
        {
            if (m_nRoundIndex == nRow)
                return;
            [NSThread detachNewThreadSelector:@selector(showActivity) toTarget: self withObject: nil];
            m_nRoundIndex = nRow;
            NSArray* arrayTemp = [NSArray arrayWithObjects:@"20", @"10", @"5", @"All", nil];
            _m_labelRounds.text = [arrayTemp objectAtIndex: nRow];
            
            [self changeRounds];
            break;
        }
        case 3: //hole type
        {
            if (m_nHoleIndex == nRow)
                return;
            [NSThread detachNewThreadSelector:@selector(showActivity) toTarget: self withObject: nil];
            m_nHoleIndex = nRow;
            NSArray* arrayTemp = [NSArray arrayWithObjects:@"18 Holes", @"9 Holes", @"Combined", nil];
            _m_labelType.text = [arrayTemp objectAtIndex: nRow];
            
            [self changeHoleType];
            break;
        }
    }
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

///////////actions of bottom bar buttons//////////////
- (IBAction)actionSelectHole:(id)sender {
    m_nPickerType = 3;
//    if ([_m_pickerView numberOfRowsInComponent:0] > 0)
//        [_m_pickerView selectedRowInComponent: 0];
    [_m_pickerView reloadAllComponents];
    [_m_pickerView selectRow:m_nHoleIndex inComponent:0 animated:YES];
    
    _m_pickerView.hidden = NO;
    _m_navBar.hidden = NO;
}

- (IBAction)actionSelectRounds:(id)sender {
    m_nPickerType = 2;
//    if ([_m_pickerView numberOfRowsInComponent:0] > 0)
//        [_m_pickerView selectedRowInComponent: 0];
    [_m_pickerView reloadAllComponents];
    [_m_pickerView selectRow:m_nRoundIndex inComponent:0 animated:YES];
    
    _m_pickerView.hidden = NO;
    _m_navBar.hidden = NO;
}

- (IBAction)actionSelectCourse:(id)sender {
    m_nPickerType = 1;
//    if ([_m_pickerView numberOfRowsInComponent:0] > 0)
//        [_m_pickerView selectedRowInComponent: 0];
    [_m_pickerView reloadAllComponents];
    [_m_pickerView selectRow:m_nCourseIndex inComponent:0 animated:YES];
    
    _m_pickerView.hidden = NO;
    _m_navBar.hidden = NO;
}

- (IBAction)actionSelectFriends:(id)sender {
    m_nPickerType = 0;
//    if ([_m_pickerView numberOfRowsInComponent:0] > 0)
//        [_m_pickerView selectedRowInComponent: 0];
    [_m_pickerView reloadAllComponents];
    [_m_pickerView selectRow:m_nGolferIndex inComponent:0 animated:YES];
    
    _m_pickerView.hidden = NO;
    _m_navBar.hidden = NO;
}

- (IBAction)actionHandicap:(id)sender {
    GrintWebModalViewController* hcpView = [[GrintWebModalViewController alloc] initWithNibName: @"GrintWebModalViewController" bundle: nil];
    hcpView.m_strURL = @"http://www.thegrint.com/clubs/hdcp_card";
    [self.navigationController pushViewController: hcpView animated: YES];
}

- (void) goNextGraph:(id)sender {
    if (m_nContentType == [[_m_currentPage subviews] count] - 2) {
        [self.navigationController pushViewController: m_trendController animated: YES];
        return;
    } else if (m_nContentType < [[_m_currentPage subviews] count] - 2) {
        m_nContentType ++;
        [self updateDots];
        [self showGraphScreen];
    }
}

- (void) goPrevGraph:(id)sender {
    if (m_nContentType > 0) {
        m_nContentType --;
        [self updateDots];
        
        if (m_nContentType == 0) {
            if (m_nHoleIndex > 1) {
                m_nHoleIndex = 0;
                _m_labelType.text = @"18 Holes";
            }
            
            if (m_nGolferIndex == 0) {// me
                m_hcpView.m_rHcpValue = m_rHcpValues[0 + 2 * m_nHoleIndex];
                m_hcpView.m_rTrendHcpValue = m_rHcpValues[4 + m_nHoleIndex];
                m_hcpView.m_nHoleType = m_nHoleIndex;
                m_hcpView.m_FGrayHcp = ((int)m_rHcpValues[1 + 2 * m_nHoleIndex]) > 0 ? YES : NO;
            } else {
                m_hcpView.m_rHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 2 * m_nHoleIndex] floatValue];
                m_hcpView.m_rTrendHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 4 + m_nHoleIndex] floatValue];
                m_hcpView.m_nHoleType = m_nHoleIndex;
                int nOfficalIndex = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 1 + 2 * m_nHoleIndex] integerValue];
                m_hcpView.m_FGrayHcp = nOfficalIndex > 0 ? YES : NO;
            }
            [m_hcpView setNeedsDisplay];
        }

        [self showGraphScreen];
    }
}


/////////////action of content type button ////////////
- (IBAction)actionContentType:(id)sender {
    
    if (_m_pickerView.hidden == NO)
        return;
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:((UIButton*)sender).frame
                 menuItems:menuItems
                      type: 0];
}

- (void) clearContentView
{
    for (UIView* view in _m_contentView.subviews) {
        [view removeFromSuperview];
    }
}

- (void) setLabelTitleOfScore: (NSArray*) arrayText
{
    if (arrayText == nil)
        return;
    m_scoreView.m_labelLeft.text = [arrayText objectAtIndex: 0];
    m_scoreView.m_labelCenter.text = [arrayText objectAtIndex: 1];
    m_scoreView.m_labelRight.text = [arrayText objectAtIndex: 2];
    m_scoreView.m_labelExtraLeft.text = [arrayText objectAtIndex: 3];
    m_scoreView.m_labelExtraCenter.text = [arrayText objectAtIndex: 4];
    m_scoreView.m_labelExtraRight.text = [arrayText objectAtIndex: 5];
}

- (void) setLabelValueOfScore: (NSArray*) arrayText
{
    if (arrayText == nil)
        return;
    m_scoreView.m_label1.text = [arrayText objectAtIndex: 0];
    m_scoreView.m_label2.text = [arrayText objectAtIndex: 1];
    m_scoreView.m_label3.text = [arrayText objectAtIndex: 2];
    m_scoreView.m_label4.text = [arrayText objectAtIndex: 3];
    m_scoreView.m_label5.text = [arrayText objectAtIndex: 4];
    m_scoreView.m_label6.text = [arrayText objectAtIndex: 5];
    m_scoreView.m_label7.text = [arrayText objectAtIndex: 6];
    m_scoreView.m_label8.text = [arrayText objectAtIndex: 7];
    m_scoreView.m_label9.text = [arrayText objectAtIndex: 8];
}

- (void) setLabelValueOfScrambling: (NSArray*) arrayText
{
    if (arrayText == nil)
        return;
    m_scramblingView.m_label1.text = [arrayText objectAtIndex: 0];
    m_scramblingView.m_label2.text = [arrayText objectAtIndex: 1];
    m_scramblingView.m_label3.text = [arrayText objectAtIndex: 2];
    m_scramblingView.m_label4.text = [arrayText objectAtIndex: 3];
    m_scramblingView.m_label5.text = [arrayText objectAtIndex: 4];
    m_scramblingView.m_label6.text = [arrayText objectAtIndex: 5];
}

- (void) setLabelValueOfDriving: (NSArray*) arrayText
{
    if (arrayText == nil)
        return;
    m_drivingView.m_labelLeft.text = [arrayText objectAtIndex: 0];
    m_drivingView.m_labelRight.text = [arrayText objectAtIndex: 1];
    m_drivingView.m_labelHit.text = [arrayText objectAtIndex: 2];
    m_drivingView.m_labelShort.text = [arrayText objectAtIndex: 3];
   
    m_drivingView.m_labelPar4.text = [arrayText objectAtIndex: 4];
    m_drivingView.m_labelPar5.text = [arrayText objectAtIndex: 5];
}

- (void) setLabelValueOfIrons: (NSArray*) arrayText
{
    if (arrayText == nil)
        return;
    m_ironsView.m_labelLeft.text = [arrayText objectAtIndex: 0];
    m_ironsView.m_labelRight.text = [arrayText objectAtIndex: 1];
    m_ironsView.m_labelHit.text = [arrayText objectAtIndex: 2];
    m_ironsView.m_labelShort.text = [arrayText objectAtIndex: 3];
    
    m_ironsView.m_labelMissed.text = [arrayText objectAtIndex: 4];
    m_ironsView.m_labelLong.text = [arrayText objectAtIndex: 5];
    
    for (int nIdx = 1; nIdx < 6; nIdx ++) {
        ((UILabel*)[m_ironsView viewWithTag:nIdx]).text = [arrayText objectAtIndex: nIdx + 5];
    }
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = ((KxMenuItem*)sender);
    int nContentType = item.nTag;
    if (nContentType == [[_m_currentPage subviews] count]) {
//        [self presentViewController: controller animated:YES completion:nil];
        [self.navigationController pushViewController: m_trendController animated: YES];
        return;
    }
    self.m_currentPage.currentPage = nContentType - 1;
    
    if (m_nContentType == nContentType - 1)
        return;
    
    m_nContentType = nContentType - 1;

    [self updateDots];

    if (m_nContentType == 0) {
        if (m_nHoleIndex > 1) {
            m_nHoleIndex = 0;
            _m_labelType.text = @"18 Holes";
        }
        
        if (m_nGolferIndex == 0) {// me
            m_hcpView.m_rHcpValue = m_rHcpValues[0 + 2 * m_nHoleIndex];
            m_hcpView.m_rTrendHcpValue = m_rHcpValues[4 + m_nHoleIndex];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            m_hcpView.m_FGrayHcp = ((int)m_rHcpValues[1 + 2 * m_nHoleIndex]) > 0 ? YES : NO;
        } else {
            m_hcpView.m_rHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 2 * m_nHoleIndex] floatValue];
            m_hcpView.m_rTrendHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 4 + m_nHoleIndex] floatValue];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            int nOfficalIndex = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 1 + 2 * m_nHoleIndex] integerValue];
            m_hcpView.m_FGrayHcp = nOfficalIndex > 0 ? YES : NO;
        }
        [m_hcpView setNeedsDisplay];
    }
    [self showGraphScreen];
}

- (void) showGraphScreen
{
    [self clearContentView];
    switch (m_nContentType) {
        case 0: //handicap
        {
            [_m_contentView addSubview: m_hcpView];
            break;
        }
        case 1: //scoring
        {
            NSArray* arrayText = [NSArray arrayWithObjects:@"Best", @"Avg.Score", @"Worst", @"Par 3's", @"Par 4's", @"Par 5's", nil];
            [self setLabelTitleOfScore: arrayText];
            
            NSArray* arrayValues = [self calcScoring];
            [self setLabelValueOfScore: arrayValues];
            
            [_m_contentView addSubview: m_scoreView];
            break;
        }
        case 2: //putt
        {
            NSArray* arrayText = [NSArray arrayWithObjects:@"Best", @"Putts per round", @"Worst", @"GIR Putts", @"Non GIR", @"1 Putts/round", nil];
            [self setLabelTitleOfScore: arrayText];
            NSArray* arrayValues = [self calcPutting];
            [self setLabelValueOfScore: arrayValues];
            
            [_m_contentView addSubview: m_scoreView];
            break;
        }
        case 3: //green
        {
            NSArray* arrayText = [NSArray arrayWithObjects:@"Best", @"GIR", @"Worst", @"Par 3's", @"Par 4's", @"Par 5's", nil];
            [self setLabelTitleOfScore: arrayText];
            NSArray* arrayValues = [self calcGIR];
            [self setLabelValueOfScore: arrayValues];

            [_m_contentView addSubview: m_scoreView];
            break;
        }
        case 4: //driviing accuracy
        {
            NSArray* arrayValues = [self calcDriving];
            [self setLabelValueOfDriving: arrayValues];

            [_m_contentView addSubview: m_drivingView];
            break;
        }
        case 5: //irons accuracy
        {
            NSArray* arrayValues = [self calcIrons];
            [self setLabelValueOfIrons: arrayValues];

            [_m_contentView addSubview: m_ironsView];
            break;
        }
        case 6: //Grints
        {
//            float a[] = {3, 7, 15, 30, 45, 0};
//            NSMutableArray* array = [[NSMutableArray alloc] init];
//            for (int nIdx = 0; nIdx < 6; nIdx ++) {
//                [array addObject: [NSNumber numberWithFloat: a[nIdx]]];
//            }
            m_grintView.m_arrayData = [self calcGrints];
            [m_grintView setNeedsDisplay];
            [_m_contentView addSubview: m_grintView];
            break;
        }
        case 7: //Penalty
        {
//            float a[] = {0.1, 0.3, 0.7, 1.5, 1.6};
//            NSMutableArray* array = [[NSMutableArray alloc] init];
//            for (int nIdx = 0; nIdx < 5; nIdx ++) {
//                [array addObject: [NSNumber numberWithFloat: a[nIdx]]];
//            }
            m_penaltyView.m_arrayData = [self calcPenalty];
            [m_penaltyView setNeedsDisplay];
            
            [_m_contentView addSubview: m_penaltyView];
            break;
        }
        case 8: //scrambling
        {
            NSArray* arrayText = [self calcScrambling];
            [self setLabelValueOfScrambling: arrayText];
            [_m_contentView addSubview: m_scramblingView];
            break;
        }
        default:
            break;
    }
    
    NSString* strTitle;
    if (m_nContentType == 4) {
        strTitle = [NSString stringWithFormat:@"%@            ", ((NSString*)[arrayContents objectAtIndex: m_nContentType + 1]).uppercaseString];
        _m_labelExtra.hidden = NO;
        _m_labelExtra.text = @"(Par 4&5)";
        
        CGRect rect = _m_labelExtra.frame;
        rect.origin.x = 240;
        _m_labelExtra.frame = rect;
    } else if (m_nContentType == 5) {
        strTitle = [NSString stringWithFormat:@"%@          ", ((NSString*)[arrayContents objectAtIndex: m_nContentType + 1]).uppercaseString];
        _m_labelExtra.hidden = NO;
        _m_labelExtra.text = @"(Par 3's)";
        CGRect rect = _m_labelExtra.frame;
        rect.origin.x = 225;
        _m_labelExtra.frame = rect;
    } else {
        strTitle = [NSString stringWithFormat:@"%@", ((NSString*)[arrayContents objectAtIndex: m_nContentType + 1]).uppercaseString];
        _m_labelExtra.hidden = YES;
    }
    
    [self.m_labelTitle setText: strTitle];
    
    NSLog(@"Current Content Graph = %d", m_nContentType + 1);
}


//back button action
- (IBAction)actionGoBack:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}


//picker view delegate methods
- (void) pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (m_nPickerType) {
        case 0: //me and my friends
            return [friendsList count] + 1;
            break;
        case 1: //course name
            return [m_courseList count];
            break;
        case 2: //rounds
            return 4;
            break;
        case 3: //hole type
            if (m_nContentType == 0 || m_nContentType == 1 || m_nContentType == 2 || m_nContentType == 7) {
                return 2;
            } else {
                return 3;
            }
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (m_nPickerType) {
        case 0: //me and my friends
            if (row == m_nGolferIndex) {
                [pickerView selectRow: row inComponent: 0 animated: NO];
            }
            if (row == 0) {
                return @"Me";
            } else {
                return [NSString stringWithFormat:@"%@ %@", [friendFnameList objectAtIndex:row-1], [friendLnameList objectAtIndex:row-1]];
            }
            break;
        case 1: //course name
            if (row == m_nCourseIndex) {
                [pickerView selectRow: row inComponent: 0 animated: NO];
            }
            if (row == 0) {
                return @"All Golf Courses";
            } else
                return [m_courseList objectAtIndex: row-1];
            break;
        case 2: //rounds
        {
            if (row == m_nRoundIndex) {
                [pickerView selectRow: row inComponent: 0 animated: NO];
            }
            NSArray* arrayTemp = [NSArray arrayWithObjects:@"20", @"10", @"5", @"All", nil];
            return [arrayTemp objectAtIndex: row];
            break;
        }
        case 3: //hole type
        {
            if (row == m_nHoleIndex) {
                [pickerView selectRow: row inComponent: 0 animated: NO];
            }
            if (m_nContentType == 0 || m_nContentType == 1 || m_nContentType == 2 || m_nContentType == 7) {
                NSArray* arrayTemp = [NSArray arrayWithObjects:@"18 Holes", @"9 Holes", nil];
                return [arrayTemp objectAtIndex: row];
            } else {
                NSArray* arrayTemp = [NSArray arrayWithObjects:@"18 Holes", @"9 Holes", @"Combined", nil];
                return [arrayTemp objectAtIndex: row];
            }
            break;
        }
        default:
            break;
    }
    
    return @"";
}


- (void) changeGolfer
{
    if (m_nContentType == 0) { // handicap
        if (m_nHoleIndex > 1) {
            m_nHoleIndex = 0;
            _m_labelType.text = @"18 Holes";
        }
        
        if (m_nGolferIndex == 0) {// me
            m_hcpView.m_rHcpValue = m_rHcpValues[0 + 2 * m_nHoleIndex];
            m_hcpView.m_rTrendHcpValue = m_rHcpValues[4 + m_nHoleIndex];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            m_hcpView.m_FGrayHcp = ((int)m_rHcpValues[1 + 2 * m_nHoleIndex]) > 0 ? YES : NO;
        } else {
            m_hcpView.m_rHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 2 * m_nHoleIndex] floatValue];
            m_hcpView.m_rTrendHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 4 + m_nHoleIndex] floatValue];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            int nOfficalIndex = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 1 + 2 * m_nHoleIndex] integerValue];
            m_hcpView.m_FGrayHcp = nOfficalIndex > 0 ? YES : NO;
        }
        [m_hcpView setNeedsDisplay];
    }
    [self loadScoreData];
    if (m_nContentType > 0)
        [self showGraphScreen];
}

- (void) changeCourse
{
    [self loadScoreData];
    [self showGraphScreen];
}

- (void) changeRounds
{
    [self loadScoreData];
    [self showGraphScreen];
}

- (void) changeHoleType
{
    if (m_nContentType == 0) { // handicap
        if (m_nHoleIndex > 1) {
            m_nHoleIndex = 0;
            _m_labelType.text = @"18 Holes";
        }
        
        if (m_nGolferIndex == 0) {// me
            m_hcpView.m_rHcpValue = m_rHcpValues[0 + 2 * m_nHoleIndex];
            m_hcpView.m_rTrendHcpValue = m_rHcpValues[4 + m_nHoleIndex];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            m_hcpView.m_FGrayHcp = ((int)m_rHcpValues[1 + 2 * m_nHoleIndex]) > 0 ? YES : NO;
        } else {
            m_hcpView.m_rHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 2 * m_nHoleIndex] floatValue];
            m_hcpView.m_rTrendHcpValue = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 4 + m_nHoleIndex] floatValue];
            m_hcpView.m_nHoleType = m_nHoleIndex;
            int nOfficalIndex = [[handicapList objectAtIndex: (m_nGolferIndex-1) * 6 + 1 + 2 * m_nHoleIndex] integerValue];
            m_hcpView.m_FGrayHcp = nOfficalIndex > 0 ? YES : NO;
        }
        [m_hcpView setNeedsDisplay];
    }
    [self loadScoreData];
    if (m_nContentType > 0)
        [self showGraphScreen];
}

#pragma mark - calculation methods


- (NSArray*) calcScoring
{
    if (m_nHoleIndex > 1)
        m_nHoleIndex = 0;
    _m_labelType.text = (m_nHoleIndex == 0) ? @"18 Holes" : @"9 Holes";
    
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[9] = {0};
    
    int anPar[3] = {0};
    float arPar[3] = {0};
    
    arValue[0] = 100000;
    arValue[3] = 100000;
    int nRealCount = 0, nRoundCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        int nScore = [item.shortScore integerValue];
        if (nScore > 0) {
            arValue[1] += nScore;
            if (arValue[0] > nScore && nScore > 0)
                arValue[0] = nScore;
            if (arValue[2] < nScore && nScore > 0)
                arValue[2] = nScore;
            
            nRoundCount ++;
        }
        
        int nTotalPar = 0;
        
        memset(anPar, 0, sizeof(int) * 3);
        memset(arPar, 0, sizeof(float) * 3);
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            
            int nPar = [score.par integerValue];
            if ([score.score integerValue] > 0)
            {
                nTotalPar += nPar;
                if (nPar >= 3 && nPar <= 5) {
                    arPar[nPar - 3] += [score.score integerValue];
                    anPar[nPar - 3] ++;
                }
            }
        }
        
        for (int i = 0; i < 3; i ++)
            if (anPar[i] > 0)
                arValue[i + 6] += ((float)arPar[i] / (float)(anPar[i]));
            
        if (arValue[3] > nScore - nTotalPar && nTotalPar > 0)
            arValue[3] = nScore - nTotalPar;
        if (arValue[5] < nScore - nTotalPar && nTotalPar > 0)
            arValue[5] = nScore - nTotalPar;
        if (nTotalPar > 0) {
            arValue[4] += (nScore - nTotalPar);
            nRealCount ++;
        }
    }
    
    arValue[1] /= (float)nRoundCount;
    arValue[1] = (float)((int)((arValue[1] + 0.05) * 10) / 10.0);
    arValue[4] /= (float)(nRealCount);
    arValue[4] = (int)(arValue[4] + 0.5);
    
    for (int nIdx = 0; nIdx < 3; nIdx ++) {
        arValue[nIdx + 6] /= (float)nRealCount;
        arValue[nIdx + 6] = (float)((int)((arValue[nIdx + 6] + 0.05) * 10)) / 10.0f;
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 9; nIdx ++) {
        if (arValue[nIdx] == (int) arValue[nIdx]) {
            if (nIdx > 2 && nIdx < 6) {
                if (arValue[nIdx] > 0) {
                    strValue = [NSString stringWithFormat:@"+%d", (int) arValue[nIdx]];
                } else
                    strValue = [NSString stringWithFormat:@"%d", (int) arValue[nIdx]];
            } else
                strValue = [NSString stringWithFormat:@"%d", (int) arValue[nIdx]];
        } else {
            if (nIdx > 2 && nIdx < 6) {
                if (arValue[nIdx] > 0) {
                    strValue = [NSString stringWithFormat:@"+%.1f", arValue[nIdx]];
                } else
                    strValue = [NSString stringWithFormat:@"%.1f", arValue[nIdx]];
            } else
                strValue = [NSString stringWithFormat:@"%.1f", arValue[nIdx]];
        }
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcPutting
{
    if (m_nHoleIndex > 1)
        m_nHoleIndex = 0;
    _m_labelType.text = (m_nHoleIndex == 0) ? @"18 Holes" : @"9 Holes";

    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }

    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[9] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int anCount[3] = {0};
    float arGirPutt[3] = {0};
    int nRealCount = 0;
    
    arValue[0] = 100000;
    arValue[3] = 100000;
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
        int nPutts = 0, nCount = 0;
        
        memset(anCount, 0, sizeof(int) * 3);
        memset(arGirPutt, 0, sizeof(int) * 3);
        
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            
            if ([score.putts integerValue] > 0)
            {
                if ([score.gir integerValue] == 0) {
                    anCount[1] ++;
                    arGirPutt[1] += [score.putts integerValue];
                } else {
                    anCount[0] ++;
                    arGirPutt[0] += [score.putts integerValue];
                }
                
                if ([score.putts integerValue] == 1)
                    arValue[8] += [score.putts integerValue];
                
                nPutts += [score.putts integerValue];
                nCount ++;
            }
        }
        
        arValue[1] += nPutts;
        arValue[4] += ((float)nPutts) / (float)anHoleCount[m_nHoleIndex];
        if (arValue[0] > nPutts && nPutts > 0) {
            arValue[0] = nPutts;
            arValue[3] = ((float)nPutts) / (float)anHoleCount[m_nHoleIndex];
        }
        if (arValue[2] < nPutts && nPutts > 0) {
            arValue[2] = nPutts;
            arValue[5] = ((float)nPutts) / (float)anHoleCount[m_nHoleIndex];
        }
        
        if (anCount[0] > 0)
            arValue[6] += (arGirPutt[0] / (float)anCount[0]);
        if (anCount[1] > 0)
            arValue[7] += (arGirPutt[1] / (float)anCount[1]);
        
        if (nPutts > 0) {
            nRealCount ++;
        }
    }
    
    arValue[1] /= (float)nRealCount;
//    arValue[1] = (int)(arValue[1] + 0.5);
    arValue[4] /= (float)nRealCount;
    arValue[4] = (float)((int)((arValue[4] + 0.05) * 10) / 10.0f);
    
    for (int nIdx = 6; nIdx < 9; nIdx ++) {
        arValue[nIdx] /= (float)nRealCount;
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 9; nIdx ++) {
        if (arValue[nIdx] == (int) arValue[nIdx]) {
            strValue = [NSString stringWithFormat:@"%d", (int) arValue[nIdx]];
        } else {
            strValue = [NSString stringWithFormat:@"%.1f", arValue[nIdx]];
        }
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcGIR
{
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[9] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int nGIR = 0, nRealCount = 0;
    int anPars[3] = {0};
    int anGIRPars[3] = {0};
    
    arValue[2] = 100000;
    arValue[5] = 100000;
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
        int nCount = 0, nPutts = 0;
        
//        memset(anPars, 0, sizeof(int) * 3);
//        memset(anGIRPars, 0, sizeof(int) * 3);
        nGIR = 0;
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            
            if ([score.putts integerValue] > 0)
                nPutts += [score.putts integerValue];
            
            if ([score.score integerValue] > 0) {
                nCount ++;
                if ([score.gir integerValue] > 0)
                    nGIR ++;
                
                if ([score.par integerValue] >= 3 && [score.par integerValue] <= 5) {
                    anPars[[score.par integerValue] - 3] ++;
                    if ([score.gir integerValue] > 0)
                        anGIRPars[[score.par integerValue] - 3] ++;
                }
            }
        }
        
        float rGIRPercent = 0;
        if (nCount > 0)
            rGIRPercent = (nGIR * 100 / (float)nCount);
        arValue[1] += rGIRPercent;
        
        arValue[4] += nGIR;
        
        if (arValue[0] < rGIRPercent && rGIRPercent > 0) {
            arValue[0] = rGIRPercent;
            arValue[3] = nGIR;
        }
        if (arValue[2] > rGIRPercent && rGIRPercent > 0) {
            arValue[2] = rGIRPercent;
            arValue[5] = nGIR;
        }

//        for (int i = 0; i < 3; i ++) {
//            if (anPars[i] > 0)
//                arValue[i + 6] += (anGIRPars[i] * 100 / (float)anPars[i]);
//        }
        
        if (nPutts > 0)
            nRealCount ++;
    }
    
    arValue[1] /= (float)nRealCount;
    arValue[1] = (int)(arValue[1] + 0.5);
    arValue[4] /= (float)nRealCount;
    
    for (int nIdx = 6; nIdx < 9; nIdx ++) {
        arValue[nIdx] = (float)((float)anGIRPars[nIdx-6] * 100.0 / (float)anPars[nIdx-6] + 0.5);
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 9; nIdx ++) {
        strValue = [NSString stringWithFormat:@"%d%%", (int) arValue[nIdx]];
        if (nIdx >= 3 && nIdx < 6) {
            if (m_nHoleIndex == 2)
                strValue = @"";
            else {
                if (arValue[nIdx] == (int)arValue[nIdx])
                    strValue = [NSString stringWithFormat:@"%d", (int) arValue[nIdx]];
                else
                    strValue = [NSString stringWithFormat:@"%.1f", arValue[nIdx]];
            }
        }
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcDriving
{
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[6] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int nGIR = 0;
    int anHitPars[2] = {0};
    int anPars[2] = {0};
    int anFH[4] = {0};
    int nTotalHoleCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
//        memset(anPars, 0, sizeof(int) * 2);
        memset(anHitPars, 0, sizeof(int) * 2);
        memset(anFH, 0, sizeof(int) * 4);
        nGIR = 0;
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            
            if ([score.score integerValue] > 0) {
                int fH = [score.fairway integerValue];
                int nPar = [score.par integerValue];
                if (fH > 0 && fH < 5 && (nPar == 4 || nPar == 5)) {
                    nTotalHoleCount ++;
                    anFH[fH - 1] ++;
                    if (fH == 3) {
                        anHitPars[nPar - 4] ++;
                    }
                    anPars[nPar - 4] ++;
                }
            }
        }
        
        for (int i = 0; i < 4; i++)
  //          if ((anPars[0] + anPars[1]) > 0)
                arValue[i] += anFH[i];//((float)anFH[i] * 100.0 / (float)(anPars[0] + anPars[1]));
        if (anPars[0] > 0)
            arValue[4] += anHitPars[0];//((float)anHitPars[0] * 100.0 / (float)anPars[0]); //par4's
        if (anPars[1] > 0)
            arValue[5] += anHitPars[1];//((float)anHitPars[1] * 100.0 / (float)anPars[1]); //par5's
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 6; nIdx ++) {
        if (nIdx < 4)
            arValue[nIdx] = arValue[nIdx] * 100.0 / (float)nTotalHoleCount;
        else
            arValue[nIdx] = arValue[nIdx] * 100.0 / (float)anPars[nIdx - 4];
        
        strValue = [NSString stringWithFormat:@"%d%%", (int) (arValue[nIdx] + 0.5)];
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcIrons
{
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[11] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int nGIR = 0, nCourseCount = 0;
    int anHitPars[5] = {0};
    int anPars[5] = {0};
    int anFH[6] = {0};
    int nTotalHoleCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
        int nCount = 0;

        memset(anFH, 0, sizeof(int) * 6);
        nGIR = 0;
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            int nPar = [score.par integerValue];
            
            if ([score.score integerValue] > 0) {
                int fH = [score.fairway integerValue];
                if (fH > 0 && fH < 7 && nPar == 3) {
                    anFH[fH - 1] ++;
                    nTotalHoleCount ++;

                    int nYards = [self calcYardIndex: score.yard]; // yard kind index
                    if (fH == 3) {
                        anHitPars[nYards] ++;
                    }
                    anPars[nYards] ++;
                    nCount ++;
                }
            }
        }
        
        if (nCount > 0) {
            for (int i = 0; i < 6; i++)
                arValue[i] += anFH[i];//((float)anFH[i] * 100.0 / (float)nCount);
            nCourseCount ++;
        }
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 11; nIdx ++) {
        if (nIdx > 5) {
            if (anPars[nIdx - 6] > 0)
                arValue[nIdx] = ((float)anHitPars[nIdx - 6] * 100.0 / (float) anPars[nIdx - 6]);
        } else {
            if (nTotalHoleCount > 0)
                arValue[nIdx] = (float)arValue[nIdx] * 100.0 / (float)nTotalHoleCount;
        }
        
        strValue = [NSString stringWithFormat:@"%d%%", (int) (arValue[nIdx] + 0.5)];
        if (nIdx > 5 && arValue[nIdx] <= 0.0000001)
            strValue = @"N/A";
        
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (int) calcYardIndex: (NSString*) strYards
{
    if (strYards == nil || [strYards isEqualToString: @""])
        return 0;
    float rYards = [strYards floatValue];
    if (rYards < 112.5)
        return 0;
    else if (rYards < 137.5)
        return 1;
    else if (rYards < 162.5)
        return 2;
    else if (rYards < 187.5)
        return 3;
    else
        return 4;
}

- (NSArray*) calcGrints
{
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[10] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int nPar = 0, nScore = 0;
    int anPars[3] = {0};
    int anGrintPars[3] = {0};
    int anGrint[6];
    int nRoundCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
        int nCount = 0;
        
        memset(anPars, 0, sizeof(int) * 3);
        memset(anGrintPars, 0, sizeof(int) * 3);
        memset(anGrint, 0, sizeof(int) * 6);
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            nScore = [score.score integerValue];
            nPar = [score.par integerValue];
            if (nScore > 0) {
                nCount ++;
                if (nScore <= nPar) {
                    if (nPar >= 3 && nPar <= 5) {
                        anGrintPars[nPar - 3] ++;
                    }
                }
                int nGrintIndex = nScore - nPar + 2;
                if (nGrintIndex < 0)
                    nGrintIndex = 0;
                if (nGrintIndex > 5)
                    nGrintIndex = 5;
                anGrint[nGrintIndex] ++;
                
                if (nPar >= 3 && nPar <= 5)
                    anPars[nPar - 3] ++;
            }
        }
        
        for (int i = 0; i < 3; i ++) {
            if (anPars[i] > 0)
                arValue[i + 7] += (anGrintPars[i] * 100 / (float)anPars[i]);
        }
        if (nCount > 0) {
            nRoundCount ++;
            for (int i = 1; i <= 6; i ++) {
                arValue[i] += ((float)anGrint[i-1] * 100 / (float)nCount);
                if (i < 4)
                    arValue[0] += ((float)anGrint[i-1] * 100 / (float)nCount);
            }
        }
    }
    
    for (int nIdx = 0; nIdx < 10; nIdx ++) {
        arValue[nIdx] /= (float)nRoundCount;
        arValue[nIdx] = (int)(arValue[nIdx] + 0.5);
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 10; nIdx ++) {
        strValue = [NSString stringWithFormat:@"%d", (int) arValue[nIdx]];
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcPenalty
{
    if (m_nHoleIndex > 1)
        m_nHoleIndex = 0;
    _m_labelType.text = (m_nHoleIndex == 0) ? @"18 Holes" : @"9 Holes";

    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSArray* arrayPenaltyString = [NSArray arrayWithObjects:@"S", @"F", @"W", @"D", @"O", nil];
    float arPenaltyFactor[] = {0.5, 0.5, 1, 1, 2};
    float arPenalty[5] = {0};
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[8] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int nScore = 0, nRoundCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        arValue[6] += [item.shortScore floatValue]; // avg. score
        
        int nCount = 0;
        memset(arPenalty, 0, sizeof(float) * 5);
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            nScore = [score.score integerValue];
            NSString* strPenalty = score.penalty;
            if (strPenalty && [strPenalty isEqualToString: @""] == NO) {
                for (int i = 0; i < [arrayPenaltyString count]; i ++) {
                    int nOccurence = 0;
                    for (int j = 0; j < [strPenalty length]; j++) {
                        if ([strPenalty characterAtIndex: j] == [[arrayPenaltyString objectAtIndex:i] characterAtIndex:0])
                            nOccurence ++;
                    }
                    
                    arPenalty[i] += (float)((double)nOccurence * (double)arPenaltyFactor[i]);
                }
                nCount ++;
            }
        }
        
        for (int i = 0; i < [arrayPenaltyString count]; i++) {
            arValue[i+1] += arPenalty[i];
            arValue[0] += arPenalty[i];
        }
        
        if (nCount > 0)
            nRoundCount ++;
    }
    
    for (int nIdx = 0; nIdx < 6; nIdx ++) {
        arValue[nIdx] /= (float)nRoundCount;
    }
    arValue[7] = arValue[0]; // avg.penalty
    arValue[6] /= (float)[m_arrayScoreList count];
    arValue[6] = (float)((int)((arValue[6] + 0.05) * 10) / 10.0f);
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 8; nIdx ++) {
        strValue = [NSString stringWithFormat:@"%f", (float) arValue[nIdx]];
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

- (NSArray*) calcScrambling
{
    if ([m_arrayScoreList count] <= 0) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"No data recorded" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return nil;
    }
    
    NSMutableArray* arrayValues = [[NSMutableArray alloc] init];
    
    float arValue[6] = {0};
    
    int anHoleCount[2] = {18, 9};
    
    int anOppertunity[3] = {0};
    int nCount = 0;
    
    for (int nIdx = 0; nIdx < [m_arrayScoreList count]; nIdx ++) {
        GrintCourseScore* item = [m_arrayScoreList objectAtIndex: nIdx];
        
        int nPutts = 0, nScore = 0, nPar = 0;
        
        int anCount[6] = {0};
        
        nCount = 0;
        
        for (int nHoleIdx = 0; nHoleIdx < 18; nHoleIdx ++) {
            GrintScore* score = [item.scores objectAtIndex: nHoleIdx];
            nScore = [score.score integerValue];
            nPutts = [score.putts integerValue];
            NSString* strPH = score.penalty;
            nPar = [score.par integerValue];
            if (nScore > 0 && nPar > 0) {
                    nCount ++;
                
                if (nPutts <= 1)
                {
                    if ([strPH isEqualToString: @"S"])
                        anCount[0] ++;
                    if (nScore - nPutts == nPar - 1)
                        anCount[1] ++;
                    else if (nScore - nPutts == nPar)
                        anCount[2] ++;
                }
                
                if ([strPH isEqualToString: @"S"]) {
                    anCount[3] += nPutts;
                    anOppertunity[0] ++;
                }
                if (nScore - nPutts == nPar - 1) {
                    anCount[4] += nPutts;
                    anOppertunity[1] ++;
                }
                else if (nScore - nPutts == nPar) {
                    anCount[5] += nPutts;
                    anOppertunity[2] ++;
                }
            }
        }
        
        for (int i = 0; i < 6; i ++) {
//            if (i < 3) {
                arValue[i] += anCount[i];//(anCount[i] * 100.0 / nCount);
//            } else {
//                arValue[i] += ((float)anCount[i] / (float)nCount);
//            }
        }
    }
    
    NSString* strValue;
    for (int nIdx = 0; nIdx < 6; nIdx ++) {
//        arValue[nIdx] /= ((float)[m_arrayScoreList count]);

        if (nIdx < 3) {
            if (anOppertunity[nIdx] > 0)
                arValue[nIdx] = arValue[nIdx] * 100.0 / (float) anOppertunity[nIdx];
            else
                arValue[nIdx] = 0;
            
            strValue = [NSString stringWithFormat:@"%d%%", (int)(arValue[nIdx]+0.5)];
        } else {
            if (anOppertunity[nIdx - 3] > 0)
                arValue[nIdx] = arValue[nIdx] / (float) anOppertunity[nIdx - 3];
            else
                arValue[nIdx] = 0;

            strValue = [NSString stringWithFormat:@"%.1f", arValue[nIdx]];
        }
        [arrayValues addObject: strValue];
    }
    
    return arrayValues;
}

@end
