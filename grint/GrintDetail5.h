//
//  GrintDetail5.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GrintDetail7;

@interface GrintDetail5 : UIViewController{
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
    
    IBOutlet UILabel* labelCourse;
    
    IBOutlet UIButton* button1;
    
    IBOutlet UITextField* textField1;
    IBOutlet UITextField* textField2;
    IBOutlet UITextField* textField3;
    IBOutlet UITextField* textField4;
    
    IBOutlet UIPickerView* pickerView1;

    IBOutlet UINavigationBar* navigationBar1;
    
}

-(IBAction)navigationBackClick:(id)sender;

-(IBAction)nextScreen:(id)sender;
-(IBAction)addUser:(id)sender;

@property (strong, nonatomic) GrintDetail7 *detailViewController;

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
@property (nonatomic, retain) NSNumber* courseID;
@property (nonatomic, retain) NSMutableArray* friendList;
@property (nonatomic, retain) NSMutableArray* friendListNames;
@property (nonatomic, retain) NSMutableData* data;

@property (nonatomic, retain) NSURLConnection * connection;
@end
