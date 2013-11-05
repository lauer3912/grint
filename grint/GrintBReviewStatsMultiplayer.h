//
//  GrintBReviewStatsMultiplayer.h
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//
@class GrintBDetail7Multiplayer;

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface GrintBReviewStatsMultiplayer : UIViewController{
    IBOutlet UILabel* labelCourseName;
    
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UIButton* button3;
    
    IBOutlet UILabel* labelAvgScoreToday;
    IBOutlet UILabel* labelAvgPuttsToday;
    IBOutlet UILabel* labelAvgPenaltyToday;
    IBOutlet UILabel* labelTeeAccuracyToday;
    IBOutlet UILabel* labelAvgGirToday;
    IBOutlet UILabel* labelGrintsToday;
    
    IBOutlet UILabel* labelAvgScoreHistorical;
    IBOutlet UILabel* labelAvgPuttsHistorical;
    IBOutlet UILabel* labelAvgPenaltyHistorical;
    IBOutlet UILabel* labelTeeAccuracyHistorical;
    IBOutlet UILabel* labelAvgGirHistorical;
    IBOutlet UILabel* labelGrintsHistorical;
    
    IBOutlet UILabel* labelAvgScoreCourse;
    IBOutlet UILabel* labelAvgPuttsCourse;
    IBOutlet UILabel* labelAvgPenaltyCourse;
    IBOutlet UILabel* labelTeeAccuracyCourse;
    IBOutlet UILabel* labelAvgGirCourse;
    IBOutlet UILabel* labelGrintsCourse;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label7;
    IBOutlet UILabel* label8;
    IBOutlet UILabel* label9;
    
    IBOutlet UILabel* labelCap;
    
    IBOutlet UILabel* labelUsername;
    
    int playerIndex;

}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* teeboxColor;
@property (nonatomic, retain) NSString* score;
@property (nonatomic, retain) NSString* putts;
@property (nonatomic, retain) NSString* penalties;
@property (nonatomic, retain) NSString* accuracy;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSString* player1;
@property (nonatomic, retain) NSString* player2;
@property (nonatomic, retain) NSString* player3;
@property (nonatomic, retain) NSString* player4;
@property (nonatomic, retain) NSNumber* courseID;
@property (nonatomic, retain) NSNumber* attachedScorecard;

@property (nonatomic, retain) NSURLConnection * connection;

@property (strong, nonatomic) GrintBDetail7Multiplayer *detailViewController;

@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableArray* playerData;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property BOOL isNine;

- (IBAction)facebookScore:(id)sender;
- (IBAction)shareClick:(id)sender;
- (IBAction)nextScreen:(id)sender;

@end