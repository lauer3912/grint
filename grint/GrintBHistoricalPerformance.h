//
//  GrintBHistoricalPerformance.h
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@class GrintBWriteScore;

@interface GrintBHistoricalPerformance : UIViewController{
    
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

@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property (nonatomic, retain) NSURLConnection * connection;

@property (nonatomic, retain) NSMutableData* data;

@property (strong, nonatomic) GrintBWriteScore *detailViewController;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

@property int maxHole;
@property int numberHoles;

@end
