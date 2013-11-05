//
//  GrintBDetail2.h
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
#import "SpinnerView.h"

@class GrintBDetail3;

@interface GrintBDetail2 : UIViewController{
    IBOutlet UILabel* label1;
    IBOutlet UISearchBar* searchBar1;
    IBOutlet UITableView* tableView1;
    BOOL locationEnabled;
}

- (void) downloadRows;
- (void) generateRows;

@property (strong, nonatomic) GrintBDetail3 *detailViewController;
@property (nonatomic, retain) NSMutableArray * rows;
@property (nonatomic, retain) NSMutableArray * rawRows;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) CLLocationManager* locman;

@property (nonatomic, retain) NSString* csv;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;
@property double userLat;
@property double userLon;
@property bool shouldWarnGPS;

@property (nonatomic, retain) SpinnerView* spinnerView;

@property BOOL isLeaderboard;
@property (nonatomic, retain) NSString* leaderboardName;
@property (nonatomic, retain) NSString* leaderboardPass;

@end
