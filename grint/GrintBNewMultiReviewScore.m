//
//  GrintBNewMultiReviewScore.m
//  grint
//
//  Created by Passioner on 9/19/13.
//
//

#import "GrintBNewMultiReviewScore.h"
#import "GrintScore.h"

#import "Flurry.h"
#import "GrintBDetail7Multiplayer.h"

#import "KxMenu.h"

@interface GrintBNewMultiReviewScore ()

@end

@implementation GrintBNewMultiReviewScore
{
    int m_nHoleType;
    int photoNumberD;
    bool doublePhotosD;
}
@synthesize m_strCourseName, m_strUserName, m_scores, isNine, nineType, FComplete;

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
@synthesize playerData;


#pragma mark - view controller
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
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    m_nHoleType = 0;
    
    [self showScores];
    [self calcTotalScore];
    
    if (FComplete)
        _m_btnNext.hidden = NO;
    else
        _m_btnNext.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)goNext:(id)sender {
    if (FComplete) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Attach picture" message:@"Would you like to attach a photo of your scorecard with this submission?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 11;
        [alert show];
    }
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
    if (m_nHoleType == 0) {
        m_nHoleType = 1;
        [self showScores];
    } else if (FComplete) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Attach picture" message:@"Would you like to attach a photo of your scorecard with this submission?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 11;
        [alert show];
    }
}

#pragma init font setting by oswald

- (void) initFont: (UIView*) parent
{
    for (UIView* view in parent.subviews) {
        if ([view isKindOfClass: [UILabel class]]) {
            UILabel* label = (UILabel*) view;
            [label setFont: [UIFont fontWithName: @"Oswald" size: label.font.pointSize]];
            if (label.tag > 0)
                label.text = @"";
        } else if ([view isKindOfClass: [UIView class]])
            [self initFont: view];
    }
}

#pragma mark - show and calc the params relate to score

- (void) calcTotalScore
{
    int nTotalScore = 0;
    int nStroke = 0;
    for (GrintScore* curScore in [self.m_scores objectAtIndex: 0]) {
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
    
    NSDictionary* dictPlayer;
    NSString* strName;
    UILabel* labelName;
    
    _m_labelUserName.text = @"Players";
    
    for (int i = 0; i < [playerData count]; i ++) {
        labelName = (UILabel*)[self.view viewWithTag: (1001 + i)];
        dictPlayer = [playerData objectAtIndex: i];
        if (dictPlayer && [dictPlayer objectForKey: @"fname"] && ![[dictPlayer objectForKey: @"fname"] isEqualToString: @""]) {
            strName = [[NSString stringWithFormat: @"%@ %@", [dictPlayer objectForKey: @"fname"], [dictPlayer objectForKey: @"lname"]] uppercaseString];
            if ([UIScreen mainScreen].bounds.size.width > 480 || [UIScreen mainScreen].bounds.size.height > 480) {
                labelName.text = strName;
            } else {
                labelName.text = [self getShortName: [[strName stringByReplacingOccurrencesOfString: @"   " withString:@" "] stringByReplacingOccurrencesOfString:@"  " withString:@" "]];
            }
        }
    }
    
    if (m_nHoleType == 0) {
        _m_labelHoleType.text = @"SCORES (FRONT 9)";
    } else {
        _m_labelHoleType.text = @"SCORES (BACK 9)";
    }
    
    int arSum[2][4] = {0};
    for (int nIdx = 0; nIdx < 9; nIdx ++) {
        
        ((UILabel*)[self.view viewWithTag: nIdx + 1]).text = [NSString stringWithFormat: @"%d", (nIdx + 1 + m_nHoleType * 9)];
        for (int i = 0; i < [playerData count]; i ++) {
            GrintScore* curScore = [[m_scores objectAtIndex: i] objectAtIndex: (9 + nIdx)];
            GrintScore* outScore = [[m_scores objectAtIndex: i] objectAtIndex: nIdx];
            
            if (m_nHoleType == 0) {
                if (i == 0)
                    ((UILabel*)[self.view viewWithTag: nIdx + 11]).text = outScore.par;
                ((UILabel*)[self.view viewWithTag: nIdx + 21 + i * 10]).text = outScore.score;
            } else {
                if (i == 0)
                    ((UILabel*)[self.view viewWithTag: nIdx + 11]).text = curScore.par;
                ((UILabel*)[self.view viewWithTag: nIdx + 21 + i * 10]).text = curScore.score;
            }
            
            arSum[0][i] += [outScore.score integerValue];
            arSum[1][i] += [curScore.score integerValue];
        }
    }
    
    for (int nIdx = 0; nIdx < [playerData count]; nIdx ++) {
        ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100]).text = (arSum[0][nIdx] == 0) ? @"" : [NSString stringWithFormat:@"%d", arSum[0][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 1]).text = (arSum[1][nIdx] == 0) ? @"" : [NSString stringWithFormat:@"%d", arSum[1][nIdx]];
            ((UILabel*)[self.view viewWithTag: (nIdx+1) * 100 + 2]).text = ((arSum[0][nIdx] + arSum[1][nIdx]) == 0) ? @"" : [NSString stringWithFormat:@"%d", (arSum[0][nIdx] + arSum[1][nIdx])];
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

- (IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
                    self.detailViewController = [[GrintBDetail7Multiplayer alloc] initWithNibName:@"GrintBDetail7Multiplayer" bundle:nil];
                }
                
                
                ((GrintBDetail7Multiplayer*)self.detailViewController).teeID = self.teeID;
                
                
                ((GrintBDetail7Multiplayer*)self.detailViewController).username = self.username;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseName= self.courseName;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseAddress= self.courseAddress;
                ((GrintBDetail7Multiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
                ((GrintBDetail7Multiplayer*)self.detailViewController).date = self.date;
                ((GrintBDetail7Multiplayer*)self.detailViewController).score = self.score;
                ((GrintBDetail7Multiplayer*)self.detailViewController).putts = self.putts;
                ((GrintBDetail7Multiplayer*)self.detailViewController).penalties = self.penalties;
                ((GrintBDetail7Multiplayer*)self.detailViewController).accuracy = self.accuracy;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player1 = self.player1;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player2 = self.player2;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player3 = self.player3;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player4 = self.player4;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseID = self.courseID;
                ((GrintBDetail7Multiplayer*)self.detailViewController).scores = self.scores;
                ((GrintBDetail7Multiplayer*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:0];
                ((GrintBDetail7Multiplayer*)self.detailViewController).holeOffset = self.holeOffset;
                ((GrintBDetail7Multiplayer*)self.detailViewController).isNine = self.isNine;
                ((GrintBDetail7Multiplayer*)self.detailViewController).nineType = self.nineType;
                ((GrintBDetail7Multiplayer*)self.detailViewController).leaderboardID = self.leaderboardID;
                
                
                [self.navigationController pushViewController:self.detailViewController animated:YES];
                
                
                break;
                
            case 1:
                
                [Flurry logEvent:@"playgolf_pictureadded"];
                alert = [[UIAlertView alloc] initWithTitle:@"Upload scorecard" message:@"Select photo source" delegate:self                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         cancelButtonTitle:@"Camera" otherButtonTitles:@"Photo Roll", nil];
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
                doublePhotosD = NO;
                photoNumberD = 1;
                
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
    
    doublePhotosD = NO;
    photoNumberD = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)cameraDouble:(id)sender{
    // Create image picker controller
    
    doublePhotosD = YES;
    photoNumberD = 1;
    
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
    if(photoNumberD == 1){
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
    
    
    
    if(doublePhotosD && (photoNumberD == 1)){
        [self dismissModalViewControllerAnimated:NO];
        photoNumberD = 2;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id)self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{
        
        if(doublePhotosD){
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
            self.detailViewController = [[GrintBDetail7Multiplayer alloc] initWithNibName:@"GrintBDetail7Multiplayer" bundle:nil];
        }
        
        
        ((GrintBDetail7Multiplayer*)self.detailViewController).teeID = self.teeID;
        
        
        ((GrintBDetail7Multiplayer*)self.detailViewController).username = self.username;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseName= self.courseName;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseAddress= self.courseAddress;
        ((GrintBDetail7Multiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
        ((GrintBDetail7Multiplayer*)self.detailViewController).date = self.date;
        ((GrintBDetail7Multiplayer*)self.detailViewController).score = self.score;
        ((GrintBDetail7Multiplayer*)self.detailViewController).putts = self.putts;
        ((GrintBDetail7Multiplayer*)self.detailViewController).penalties = self.penalties;
        ((GrintBDetail7Multiplayer*)self.detailViewController).accuracy = self.accuracy;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player1 = self.player1;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player2 = self.player2;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player3 = self.player3;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player4 = self.player4;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseID = self.courseID;
        ((GrintBDetail7Multiplayer*)self.detailViewController).scores = self.scores;
        ((GrintBDetail7Multiplayer*)self.detailViewController).holeOffset = self.holeOffset;
        ((GrintBDetail7Multiplayer*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:1];
        ((GrintBDetail7Multiplayer*)self.detailViewController).isNine = self.isNine;
        ((GrintBDetail7Multiplayer*)self.detailViewController).nineType = self.nineType;
        ((GrintBDetail7Multiplayer*)self.detailViewController).leaderboardID = self.leaderboardID;
        
        
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


@end
