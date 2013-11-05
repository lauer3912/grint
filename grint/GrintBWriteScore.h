//
//  GrintBWriteScore.h
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class GrintBReviewScore;

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreLocation/CoreLocation.h>
#import "GrintBNewReviewScore.h"

#import "S_HoleForGPS.h"
#import "TSAlertView.h"
#import "MapperActionSheet.h"

#define STR_SHOW_GREEN_INFO @"SHOW_GREEN_INFO"

@class ShowHoleMapController;
@interface GrintBWriteScore : UIViewController<MyActionSheetDelegate, TSAlertViewDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate>{
    
    IBOutlet UILabel* labelHoleNo;
    IBOutlet UILabel* labelHoleParYds;
    IBOutlet UILabel* labelScore;
    IBOutlet UILabel* labelPutts;
    IBOutlet UILabel* labelPenalty;
    IBOutlet UILabel* labelFairway;
    IBOutlet UILabel* labelAvgScore;
    IBOutlet UILabel* labelAvgPutts;
    IBOutlet UILabel* labelAvgPenalty;
    IBOutlet UILabel* labelTeeAccuracy;
    IBOutlet UILabel* labelAvgGir;
    IBOutlet UILabel* labelGrints;
    
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
    
    //update code
    IBOutlet UILabel* labelGrint;
    IBOutlet UILabel* labelGPS;
    IBOutlet UILabel* labelExtra;
    IBOutlet UILabel* labelGreenCenter;
    IBOutlet UIButton* btnGPS;
    int m_nPurchaseKind;
    
    NSArray* _products;
    
    NSMutableDictionary* m_dictMap;
    
    CLLocationManager* m_LocationManager;
    
    ShowHoleMapController *gpsMapController;
    
    IBOutlet UILabel* labelBottom;
    
    ///2013.9.11
    int m_nMaxHole;
    
    S_HoleForGPS* m_astHoleMap[18];
    BOOL m_FEnableGPS;
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

@property int holeID;
@property (retain, nonatomic) NSString* m_strHoleYards;

@property (nonatomic, retain) NSString* teeID;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSNumber* holeOffset;

@property (nonatomic, retain) NSURLConnection * connection;
@property (strong, nonatomic) GrintBNewReviewScore *detailViewController;

@property (nonatomic, retain) NSArray* pickerData;
@property (nonatomic, retain) NSArray* scores;
@property (nonatomic, assign) NSInteger currentHole;

@property (nonatomic, retain) NSMutableData* data;

@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property int maxHole;
@property int numberHoles;
- (IBAction)showPicker:(id)sender;

- (IBAction)showGPSInfo:(id)sender;
- (void) showGreenInfo;
- (IBAction)goToNext:(id)sender;
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
