//
//  GrintBDetail3.h
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@class GrintBDetail4;

@interface GrintBDetail3 : UIViewController<UITableViewDelegate>{
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UITableView* tableView1;
}

- (IBAction)selectTee:(id)sender;

@property (strong, nonatomic) GrintBDetail4 *detailViewController;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSNumber* courseID;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableArray* rows;
@property (nonatomic, retain) NSString* teeID;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

@property (nonatomic, retain) NSURLConnection * connection;

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string;


@property BOOL isLeaderboard;
@property (nonatomic, retain) NSString* leaderboardName;
@property (nonatomic, retain) NSString* leaderboardPass;

@end
