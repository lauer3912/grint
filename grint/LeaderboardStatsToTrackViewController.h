//
//  LeaderboardStatsToTrackViewController.h
//  grint
//
//  Created by Peter Rocker on 05/06/2013.
//
//

#import <UIKit/UIKit.h>

@interface LeaderboardStatsToTrackViewController : UIViewController{
    IBOutlet UITextField* dateField;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label8;
    
    IBOutlet UIButton* button1;
    
    IBOutlet UISwitch* switchScore;
    IBOutlet UISwitch* switchPutts;
    IBOutlet UISwitch* switchPenalties;
    IBOutlet UISwitch* switchTeeAccuracy;
    
    IBOutlet UILabel* label7;
    IBOutlet UIStepper* stepper1;
    
    int startingHole;
}

-(IBAction)nextScreen:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;
- (IBAction)changeStartingHole:(id)sender;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* teeboxColor;
@property (nonatomic, retain) NSString* teeID;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* leaderboardID;
@property (nonatomic, retain) NSString* leaderboardPass;
@property (nonatomic, retain) NSString* courseID;


@end
