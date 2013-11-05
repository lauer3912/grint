//
//  GrintStatsSelectViewController.h
//  grint
//
//  Created by Peter Rocker on 05/12/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintStatsSelectViewController : UIViewController{
    
    IBOutlet UILabel* label1;
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UIButton* button3;
    IBOutlet UIButton* button4;
    IBOutlet UIButton* button5;
    
}

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* nameString;
@property (nonatomic, retain) NSString* lastName;

- (IBAction)button1Click:(id)sender;
- (IBAction)button2Click:(id)sender;
- (IBAction)button3Click:(id)sender;
- (IBAction)button4Click:(id)sender;

@end
