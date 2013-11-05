//
//  GrintHowToUse.h
//  grint
//
//  Created by Peter Rocker on 02/11/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintHowToUse : UIViewController

@property (nonatomic, assign)UIViewController* delegate;

- (IBAction)backClick:(id)sender;
- (void)swipeRightDetected:(id)sender;

@end
