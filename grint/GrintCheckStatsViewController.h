//
//  GrintCheckStatsViewController.h
//  grint
//
//  Created by Peter Rocker on 06/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface GrintCheckStatsViewController : UIViewController{
    
    IBOutlet UILabel* labelScore;
    IBOutlet UILabel* labelPutts;
    IBOutlet UILabel* labelHazards;
    IBOutlet UILabel* labelTeeAcc;
    IBOutlet UILabel* labelGIR;
    IBOutlet UILabel* labelGrints;
    IBOutlet UILabel* labelGrintsLabel;
    IBOutlet UILabel* labelCourseHandicap;
    IBOutlet UITextField* textField1;
    IBOutlet UIPickerView* picker1;
    IBOutlet UILabel* labelTitle;
    IBOutlet UINavigationBar* navigationBar1;
    IBOutlet UIButton* button3;
}

- (IBAction)navigationDoneClick:(id)sender;

@property (nonatomic, retain) NSMutableArray* courseList;
@property (nonatomic, retain) NSMutableArray* courseIdList;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) SpinnerView* spinnerView;
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSString* nameString;


@end
