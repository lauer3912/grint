//
//  TDDatePickerController.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TDDatePickerController : UIViewController {
    id delegate;
//    IBOutlet UILabel *labelGPS;
}

@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;

-(IBAction)saveDateEdit:(id)sender;
-(IBAction)clearDateEdit:(id)sender;
-(IBAction)cancelDateEdit:(id)sender;

@end

@interface NSObject (TDDatePickerControllerDelegate)
-(void)datePickerSetDate:(TDDatePickerController*)viewController;
-(void)datePickerClearDate:(TDDatePickerController*)viewController;
-(void)datePickerCancel:(TDDatePickerController*)viewController;
@end
