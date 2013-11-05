//
//  SpinnerView.h
//  grint
//
//  Created by Peter Rocker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpinnerView : UIView

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
	-(void)removeSpinner;
- (UIImage *)addBackground;
    
@end
