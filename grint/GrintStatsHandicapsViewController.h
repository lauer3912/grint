//
//  GrintStatsHandicapsViewController.h
//  grint
//
//  Created by Peter Rocker on 10/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface GrintStatsHandicapsViewController : UIViewController{
    
    IBOutlet UIPickerView* pickerViewCourses;
    IBOutlet UIPickerView* pickerViewFriends;
    
    IBOutlet UITextField* textField1;
    IBOutlet UITextField* textField2;
    IBOutlet UITextField* textField3;
    IBOutlet UITextField* textField4;
    
    IBOutlet UITextField* textFieldCourse;
    
    IBOutlet UILabel* labelCourseHcp1;
    IBOutlet UILabel* labelCourseHcp2;
    IBOutlet UILabel* labelCourseHcp3;
    IBOutlet UILabel* labelCourseHcp4;
    IBOutlet UILabel* labelHcp1;
    IBOutlet UILabel* labelHcp2;
    IBOutlet UILabel* labelHcp3;
    IBOutlet UILabel* labelHcp4;

    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
 
    IBOutlet UINavigationBar* navigationBar1;
    
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSMutableArray* friendsList;
@property (nonatomic, retain) NSMutableArray* friendFnameList;
@property (nonatomic, retain) NSMutableArray* friendLnameList;
@property (nonatomic, retain) NSMutableArray* courseList;
@property (nonatomic, retain) NSMutableArray* courseIdList;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSMutableArray* handicapList;
@property (nonatomic, retain) NSMutableArray* courseHandicapList;

@property (nonatomic, retain) UITextField* currentPlayerField;
@property (nonatomic, retain) UILabel* currentHandicapField;
@property (nonatomic, retain) UILabel* currentCourseHandicapField;

@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSString* nameString;

- (IBAction)navigationBack:(id)sender;

@end
