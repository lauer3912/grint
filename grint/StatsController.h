//
//  StatsController.h
//  grint
//
//  Created by Mountain on 8/20/13.
//
//

#import <UIKit/UIKit.h>

@class HandicapView;
@class ScoreView;
@class DrivingView;
@class IronsView;
@class GrintView;
@class PenaltyView;
@class ScramblingView;
@interface StatsController : UIViewController
{
    //subviews
    IBOutlet HandicapView* m_hcpView;
    IBOutlet ScoreView* m_scoreView;
    IBOutlet DrivingView* m_drivingView;
    IBOutlet IronsView* m_ironsView;
    IBOutlet GrintView* m_grintView;
    IBOutlet PenaltyView* m_penaltyView;
    IBOutlet ScramblingView* m_scramblingView;
}
//outer properties
@property(nonatomic, retain) NSString* username;
@property(nonatomic, retain) NSString* nameString;

//inner properties
@property (weak, nonatomic) IBOutlet UILabel *m_labelCaption;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTop;
@property (weak, nonatomic) IBOutlet UILabel *m_label11;
@property (weak, nonatomic) IBOutlet UILabel *m_label12;
@property (weak, nonatomic) IBOutlet UILabel *m_label13;
@property (weak, nonatomic) IBOutlet UILabel *m_label14;
@property (weak, nonatomic) IBOutlet UIPickerView *m_pickerView;
@property (weak, nonatomic) IBOutlet UINavigationBar *m_navBar;
@property (weak, nonatomic) IBOutlet UIScrollView *m_contentView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnContentType;
@property (weak, nonatomic) IBOutlet UIPageControl *m_currentPage;
@property (weak, nonatomic) IBOutlet UILabel *m_labelGolfer;
@property (weak, nonatomic) IBOutlet UILabel *m_labelCourse;
@property (weak, nonatomic) IBOutlet UILabel *m_labelRounds;
@property (weak, nonatomic) IBOutlet UILabel *m_labelType;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_labelExtra;

//action methods
//////////////////picker view done///////////
- (IBAction)actionDone:(id)sender;

/////////////////bottom bar action //////////
- (IBAction)actionSelectHole:(id)sender;
- (IBAction)actionSelectRounds:(id)sender;
- (IBAction)actionSelectCourse:(id)sender;
- (IBAction)actionSelectFriends:(id)sender;
- (IBAction)actionHandicap:(id)sender;

/////////////////view type selection/////////
- (IBAction)actionContentType:(id)sender;

- (IBAction)actionGoBack:(id)sender;

@end
