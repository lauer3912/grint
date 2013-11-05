//
//  GrintDetail4.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GrintDetail5;

@interface GrintDetail4 : UIViewController{
    IBOutlet UITextField* dateField;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label7;
    
    IBOutlet UIButton* button1;
    
    IBOutlet UISwitch* switchScore;
    IBOutlet UISwitch* switchPutts;
    IBOutlet UISwitch* switchPenalties;
    IBOutlet UISwitch* switchTeeAccuracy;
    
}

-(IBAction)nextScreen:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;

@property (strong, nonatomic) GrintDetail5 *detailViewController;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseAddress;
@property (nonatomic, retain) NSString* teeboxColor;

@property (nonatomic, retain) NSNumber* courseID;


@end
