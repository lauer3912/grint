//
//  GrintDetail7.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "SpinnerView.h"

@interface GrintDetail7 : UIViewController <SKPSMTPMessageDelegate> {
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    IBOutlet UILabel* label3;
    IBOutlet UILabel* label4;
    IBOutlet UILabel* label5;
    IBOutlet UILabel* label6;
    IBOutlet UILabel* label7;
    
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    
    IBOutlet UILabel* background1;
    
    IBOutlet UITextField* textField1;
    
    IBOutlet UIScrollView* scrollView;
    IBOutlet UITextField* activeField;
    
    int funRating;
    int conditionRating;
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
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSNumber* courseID;

@property (nonatomic, retain) NSURLConnection * connection;
- (IBAction)backToStart:(id)sender;

- (IBAction)starClick:(id)sender;

//- (IBAction)submitFeedback:(id)sender;

@end
