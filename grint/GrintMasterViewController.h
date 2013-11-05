//
//  GrintMasterViewController.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GrintDetailViewController, SpinnerView;

@interface GrintMasterViewController : UIViewController{
    IBOutlet UILabel* label1;
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UIButton* button3;
    IBOutlet UITextField* textField1;
    IBOutlet UITextField* textField2;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UITextField* activeField;
    
    IBOutlet UIButton* buttonLogin;
    IBOutlet UIButton* buttonJoin;
    
    IBOutlet UIView* loginView;
    
    int m_nDismiss;
}

- (IBAction)logIn:(id)sender;
- (IBAction)loginGuest:(id)sender;
- (IBAction)loginUser:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)showLoginUI:(id)sender;
- (IBAction)goToSite:(id)sender;

- (IBAction) registerUser:(id)sender;
- (IBAction) videoClick:(id)sender;
- (IBAction) dismissTextViews:(id)sender;

@property (nonatomic, retain) NSMutableData* data;
@property (strong, nonatomic) GrintDetailViewController *detailViewController;

@property (nonatomic, retain) SpinnerView* spinnerView;

@property (nonatomic, retain) NSURLConnection * connection;
@end

@interface NSString (CWAddition)
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end
