//
//  LeaderboardCentralMultiplayerViewController.h
//  grint
//
//  Created by Peter Rocker on 14/05/2013.
//
//

#import <UIKit/UIKit.h>
#import "ShowHoleMapController.h"
#import <CoreLocation/CoreLocation.h>

#import "TSAlertView.h"

#import "MapperActionSheet.h"

#define STR_SHOW_GREEN_INFO @"SHOW_GREEN_INFO"

@interface LeaderboardCentralMultiplayerViewController : UIViewController<CLLocationManagerDelegate, TSAlertViewDelegate, MyActionSheetDelegate>
{
    IBOutlet UILabel* labelGrint;
    IBOutlet UILabel* labelGPS;
    IBOutlet UILabel* labelExtra;
    IBOutlet UILabel* labelGreenCenter;
    IBOutlet UIButton* btnGPS;
    int m_nPurchaseKind;
    
    BOOL m_FUp;
    NSArray* _products;
    
    NSMutableDictionary* m_dictMap;
    
    BOOL m_FEnableGPS;
    BOOL m_bIsMap;
    CLLocationManager* m_LocationManager;
    
    ShowHoleMapController *gpsMapController;
    BOOL m_FBackMap;
    
    float m_rFirstHeight;
    
    BOOL m_FOnByGlance;
}

@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* leaderboardID;
@property (nonatomic, retain) NSString* courseID;
@property (nonatomic, retain) NSString* leaderboardPass;
@property (nonatomic, retain) NSString* teeID;
@property BOOL disableInput;
@property (nonatomic, retain) NSString* player1;
@property (nonatomic, retain) NSString* player2;
@property (nonatomic, retain) NSString* player3;
@property (nonatomic, retain) NSString* player4;

@property (nonatomic, retain) NSMutableArray* playerData;

@property (nonatomic, retain) NSString* score;
@property (nonatomic, retain) NSString* putts;
@property (nonatomic, retain) NSString* penalties;
@property (nonatomic, retain) NSString* accuracy;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSNumber* holeOffset;

@property BOOL isShowingRank;

- (IBAction)showPicker:(id)sender;


@property int holeID;
@property (retain, nonatomic) NSString* m_strHoleYards;
- (IBAction)showGPSInfo:(id)sender;
- (void) showGreenInfo;

@end
