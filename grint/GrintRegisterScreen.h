//
//  GrintRegisterScreen.h
//  grint
//
//  Created by Peter Rocker on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
@class UICustomSwitch;

#import <UIKit/UIKit.h>
#import "GrintMasterViewController.h"

@interface GrintRegisterScreen : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    
    int m_nPickerKind;
    int m_anCurRow[3];
    
    IBOutlet UITextField* textFieldUsername;
    IBOutlet UITextField* textFieldPassword1;
    IBOutlet UITextField* textFieldPassword2;
    IBOutlet UITextField* textFieldEmail;
    IBOutlet UITextField* textFieldHandicap;
    IBOutlet UITextField* textFieldFirstname;
    IBOutlet UITextField* textFieldLastname;
    IBOutlet UITextField* textFieldCountry;
    IBOutlet UITextField* textFieldZip;
    IBOutlet UITextField* textFieldGender;
    
//    IBOutlet UILabel* label1;
//    IBOutlet UIButton* button1;
//    IBOutlet UIButton* button2;
    
    IBOutlet UIPickerView* pickerView1;
    
    
}

@property (nonatomic, retain) GrintMasterViewController* delegate;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) NSMutableArray* countryNames;
@property (nonatomic, retain) NSMutableArray* countryIso;

@property (nonatomic, retain) NSURLConnection * connection;

- (IBAction)backClick:(id)sender;
- (IBAction)registerClick:(id)sender;
-(void)setViewMovedUp:(BOOL)movedUp;
- (IBAction)openCountrySelector:(id)sender;
- (IBAction)openHandicap:(id)sender;
- (IBAction)openGender:(id)sender;

//updated code ; 2013/10/9

//members
@property (weak, nonatomic) IBOutlet UILabel *m_label1;
@property (weak, nonatomic) IBOutlet UILabel *m_label2;
@property (weak, nonatomic) IBOutlet UILabel *m_label3;

@property (weak, nonatomic) IBOutlet UIView *m_view1;
@property (weak, nonatomic) IBOutlet UIView *m_view2;
@property (weak, nonatomic) IBOutlet UIView *m_view3;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *m_photoView;

@property (weak, nonatomic) IBOutlet UIButton *m_btnJoin;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *m_btnEnter;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCheck;
@property (weak, nonatomic) IBOutlet UIView *m_confirmView;
@property (weak, nonatomic) IBOutlet UITextField *m_textConfirmEmail;
@property (weak, nonatomic) IBOutlet UIButton *m_btnGetStarted;

//methods
- (IBAction)actionTakePhoto:(id)sender;
- (IBAction)actionEnter:(id)sender;

- (IBAction)actionAccept:(id)sender;
- (IBAction)actionTerms:(id)sender;

- (IBAction)actionJoin:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionGetStarted:(id)sender;

@end