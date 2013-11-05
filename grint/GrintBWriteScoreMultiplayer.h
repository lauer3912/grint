//
//  GrintBWriteScoreMultiplayer.h
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>

#import "GrintBNewMultiReviewScore.h"

#import "S_HoleForGPS.h"
#import "TSAlertView.h"

#import "MapperActionSheet.h"

#define STR_SHOW_GREEN_INFO @"SHOW_GREEN_INFO"

@class ShowHoleMapController;
@class GrintBNewMultiReviewScore;

@interface GrintBWriteScoreMultiplayer : UIViewController<MyActionSheetDelegate, TSAlertViewDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate>{
    
    IBOutlet UILabel* labelHoleNo;
    IBOutlet UILabel* labelHoleParYds;
    IBOutlet UILabel* labelScore1;
    IBOutlet UILabel* labelPutts1;
    IBOutlet UILabel* labelPenalty1;
    IBOutlet UILabel* labelFairway1;
    IBOutlet UILabel* labelScore2;
    IBOutlet UILabel* labelPutts2;
    IBOutlet UILabel* labelPenalty2;
    IBOutlet UILabel* labelFairway2;
    IBOutlet UILabel* labelScore3;
    IBOutlet UILabel* labelPutts3;
    IBOutlet UILabel* labelPenalty3;
    IBOutlet UILabel* labelFairway3;
    IBOutlet UILabel* labelScore4;
    IBOutlet UILabel* labelPutts4;
    IBOutlet UILabel* labelPenalty4;
    IBOutlet UILabel* labelFairway4;
    
    IBOutlet UIButton* buttonPrev;
    IBOutlet UIButton* buttonNext;
    IBOutlet UIButton* buttonEnter;
    
    IBOutlet UIPickerView* picker1;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label7;
    IBOutlet UILabel* label8;
    IBOutlet UILabel* label9;
    IBOutlet UILabel* label10;
    
    IBOutlet UILabel* labelStrokesSoFar;
    IBOutlet UILabel* labelScoreSoFar;
    
    int editingScoreIndex;
    
    IBOutlet UILabel* labelUsername1;
    IBOutlet UILabel* labelUsername2;
    IBOutlet UILabel* labelUsername3;
    IBOutlet UILabel* labelUsername4;
    
    //update code
    IBOutlet UILabel* labelGrint;
    IBOutlet UILabel* labelGPS;
    IBOutlet UILabel* labelExtra;
    IBOutlet UILabel* labelGreenCenter;
    IBOutlet UIButton* btnGPS;
    int m_nPurchaseKind;
    
    NSArray* _products;
    
    NSMutableDictionary* m_dictMap;
    
    BOOL m_FEnableGPS;
    CLLocationManager* m_LocationManager;
    
    ShowHoleMapController *gpsMapController;
    
    IBOutlet UILabel* labelBottom;
    
    ///2013.9.11
    int m_nMaxHole;
    
    S_HoleForGPS* m_astHoleMap[18];
    BOOL m_FMapButton;
    BOOL m_FOnByGlance;
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

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

@property int holeID; //added code
@property (retain, nonatomic) NSString* m_strHoleYards;

@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property (nonatomic, retain) NSURLConnection * connection;
@property (strong, nonatomic) GrintBNewMultiReviewScore *detailViewController;

@property (nonatomic, retain) NSArray* pickerData;
@property (nonatomic, retain) NSArray* scores;
@property (nonatomic, assign) NSInteger currentHole;

@property (nonatomic, retain) NSMutableData* data;

@property int maxHole;
@property int numberHoles;

- (IBAction)showPicker:(id)sender;
- (IBAction)showGPSInfo:(id)sender;
- (void) showGreenInfo;

- (IBAction)gotToNext:(id)sender;
- (IBAction)goToPrev:(id)sender;

//2013.9.11
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore1;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore2;
@property (weak, nonatomic) IBOutlet UILabel *m_labelHole;
@property (weak, nonatomic) IBOutlet UILabel *m_labelGPSState;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTrack;
@property (weak, nonatomic) IBOutlet UILabel *m_labelScore;
@property (weak, nonatomic) IBOutlet UILabel *m_labelHoleCaption;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTh;
@property (weak, nonatomic) IBOutlet UIButton *m_btnGPSState;


- (IBAction)onTouchScoreButton:(id)sender;
- (IBAction)onTouchHoleButton:(id)sender;
- (IBAction)onTouchGPSStateButton:(id)sender;
- (void) changeGPSState;
- (void) gpsOnProcess;

@end