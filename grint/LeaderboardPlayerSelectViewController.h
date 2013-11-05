//
//  LeaderboardPlayerSelectViewController.h
//  grint
//
//  Created by Peter Rocker on 30/05/2013.
//
//

#import <UIKit/UIKit.h>

@interface LeaderboardPlayerSelectViewController : UIViewController{
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label7;
    IBOutlet UILabel* label8;
    IBOutlet UILabel* label9;
    IBOutlet UILabel* label10;
    IBOutlet UILabel* label11;
    IBOutlet UILabel* label12;
    IBOutlet UILabel* label13;
    
    
    IBOutlet UIButton* button1;
    
    IBOutlet UITextField* textField1;
    IBOutlet UITextField* textField2;
    IBOutlet UITextField* textField3;
    IBOutlet UITextField* textField4;
    
    IBOutlet UIPickerView* pickerView1;
    
    IBOutlet UILabel* labelCourseHcp1;
    IBOutlet UILabel* labelCourseHcp2;
    IBOutlet UILabel* labelCourseHcp3;
    IBOutlet UILabel* labelCourseHcp4;
    IBOutlet UILabel* labelHcp1;
    IBOutlet UILabel* labelHcp2;
    IBOutlet UILabel* labelHcp3;
    IBOutlet UILabel* labelHcp4;
    
    IBOutlet UINavigationBar* navigationBar1;
    
    int m_nIndex;
}

-(IBAction)nextScreen:(id)sender;
-(IBAction)addUser:(id)sender;
- (IBAction)beginTextEdit:(id)sender;

- (IBAction)clearField2:(id)sender;
- (IBAction)clearField3:(id)sender;
- (IBAction)clearField4:(id)sender;
- (IBAction)navigationDoneClick:(id)sender;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* teeboxColor;
@property (nonatomic, retain) NSString* score;
@property (nonatomic, retain) NSString* putts;
@property (nonatomic, retain) NSString* penalties;
@property (nonatomic, retain) NSString* accuracy;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSMutableArray* pastUsers;
@property (nonatomic, retain) NSString* courseID;
@property (nonatomic, retain) NSMutableArray* friendList;
@property (nonatomic, retain) NSMutableArray* friendFnameList;
@property (nonatomic, retain) NSMutableArray* friendLnameList;
@property (nonatomic, retain) NSMutableArray* handicapList;
@property (nonatomic, retain) NSMutableArray* courseHandicapList;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSNumber* holeOffset;

@property (nonatomic, retain) NSString* username1;
@property (nonatomic, retain) NSString* userFname1;
@property (nonatomic, retain) NSString* userLname1;
@property (nonatomic, retain) NSString* username2;
@property (nonatomic, retain) NSString* userFname2;
@property (nonatomic, retain) NSString* userLname2;
@property (nonatomic, retain) NSString* username3;
@property (nonatomic, retain) NSString* userFname3;
@property (nonatomic, retain) NSString* userLname3;
@property (nonatomic, retain) NSString* username4;
@property (nonatomic, retain) NSString* userFname4;
@property (nonatomic, retain) NSString* userLname4;


@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* leaderboardID;
@property (nonatomic, retain) NSString* leaderboardPass;
@property (nonatomic, retain) NSString* teeID;



@property (nonatomic, retain) NSURLConnection * connection;


@end
