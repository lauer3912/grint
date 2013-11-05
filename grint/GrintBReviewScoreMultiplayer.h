//
//  GrintBReviewScoreMultiplayer.h
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

@class GrintBReviewStatsMultiplayer, GrintBDetail7Multiplayer;

#import <UIKit/UIKit.h>

@interface GrintBReviewScoreMultiplayer : UIViewController{
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    
    IBOutlet UILabel* labelPlayername;
    
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    
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
@property (nonatomic, retain) NSNumber* holeOffset;

@property (nonatomic, retain) NSString* leaderboardID;
@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property (nonatomic, retain) NSMutableArray* playerData;

@property (nonatomic, retain) NSArray* scores;

@property (strong, nonatomic) GrintBDetail7Multiplayer *detailViewController;

@end
