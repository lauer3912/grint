//
//  GrintImageView.h
//  grint
//
//  Created by Peter Rocker on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrintDetailViewController.h"

@interface GrintImageView : UIViewController

- (IBAction)backClick:(id)sender;

@property (nonatomic, retain) GrintDetailViewController* delegate;
@property (nonatomic, retain) NSArray* rows;
@property (nonatomic, retain) NSArray* images;

@end
