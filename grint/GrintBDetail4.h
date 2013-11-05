//
//  GrintBDetail4.h
//  GrintB
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GrintBDetail5, GrintBHistoricalPerformance;

@interface GrintBDetail4 : UIViewController{
    IBOutlet UITextField* dateField;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label8;
    IBOutlet UILabel* label9;
    
    IBOutlet UIButton* button1;
    
    IBOutlet UISwitch* switchScore;
    IBOutlet UISwitch* switchPutts;
    IBOutlet UISwitch* switchPenalties;
    IBOutlet UISwitch* switchTeeAccuracy;
 
    IBOutlet UILabel* label7;
    IBOutlet UIStepper* stepper1;
    
    IBOutlet UIPickerView* pickerViewHoles;
    IBOutlet UINavigationBar* navBarPicker;
    IBOutlet UITextField* textFieldHoles;
    
    int startingHole;
}

-(IBAction)nextScreen:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;
- (IBAction)changeStartingHole:(id)sender;

@property (strong, nonatomic) GrintBHistoricalPerformance *detailViewController;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* teeboxColor;
@property (nonatomic, retain) NSString* teeID;
@property (nonatomic, retain) NSString* fname;
@property (nonatomic, retain) NSString* lname;

@property (nonatomic, retain) NSNumber* courseID;

@property int maxHole;
@property int numberHoles;
@property BOOL isNine;

@end
