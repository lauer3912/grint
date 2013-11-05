//
//  GrintDetail2.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>
#import "SpinnerView.h"

@class GrintDetail3;

@interface GrintDetail2 : UIViewController{
    IBOutlet UILabel* label1;
    IBOutlet UISearchBar* searchBar1;
    IBOutlet UITableView* tableView1;
    BOOL locationEnabled;
}

- (void) downloadRows;
- (void) generateRows;

@property (strong, nonatomic) GrintDetail3 *detailViewController;
@property (nonatomic, retain) NSMutableArray * rows;
@property (nonatomic, retain) NSMutableArray * rawRows;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) CLLocationManager* locman;

@property (nonatomic, retain) NSString* csv;

@property (nonatomic, retain) SpinnerView* spinnerView;


@property double userLat;
@property double userLon;
@property bool shouldWarnGPS;

@end
