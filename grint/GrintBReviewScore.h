//
//  GrintBReviewScore.h
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class GrintBReviewStats, GrintBDetail7;

#import <UIKit/UIKit.h>

@interface GrintBReviewScore : UIViewController{

    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;

    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    
    
    
}

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

@property BOOL isNine;
@property (nonatomic, retain) NSString* nineType;
@property (nonatomic, retain) NSArray* scores;

@property (nonatomic, retain) NSString* leaderboardID;

@property (strong, nonatomic) GrintBDetail7 *detailViewController;

@end
