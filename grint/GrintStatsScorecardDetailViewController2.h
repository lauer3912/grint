//
//  GrintStatsScorecardDetailViewController2.h
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintStatsScorecardDetailViewController2 : UIViewController{
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
@property (nonatomic, retain) NSMutableData* data;

@property (nonatomic, assign) UIViewController* delegate;

- (IBAction)facebookScore:(id)sender;
@property (nonatomic, retain) NSString* nameString;


@end