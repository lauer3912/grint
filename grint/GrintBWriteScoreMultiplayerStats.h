//
//  GrintBWriteScoreMultiplayerStats.h
//  grint
//
//  Created by Peter Rocker on 03/12/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintBWriteScoreMultiplayerStats : UIViewController{
  
    IBOutlet UILabel* labelHoleNo;
    IBOutlet UILabel* labelHoleParYds;
    
    IBOutlet UILabel* labelAvgScore1;
    IBOutlet UILabel* labelAvgPutts1;
    IBOutlet UILabel* labelAvgPenalty1;
    IBOutlet UILabel* labelTeeAccuracy1;
    IBOutlet UILabel* labelAvgGir1;
    IBOutlet UILabel* labelGrints1;
    
    IBOutlet UILabel* labelAvgScore2;
    IBOutlet UILabel* labelAvgPutts2;
    IBOutlet UILabel* labelAvgPenalty2;
    IBOutlet UILabel* labelTeeAccuracy2;
    IBOutlet UILabel* labelAvgGir2;
    IBOutlet UILabel* labelGrints2;
    
    IBOutlet UILabel* labelAvgScore3;
    IBOutlet UILabel* labelAvgPutts3;
    IBOutlet UILabel* labelAvgPenalty3;
    IBOutlet UILabel* labelTeeAccuracy3;
    IBOutlet UILabel* labelAvgGir3;
    IBOutlet UILabel* labelGrints3;
    
    IBOutlet UILabel* labelAvgScore4;
    IBOutlet UILabel* labelAvgPutts4;
    IBOutlet UILabel* labelAvgPenalty4;
    IBOutlet UILabel* labelTeeAccuracy4;
    IBOutlet UILabel* labelAvgGir4;
    IBOutlet UILabel* labelGrints4;
    
    IBOutlet UILabel* labelUsername1;
    IBOutlet UILabel* labelUsername2;
    IBOutlet UILabel* labelUsername3;
    IBOutlet UILabel* labelUsername4;
 
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    
}

@property (nonatomic, retain) NSArray* holeData;
@property (nonatomic, retain) NSString* holeNumber;
@property (nonatomic, retain) NSString* holeParYds;
@property (nonatomic, retain) NSString* username1;
@property (nonatomic, retain) NSString* username2;
@property (nonatomic, retain) NSString* username3;
@property (nonatomic, retain) NSString* username4;
@property (nonatomic, assign) UIViewController* delegate;

@property (nonatomic, retain) NSArray* scores;
@property (nonatomic, retain) NSMutableArray* playerData;

@end
