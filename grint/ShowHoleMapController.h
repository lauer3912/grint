//
//  ShowHoleMapController.h
//  grint
//
//  Created by Mountain on 7/4/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DrawView.h"

#import <GoogleMaps/GoogleMaps.h>

#define STR_KEY_TEEBOX @"Teebox"
#define STR_KEY_GREEN_CENTER @"Green Center"
#define STR_KEY_GREEN_BACK @"Green Back"
#define STR_KEY_GREEN_FRONT @"Green Front"
#define STR_KEY_FAIRWAY @"Fairway"

#define STR_KEY_HAZARD @"bunkers"

#define STR_KEY_MAP @"map" //lefttop, righttop, rightbottom, leftbottom

#define PI 3.141592

#define ZOOM 17

#define YARDS_PER_METER 1.0936133


typedef struct _EarthLocation {
    double dLatitute;
    double dLongitute;
} EarthLocation;

typedef struct _Coordinate2d {
    CGPoint point;
    CGSize szMapSize;
} Coordinate2D;

@class GMSMarker;
@class MapViewController;
@class THLabel;
@class SpinnerView;
@class GSBorderLabel;
@interface ShowHoleMapController : UIViewController<CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView* m_LogoImageView;
    IBOutlet UILabel* m_grCenterLabel;
    IBOutlet UILabel* m_grLabel;
    IBOutlet UIButton* m_GPSButton;
    
    IBOutlet UILabel* m_HoleLabel;
    IBOutlet UILabel* m_ParLabel;
    
    IBOutlet UILabel* m_extra1;
    IBOutlet UILabel* m_extra2;
    
    IBOutlet UIScrollView* m_infoScrollView;
    IBOutlet UIView* m_HoleMap;
    IBOutlet DrawView* m_OverlayMap;
    
    IBOutlet UIImageView* m_AimPointImageView;
    IBOutlet UIImageView* m_TeeboxImageView; // turn into the current location
    IBOutlet UIImageView* m_GreenCenterImageView;
    
    IBOutlet UIImageView* m_MapImageView;
    IBOutlet UIImageView* m_CloudImageView;
    
    IBOutlet GSBorderLabel* m_DistanceCenterLabel;
    IBOutlet GSBorderLabel* m_DistanceTeeboxLabel;
    
    BOOL m_FTouchedAimPoint;
    BOOL m_FFirst;
    
    int m_nAddedInfoItemCount;
    
    CLLocationManager* m_locationManager;
    
    UISwipeGestureRecognizer *swipeRecognizer;
    
    //location(latitude, langitute) info from server
    EarthLocation m_stCurrentLocation;
    
    EarthLocation m_stTeeBox, m_stGreenCenter, m_stGreenFront;
    EarthLocation m_stFairway, m_stGreenBack;
    
    EarthLocation m_stMapCenter;
    EarthLocation m_stAimPoint;
    
    CGPoint m_aptPoint[3]; //0-map center, 1-teebox, 2-green center
    //////////////////////////////////////////////////
    
    CGPoint m_ptPrev;
    
    double m_Angle; //rotation angle of map
    
    NSDictionary* m_dictMapInfo;
//    Communication* commServer;
    
    MapViewController* map;
    
    NSTimer* m_Timer;
    int m_nTimeCount;
    int m_nStep;
    
    CGContextRef m_context;
    
    BOOL m_FZoomed;
    
    SpinnerView* spinnerView;
}

@property int m_nDistCenter, m_nDistBack, m_nDistFront, m_nFirstDraw;

@property (nonatomic, retain) NSDictionary* m_dictCourseInfo;
@property (nonatomic, retain) NSDictionary* m_dictMapInfo;

- (IBAction)goBack:(id)sender;
- (void) brightProcessOfMap;

@end
