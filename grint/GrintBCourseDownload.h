//
//  GrintBCourseDownload.h
//  GrintB
//
//  Created by Peter Rocker on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "SpinnerView.h"

@class GrintBDetail2;

@interface GrintBCourseDownload : UIViewController{
    IBOutlet UIPickerView* picker1;
    IBOutlet UINavigationBar* navigationBar1;
    BOOL locationEnabled;
    double userLat;
    double userLon;
    int selectionMode;
    
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UIButton* button3;
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
}

- (IBAction)coursesNearMe:(id)sender;
- (IBAction)coursesInState:(id)sender;
- (IBAction)coursesLastDownloaded:(id)sender;
- (IBAction)pastCoursesClick:(id)sender;
- (IBAction)inStateClick:(id)sender;
- (IBAction)stateConfirmClick:(id)sender;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

@property (strong, nonatomic) GrintBDetail2 *detailViewController;

@property (nonatomic, retain) CLLocationManager* locman;

@property (nonatomic, retain) SpinnerView* spinnerView;

@property BOOL isLeaderboard;
@property (nonatomic, retain) NSString* leaderboardName;
@property (nonatomic, retain) NSString* leaderboardPass;


@end
