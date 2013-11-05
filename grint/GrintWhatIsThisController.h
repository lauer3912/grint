//
//  GrintWhatIsThisController.h
//  grint
//
//  Created by Peter Rocker on 31/10/2012.
//
//

#import <UIKit/UIKit.h>

@class GrintDetailViewController;

@interface GrintWhatIsThisController : UIViewController{
    
    IBOutlet UIScrollView* scrollView1;
    
}

@property (nonatomic, assign) GrintDetailViewController* delegate;

@end
