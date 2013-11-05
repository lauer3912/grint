//
//  GrintStatsScorecardDetailViewController.h
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "GrintCourseScore.h"

@interface GrintStatsScorecardDetailViewController : UIViewController{
    
    IBOutlet UILabel* label1;
    IBOutlet UILabel* label2;
 
    IBOutlet UIImageView* imageView1;
    
    BOOL furtherStatsEnabled;
    
}

@property (nonatomic, retain)GrintCourseScore* scores;
@property (nonatomic, retain)NSString* username;
@property (nonatomic, retain) NSString* nameString;

- (void) disableFurtherStats;

@end
