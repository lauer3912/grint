//
//  LeaderboardCentralViewController.h
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

@interface LeaderboardCentralViewController : UIViewController<CLLocationManagerDelegate, TSAlertViewDelegate, MyActionSheetDelegate>
{
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
    BOOL m_FBackMap;
    BOOL m_bIsMap;
    
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
