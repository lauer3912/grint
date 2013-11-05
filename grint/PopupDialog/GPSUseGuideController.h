//
//  GPSUseGuideController.h
//  grint
//
//  Created by Passioner on 9/18/13.
//
//

#import <UIKit/UIKit.h>
#import "UIXOverlayController.h"

@interface GPSUseGuideController : UIXOverlayContentViewController
@property (retain, nonatomic) IBOutlet UILabel *m_labelTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_label1;
@property (retain, nonatomic) IBOutlet UILabel *m_label2;
@property (retain, nonatomic) IBOutlet UILabel *m_label3;
@property (retain, nonatomic) IBOutlet UIButton *m_label4;

@property (nonatomic, retain) UIViewController* m_parentController;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDontShow:(id)sender;

- (IBAction)actionContinue:(id)sender;

@end
