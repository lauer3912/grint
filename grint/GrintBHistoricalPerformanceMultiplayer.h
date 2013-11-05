//
//  GrintBHistoricalPerformanceMultiplayer.h
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@class GrintBWriteScoreMultiplayer;

@interface GrintBHistoricalPerformanceMultiplayer : UIViewController{
    
IBOutlet UILabel* labelCourseHandicap;
IBOutlet UILabel* labelCourseAvgScore;
IBOutlet UILabel* labelCourseAvgPutts;
IBOutlet UILabel* labelCourseAvgGir;
IBOutlet UILabel* labelCourseBestScore;
IBOutlet UILabel* labelAvgScore;
IBOutlet UILabel* labelAvgPutts;
IBOutlet UILabel* labelAvgGir;
IBOutlet UILabel* labelBestScore;

IBOutlet UILabel* titleLabel;

IBOutlet UIButton* button1;
    
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
@property (nonatomic, retain) NSString* teeID;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSNumber* holeOffset;
@property (nonatomic, retain) NSMutableArray* playerData;

@property (nonatomic, retain) NSURLConnection * connection;

@property (nonatomic, retain) NSMutableData* data;

@property (strong, nonatomic) GrintBWriteScoreMultiplayer *detailViewController;

@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property (nonatomic, retain) NSString* userFname1;
@property (nonatomic, retain) NSString* userLname1;
@property (nonatomic, retain) NSString* userFname2;
@property (nonatomic, retain) NSString* userLname2;
@property (nonatomic, retain) NSString* userFname3;
@property (nonatomic, retain) NSString* userLname3;
@property (nonatomic, retain) NSString* userFname4;
@property (nonatomic, retain) NSString* userLname4;

@property int maxHole;
@property int numberHoles;
@end
