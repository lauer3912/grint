//
//  GrintImageDetail.h
//  grint
//
//  Created by Peter Rocker on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrintImageView.h"

@interface GrintImageDetail : UIViewController{
    IBOutlet UIImageView * imageView1;
    
}

-(IBAction)backClick:(id)sender;

@property (nonatomic, retain) NSString* filePath;
@property (nonatomic, retain) GrintImageView* delegate;

@end
