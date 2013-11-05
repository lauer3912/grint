//
//  GrintBNewMultiReviewScore.h
//  grint
//
//  Created by Passioner on 9/19/13.
//
//

#import <UIKit/UIKit.h>

@class GrintBDetail7Multiplayer;
@interface GrintBNewMultiReviewScore : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *m_labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_labelHoleType;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore1;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore2;
@property (weak, nonatomic) IBOutlet UILabel *m_labelUserName;


- (IBAction)goBack:(id)sender;
- (IBAction)goNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNext;
- (IBAction)selectHoleType:(id)sender;

//variables setting out of this class

@property (nonatomic, retain) NSString* m_strCourseName;
@property (nonatomic, retain) NSString* m_strUserName;
@property (nonatomic, retain) NSArray* m_scores;
@property (nonatomic, retain) NSString* nineType;
@property BOOL isNine;
@property BOOL FComplete;

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
@property (nonatomic, retain) NSMutableArray* playerData;

@property (nonatomic, retain) NSArray* scores;

@property (strong, nonatomic) GrintBDetail7Multiplayer *detailViewController;

@end
