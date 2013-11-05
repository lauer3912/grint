//
//  GrintBNewReviewScore.m
//  grint
//
//  Created by Passioner on 9/18/13.
//
//

#import "GrintBNewReviewScore.h"
#import "GrintScore.h"

#import "Flurry.h"
#import "GrintBDetail7.h"
#import "GrintStatsScorecardDetailViewController2.h"

#import "KxMenu.h"

#import "GrintSocialViewController.h"
#import "SpinnerView.h"

@interface GrintBNewReviewScore ()

@end

@implementation GrintBNewReviewScore
{
    int m_nHoleType;
    int photoNumberB;
    bool doublePhotosB;
    
    SpinnerView* spinnerView;
}

@synthesize m_strCourseName, m_strUserName, m_scores, isNine, nineType, FComplete, connection, data;

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
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize scores;
@synthesize teeID;
@synthesize holeOffset;

@synthesize courseScores;
@synthesize m_nViewType;


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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    
//    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
//    if(spinnerView){
//        [spinnerView removeSpinner];
//        spinnerView = nil;
//    }
//    if([[conn.originalRequest.URL description]rangeOfString: @"coursestats_iphone"].location != NSNotFound){
//        
//        NSString* strScore  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore_today>" andString:@"</avgscore_today>" forString:responseText]floatValue]];
//        NSString* strPutts  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts_today>" andString:@"</avgputts_today>" forString:responseText]floatValue]];
//        NSString* strPenalty  = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty_today>" andString:@"</avgpenalty_today>" forString:responseText]floatValue]];
//        NSString* strTeeAcc  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<teeaccuracy_today>" andString:@"</teeaccuracy_today>" forString:responseText]floatValue])];
//        NSString* strGir  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<avggir_today>" andString:@"</avggir_today>" forString:responseText]floatValue])];
////        labelGrintsToday.text  = [NSString stringWithFormat:@"%ld", lroundf([[self stringBetweenString:@"<grints_today>" andString:@"</grints_today>" forString:responseText]floatValue])];
//
//        NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %.0f at %@. ",[strScore floatValue], self.m_strCourseName];
//        
//        [tweetText appendFormat:@" I made %.0f putts", [strPutts floatValue]];
//        [tweetText appendString:@", "];
//        [tweetText appendFormat:@"hit %@%% of greens", strGir];
//        [tweetText appendString:@" and "];
//        [tweetText appendFormat:@"%@%% of tee shots", strTeeAcc];
//        
//        GrintSocialViewController* controller = [[GrintSocialViewController alloc] initWithNibName:@"GrintSocialViewController" bundle:nil];
//        controller.delegate = self;
//        controller.tweetText = tweetText;
//        
//        controller.tweetImage = nil;
//        
//        [self presentViewController:controller animated:YES completion:nil];
//    }
}

#pragma mark - view controller
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nViewType = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [_m_labelTitle setFont: [UIFont fontWithName: @"Oswald" size: 22]];
//    [_m_labelHoleType setFont: [UIFont fontWithName: @"Oswald" size: 18]];
//    [_m_labelScore1 setFont: [UIFont fontWithName: @"Oswald" size: 24]];
//    [_m_labelScore2 setFont: [UIFont fontWithName: @"Oswald" size: 15]];
//
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, 460.0, 320.0);

    [self initFont: self.view];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(prevScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [_m_btnShare.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: 15.0f]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    m_nHoleType = 0;
    
    [self showScores];
    [self calcTotalScore];

    _m_btnShare.hidden = YES;
    _m_twitterImage.hidden = YES;
    _m_facebookImage.hidden = YES;

    if (m_nViewType == 0) {
        if (FComplete)
            _m_btnNext.hidden = NO;
        else
            _m_btnNext.hidden = YES;
    } else if (m_nViewType == 1) {
//        _m_btnShare.hidden = NO;
//        _m_twitterImage.hidden = NO;
//        _m_facebookImage.hidden = NO;
        _m_btnNext.hidden = NO;
    } else if (m_nViewType == 2)
        _m_btnNext.hidden = YES;
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionShare:(id)sender {
    
//    NSMutableURLRequest* request;
//    
//    if(self.isNine){
//        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone_nine"]];
//    }
//    else{
//        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/coursestats_iphone"]];
//    }
//    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d", self.username, [self.courseID intValue]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (connection ) {
//        data = [NSMutableData data];
//    }
//
//    spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
    int nGir = 0, nShot = 0, nHoles = 18;
    if (self.isNine)
        nHoles = 9;
    for (int nIdx = 0; nIdx < 18; nIdx ++) {
        GrintScore* holeScore = [m_scores objectAtIndex: nIdx];
        if ((holeScore.par.integerValue - 2) >= (holeScore.score.integerValue - holeScore.putts.integerValue)) {
            nGir ++;
        }
        
        if ([holeScore.fairway isEqualToString: @"Hit"] || [holeScore.fairway isEqualToString: @"3"])
            nShot ++;
    }
    NSString* strGir = [NSString stringWithFormat: @"%.1f", (float)((float)(nGir * 100.0f))/((float)nHoles)];
    NSString* strTeeAcc = [NSString stringWithFormat: @"%.1f", (float)((float)(nShot * 100.0f))/((float)nHoles)];
    
    NSMutableString* tweetText = [NSMutableString stringWithFormat:@"I just scored a %@ at %@. ", ((UILabel*)[self.view viewWithTag: 102]).text, self.m_strCourseName];
    
    [tweetText appendFormat:@" I made %@ putts", ((UILabel*)[self.view viewWithTag: 202]).text];
    [tweetText appendString:@", "];
    [tweetText appendFormat:@"hit %@%% of greens", strGir];
    [tweetText appendString:@" and "];
    [tweetText appendFormat:@"%@%% of tee shots", strTeeAcc];
    
    GrintSocialViewController* controller = [[GrintSocialViewController alloc] initWithNibName:@"GrintSocialViewController" bundle:nil];
    controller.delegate = self;
    controller.tweetText = tweetText;
    
    controller.tweetImage = nil;
    
    [self presentViewController:controller animated:YES completion:nil];

}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)selectHoleType:(id)sender {
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    NSString* strCaption;
    KxMenuItem* item;
    NSArray* array = [NSArray arrayWithObjects: @"FRONT 9", @"BACK 9", nil];
    for (int nIdx = 0; nIdx <= 1; nIdx ++) {
        strCaption = [array objectAtIndex: nIdx];
        item = [KxMenuItem menuItem: strCaption
                              image:nil
                             target:self
                             action:@selector(pushMenuItem:)
                                tag: nIdx];
        [menuItems addObject: item];
    }
    
    UIButton* btn = (UIButton*)sender;
    UIView* view = ((UIButton*)sender).superview;
    
    CGRect rect = btn.frame;
//    rect.origin.y += (btn.frame.origin.y + btn.frame.size.height);
//    rect.origin.x += (btn.center.x);
    
    [KxMenu showMenuInView: view
                  fromRect:rect
                 menuItems:menuItems type: 0];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = ((KxMenuItem*)sender);
    if (m_nHoleType == item.nTag)
        return;

    m_nHoleType = item.nTag;
    
    [self showScores];
}



#pragma mark - swipe process

- (void) prevScreen : (UIGestureRecognizer*) gesture
{
    if (m_nHoleType == 1) {
        m_nHoleType = 0;
        [self showScores];
    }
}

- (void) nextScreen : (UIGestureRecognizer*) gesture
{
    if (m_nViewType == 0) {
        if (m_nHoleType == 0) {
            m_nHoleType = 1;
            [self showScores];
        } else if (FComplete) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Attach picture" message:@"Would you like to attach a photo of your scorecard with this submission?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 11;
            [alert show];
        }
    } else {
        if (m_nHoleType == 0) {
            m_nHoleType = 1;
            [self showScores];
        }
    }
}

- (void) showTotalScore
{
    GrintStatsScorecardDetailViewController2* controller = [[GrintStatsScorecardDetailViewController2 alloc]initWithNibName:@"GrintStatsScorecardDetailViewController2" bundle:nil];
    controller.courseID = [NSNumber numberWithInt:[self.courseScores.courseId intValue]];
    controller.courseName = self.courseScores.courseName;
    controller.username = self.username;
    controller.delegate = self;
    controller.date = courseScores.date;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma init font setting by oswald

- (void) initFont: (UIView*) parent
{
    for (UIView* view in parent.subviews) {
        if ([view isKindOfClass: [UILabel class]]) {
            UILabel* label = (UILabel*) view;
            [label setFont: [UIFont fontWithName: @"Oswald" size: label.font.pointSize]];
        } else if ([view isKindOfClass: [UIView class]])
            [self initFont: view];
    }
}

#pragma mark - show and calc the params relate to score

- (void) calcTotalScore
{
    int nTotalScore = 0;
    int nStroke = 0;
    for (GrintScore* curScore in self.m_scores) {
        int nScore = [curScore.score integerValue];
        if (nScore > 0) {
            nTotalScore += nScore;
            nStroke += (nScore - [curScore.par integerValue]);
        }
    }
    if (nStroke > 0)
        _m_labelScore1.text = [NSString stringWithFormat: @"+%d", nStroke];
    else
        _m_labelScore1.text = [NSString stringWithFormat: @"%d", nStroke];
    
    _m_labelScore2.text = [NSString stringWithFormat:@"(%d)", nTotalScore];
}

- (void) showScores
{
    _m_labelTitle.text = m_strCourseName;
    
    if ([UIScreen mainScreen].bounds.size.width > 480 || [UIScreen mainScreen].bounds.size.height > 480)
        _m_labelUserName.text = m_strUserName;
    else
        _m_labelUserName.text = [self getShortName: [[m_strUserName stringByReplacingOccurrencesOfString: @"   " withString:@" "] stringByReplacingOccurrencesOfString:@"  " withString:@" "]];
    
    if (m_nHoleType == 0) {
        _m_labelHoleType.text = @"SCORES (FRONT 9)";
    } else {
        _m_labelHoleType.text = @"SCORES (BACK 9)";
    }
    
    float arSum[2][4] = {0};
    for (int nIdx = 0; nIdx < 9; nIdx ++) {
        GrintScore* curscore = [m_scores objectAtIndex: (m_nHoleType * 9 + nIdx)];
        
        ((UILabel*)[self.view viewWithTag: nIdx + 1]).text = [NSString stringWithFormat: @"%d", (nIdx + 1 + m_nHoleType * 9)];
        ((UILabel*)[self.view viewWithTag: nIdx + 11]).text = curscore.par;
        ((UILabel*)[self.view viewWithTag: nIdx + 21]).text = curscore.score;
        ((UILabel*)[self.view viewWithTag: nIdx + 31]).text = curscore.putts;
        ((UILabel*)[self.view viewWithTag: nIdx + 41]).text = curscore.penalty;
        
        NSString* strImageName = [self getFairwayImageName: [curscore.fairway uppercaseString]];
        
        ((UIImageView*)[self.view viewWithTag: nIdx + 51]).image = [UIImage imageNamed: strImageName];
        
        GrintScore* outScore = [m_scores objectAtIndex: nIdx];
        GrintScore* inScore = [m_scores objectAtIndex: nIdx + 9];
        arSum[0][0] += (float)[outScore.score integerValue];
        arSum[1][0] += (float)[inScore.score integerValue];
        arSum[0][1] += (float)[outScore.putts integerValue];
        arSum[1][1] += (float)[inScore.putts integerValue];
        arSum[0][2] += [self calcPenalty: outScore.penalty];
        arSum[1][2] += [self calcPenalty: inScore.penalty];;
        arSum[0][3] += (([[outScore.fairway uppercaseString] isEqualToString: @"HIT"] || [[outScore.fairway uppercaseString] isEqualToString: @"3"]) ? 1 : 0);
        arSum[1][3] += (([[inScore.fairway uppercaseString] isEqualToString: @"HIT"] || [[inScore.fairway uppercaseString] isEqualToString: @"3"]) ? 1 : 0);
    }
    
    for (int nIdx = 0; nIdx < 4; nIdx ++) {
        if (nIdx == 3) {
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100]).text = [NSString stringWithFormat:@"%d", (int)(arSum[0][nIdx] * 100.0 / 9.0 + 0.5)];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 1]).text = [NSString stringWithFormat:@"%d", (int)(arSum[1][nIdx] * 100.0 / 9.0 + 0.5)];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 2]).text = [NSString stringWithFormat:@"%d", (int)((arSum[0][nIdx] + arSum[1][nIdx]) * 100.0 / 18.0 + 0.5)];
        } else if (nIdx == 2) {
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100]).text = [NSString stringWithFormat:@"%.1f", arSum[0][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 1]).text = [NSString stringWithFormat:@"%.1f", arSum[1][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 2]).text = [NSString stringWithFormat:@"%.1f", (arSum[0][nIdx] + arSum[1][nIdx])];
        }
        else {
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100]).text = [NSString stringWithFormat:@"%d", (int)arSum[0][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 1]).text = [NSString stringWithFormat:@"%d", (int)arSum[1][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 2]).text = [NSString stringWithFormat:@"%d", (int)(arSum[0][nIdx] + arSum[1][nIdx])];
        }
    }
}

- (float) calcPenalty: (NSString*) strPenalty
{
    if (strPenalty == nil || [strPenalty isEqualToString: @""])
        return 0;
    NSArray* arrayPenaltyString = [NSArray arrayWithObjects:@"S", @"F", @"W", @"D", @"O", nil];
    float arPenaltyFactor[] = {0.5, 0.5, 1, 1, 2};
    
    float rPenalty = 0;
    int i = 0;
    
    for (int nIdx = 0; nIdx < strPenalty.length; nIdx ++) {
        for (i = 0; i < [arrayPenaltyString count]; i ++)
            if ([strPenalty characterAtIndex: nIdx] == ([[arrayPenaltyString objectAtIndex: i] characterAtIndex:0]))
                break;
        if (i < [arrayPenaltyString count]) {
            rPenalty += arPenaltyFactor[i];
        }
    }
    
    return rPenalty;
}

- (NSString*) getFairwayImageName: (NSString*) strFairway
{
    NSString* strImageName;
    if ([strFairway isEqualToString: @"HIT"] || [strFairway isEqualToString: @"3"])
        strImageName = @"icon_hit.png";
    else if ([strFairway isEqualToString: @"LEFT"] || [strFairway isEqualToString: @"1"])
        strImageName = @"icon_left.png";
    else if ([strFairway isEqualToString: @"RIGHT"] || [strFairway isEqualToString: @"2"])
        strImageName = @"icon_right.png";
    else if ([strFairway isEqualToString: @"SHORT"] || [strFairway isEqualToString: @"4"])
        strImageName = @"icon_short.png";
    else if ([strFairway isEqualToString: @"LONG"] || [strFairway isEqualToString: @"6"])
        strImageName = @"icon_long.png";
    else if ([strFairway isEqualToString: @"SHANK"] || [strFairway isEqualToString: @"5"])
        strImageName = @"icon_miss.png";
    else
        strImageName = @"";
    
    return strImageName;
}

- (NSString*) getShortName: (NSString*) strUserName
{
    NSArray* arrayNames = [strUserName componentsSeparatedByString: @" "];
    if ([arrayNames count] > 1) {
        NSString* strShortName = [NSString stringWithFormat: @"%@ %@.", [arrayNames objectAtIndex: 0], [[arrayNames objectAtIndex:1] substringToIndex:1]];
        return strShortName;
    }
    return strUserName;
}

////copied from prev reviewscoreview

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIBarButtonItem* backButton;
    UIAlertView* alert;
    
    if(alertView.tag == 11){
        
        switch(buttonIndex){
            case 0:
                
                [Flurry logEvent:@"playgolf_picture_not_added"];
                backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
                
                [[self navigationItem] setBackBarButtonItem:backButton];
                
                
                if (!self.detailViewController) {
                    self.detailViewController = [[GrintBDetail7 alloc] initWithNibName:@"GrintBDetail7" bundle:nil];
                }
                
                
                ((GrintBDetail7*)self.detailViewController).teeID = self.teeID;
                
                
                ((GrintBDetail7*)self.detailViewController).username = self.username;
                ((GrintBDetail7*)self.detailViewController).courseName= self.courseName;
                ((GrintBDetail7*)self.detailViewController).courseAddress= self.courseAddress;
                ((GrintBDetail7*)self.detailViewController).teeboxColor= self.teeboxColor;
                ((GrintBDetail7*)self.detailViewController).date = self.date;
                ((GrintBDetail7*)self.detailViewController).score = self.score;
                ((GrintBDetail7*)self.detailViewController).putts = self.putts;
                ((GrintBDetail7*)self.detailViewController).penalties = self.penalties;
                ((GrintBDetail7*)self.detailViewController).accuracy = self.accuracy;
                ((GrintBDetail7*)self.detailViewController).player1 = self.player1;
                ((GrintBDetail7*)self.detailViewController).player2 = self.player2;
                ((GrintBDetail7*)self.detailViewController).player3 = self.player3;
                ((GrintBDetail7*)self.detailViewController).player4 = self.player4;
                ((GrintBDetail7*)self.detailViewController).courseID = self.courseID;
                ((GrintBDetail7*)self.detailViewController).scores = self.scores;
                ((GrintBDetail7*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:0];
                ((GrintBDetail7*)self.detailViewController).holeOffset = self.holeOffset;
                ((GrintBDetail7*)self.detailViewController).isNine = self.isNine;
                ((GrintBDetail7*)self.detailViewController).nineType = self.nineType;
                ((GrintBDetail7*)self.detailViewController).leaderboardID = self.leaderboardID;
                
                
                [self.navigationController pushViewController:self.detailViewController animated:YES];
                
                
                break;
                
            case 1:
                
                [Flurry logEvent:@"playgolf_pictureadded"];
                alert = [[UIAlertView alloc] initWithTitle:@"Upload scorecard" message:@"Select photo source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photo Roll", nil];
                alert.tag = 13;
                [alert show];
                
                
                break;
        }
        
        
    }
    
    else if(alertView.tag == 13){
        
        switch (buttonIndex) {
            case 0:
                alert = [[UIAlertView alloc] initWithTitle:@"Photo your scorecard" message:@"How many sides of the scorecard do you need to photograph?" delegate:self cancelButtonTitle:@"One" otherButtonTitles:@"Two", nil];
                alert.tag = 12;
                [alert show];
                
                break;
            case 1:
                doublePhotosB = NO;
                photoNumberB = 1;
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id)self;
                imagePicker.allowsImageEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
                
                break;
        }
        
    }
    
    else if(alertView.tag == 12){
        switch (buttonIndex) {
            case 0:
                [self cameraSingle:self];
                break;
            case 1:
                [self cameraDouble:self];
                break;
        }
    }
    
}

-(IBAction)cameraSingle:(id)sender{
    // Create image picker controller
    
    doublePhotosB = NO;
    photoNumberB = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)cameraDouble:(id)sender{
    // Create image picker controller
    
    doublePhotosB = YES;
    photoNumberB = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(image.size.width > 1024){
        
        float scaleAmount = 1024 / image.size.width;
        
        CGSize destinationSize = CGSizeMake(image.size.width * scaleAmount, image.size.height * scaleAmount);
        
        UIGraphicsBeginImageContext(destinationSize);
        [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    NSString  *jpgPath;
    if(photoNumberB == 1){
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
    }
    else{
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp2.jpg"];
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    
    
    if(doublePhotosB && (photoNumberB == 1)){
        [self dismissModalViewControllerAnimated:NO];
        photoNumberB = 2;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id)self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{
        
        if(doublePhotosB){
            //stitch image to temp.jpg
            UIImage * piece1 = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]];
            
            CGSize newSize = CGSizeMake(piece1.size.width * 2, piece1.size.height);
            UIGraphicsBeginImageContext( newSize );
            
            [piece1 drawInRect:CGRectMake(0,0,piece1.size.width, piece1.size.height)];
            [image drawInRect:CGRectMake(piece1.size.width,0,piece1.size.width, piece1.size.height)];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
        }
        
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
        [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
        
        NSDate *now = [NSDate date];
        NSLog(now.description);
        
        NSString* newDir = [[@"Documents/" stringByAppendingString:now.description]stringByAppendingString:@".jpg"];
        
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:newDir];
        [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
        
        [self dismissModalViewControllerAnimated:YES];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        
        if (!self.detailViewController) {
            self.detailViewController = [[GrintBDetail7 alloc] initWithNibName:@"GrintBDetail7" bundle:nil];
        }
        
        
        ((GrintBDetail7*)self.detailViewController).teeID = self.teeID;
        
        
        ((GrintBDetail7*)self.detailViewController).username = self.username;
        ((GrintBDetail7*)self.detailViewController).courseName= self.courseName;
        ((GrintBDetail7*)self.detailViewController).courseAddress= self.courseAddress;
        ((GrintBDetail7*)self.detailViewController).teeboxColor= self.teeboxColor;
        ((GrintBDetail7*)self.detailViewController).date = self.date;
        ((GrintBDetail7*)self.detailViewController).score = self.score;
        ((GrintBDetail7*)self.detailViewController).putts = self.putts;
        ((GrintBDetail7*)self.detailViewController).penalties = self.penalties;
        ((GrintBDetail7*)self.detailViewController).accuracy = self.accuracy;
        ((GrintBDetail7*)self.detailViewController).player1 = self.player1;
        ((GrintBDetail7*)self.detailViewController).player2 = self.player2;
        ((GrintBDetail7*)self.detailViewController).player3 = self.player3;
        ((GrintBDetail7*)self.detailViewController).player4 = self.player4;
        ((GrintBDetail7*)self.detailViewController).courseID = self.courseID;
        ((GrintBDetail7*)self.detailViewController).scores = self.scores;
        ((GrintBDetail7*)self.detailViewController).holeOffset = self.holeOffset;
        ((GrintBDetail7*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:1];
        ((GrintBDetail7*)self.detailViewController).isNine = self.isNine;
        ((GrintBDetail7*)self.detailViewController).nineType = self.nineType;
        ((GrintBDetail7*)self.detailViewController).leaderboardID = self.leaderboardID;
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    /*  UIAlertView *alert;
     
     // Unable to save the image
     if (error)
     alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Unable to save image to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     else // All is well
     alert = [[UIAlertView alloc] initWithTitle:@"Success"
     message:@"Image saved to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     [alert show];*/
}


- (IBAction)goNext:(id)sender {
    if (m_nViewType == 0) {
        if (FComplete) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Attach picture" message:@"Would you like to attach a photo of your scorecard with this submission?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 11;
            [alert show];
        }
    } else if (m_nViewType == 1) {
        [self showTotalScore];
    }
}

@end
