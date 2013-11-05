//
//  GrintDetailViewController.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>
#import "SpinnerView.h"

@class GrintCourseDownload;
@class GrintBCourseDownload;

@interface GrintDetailViewController : UIViewController <SKProductsRequestDelegate, SKRequestDelegate, UIActionSheetDelegate, UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>{
    
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UIButton* button3;
    IBOutlet UIButton* button4;
    IBOutlet UIButton* button5;
    IBOutlet UIButton* button6;
    IBOutlet UIButton* button7;
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
    
    UIActionSheet* actionSheet;
    
    IBOutlet UILabel* labelLogo;
}

- (IBAction)shootCard:(id)sender;
- (IBAction)viewCards:(id)sender;
- (IBAction)launchWebsite:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)whatIsThisClick:(id)sender;
-(IBAction)viewActivity:(id)sender;
-(IBAction)viewStats:(id)sender;
- (void)removeSpinnerIfExists;
- (IBAction)feedbackEmail:(id)sender;

@property (nonatomic, retain) UILabel* label2;
@property (nonatomic, retain) UIButton* button3;

@property (nonatomic, retain) NSArray* availableProducts;

@property (strong, nonatomic) GrintCourseDownload *detailViewController;
@property (strong, nonatomic) UIViewController *detailViewControllerB;

@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* handicap;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* userImage;

@property (nonatomic, assign) BOOL isMember;
@property (nonatomic, assign) BOOL isGuest;

@property NSInteger memberType;
@property NSInteger trialCounter;
@property NSInteger spsCounter;
@property NSInteger expired;

@property (nonatomic, retain) SpinnerView* spinnerView1;

@property (weak, nonatomic) IBOutlet UIView *m_menuView;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *m_labelName;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTip;
- (IBAction)actionEditProfile:(id)sender;

- (IBAction)actionShowMenu:(id)sender;

- (IBAction)actionGoBack:(id)sender;
- (IBAction)actionPlayGolf:(id)sender;

- (IBAction)actionScorePicture:(id)sender;
- (IBAction)actionHandicapStats:(id)sender;
- (IBAction)actionActivityFeed:(id)sender;
- (IBAction)actionEditScore:(id)sender;
- (IBAction)actionMyUSGA:(id)sender;
- (IBAction)actionInviteFriends:(id)sender;
- (IBAction)actionAboutUs:(id)sender;

- (IBAction)actionAddFriends:(id)sender;
- (IBAction)actionTerms:(id)sender;


@end
