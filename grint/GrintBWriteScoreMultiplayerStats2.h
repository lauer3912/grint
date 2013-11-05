//
//  GrintBWriteScoreMultiplayerStats.h
//  grint
//
//  Created by Peter Rocker on 03/12/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintBWriteScoreMultiplayerStats2 : UIViewController{
    
    IBOutlet UILabel* labelHoleNo;
    IBOutlet UILabel* labelHoleParYds;
    
    IBOutlet UILabel* labelScoreOverPar1;
    IBOutlet UILabel* labelTotalStrokes1;
    IBOutlet UILabel* labelFrontNine1;
    IBOutlet UILabel* labelBackNine1;
    
    IBOutlet UILabel* labelScoreOverPar2;
    IBOutlet UILabel* labelTotalStrokes2;
    IBOutlet UILabel* labelFrontNine2;
    IBOutlet UILabel* labelBackNine2;
    
    IBOutlet UILabel* labelScoreOverPar3;
    IBOutlet UILabel* labelTotalStrokes3;
    IBOutlet UILabel* labelFrontNine3;
    IBOutlet UILabel* labelBackNine3;
    
    IBOutlet UILabel* labelScoreOverPar4;
    IBOutlet UILabel* labelTotalStrokes4;
    IBOutlet UILabel* labelFrontNine4;
    IBOutlet UILabel* labelBackNine4;
    
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
