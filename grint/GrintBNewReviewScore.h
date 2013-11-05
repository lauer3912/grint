//
//  GrintBNewReviewScore.h
//  grint
//
//  Created by Passioner on 9/18/13.
//
//

#import <UIKit/UIKit.h>
#import "GrintCourseScore.h"

@class GrintBDetail7;

@interface GrintBNewReviewScore : UIViewController<UIAlertViewDelegate>

@property int m_nViewType;

@property (weak, nonatomic) IBOutlet UILabel *m_labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_labelHoleType;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore1;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore2;
@property (weak, nonatomic) IBOutlet UILabel *m_labelUserName;

@property (weak, nonatomic) IBOutlet UIImageView *m_twitterImage;
@property (weak, nonatomic) IBOutlet UIImageView *m_facebookImage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnShare;
- (IBAction)actionShare:(id)sender;

- (IBAction)goBack:(id)sender;
- (IBAction)selectHoleType:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNext;
- (IBAction)goNext:(id)sender;

//variables setting out of this class

@property (nonatomic, retain) NSString* m_strCourseName;
@property (nonatomic, retain) NSString* m_strUserName;
@property (nonatomic, retain) NSArray* m_scores;
@property (nonatomic, retain) NSString* nineType;
@property BOOL isNine;
@property BOOL FComplete;

//copied from prev reviewscore
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

@property (nonatomic, retain) NSArray* scores;

@property (nonatomic, retain) NSString* leaderboardID;

@property (strong, nonatomic) GrintBDetail7 *detailViewController;

@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSMutableData* data;
//for review last score

@property (nonatomic, retain) GrintCourseScore* courseScores;

@end
