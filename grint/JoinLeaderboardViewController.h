//
//  JoinLeaderboardViewController.h
//  grint
//
//  Created by Peter Rocker on 13/05/2013.
//
//

#import <UIKit/UIKit.h>

@interface JoinLeaderboardViewController : UIViewController

@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* leaderboardID;
@property (nonatomic, retain) NSString* leaderboardPass;
@property (nonatomic, retain) NSString* teeID;

@property (nonatomic, retain) NSString* score;
@property (nonatomic, retain) NSString* putts;
@property (nonatomic, retain) NSString* penalties;
@property (nonatomic, retain) NSString* accuracy;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSNumber* holeOffset;

@end
