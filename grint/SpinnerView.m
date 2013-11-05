//
//  SpinnerView.m
//  grint
//
//  Created by Peter Rocker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIImage *)addBackground{
	// Create an image context (think of this as a canvas for our masterpiece) the same size as the view
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
	// Our gradient only has two locations - start and finish. More complex gradients might have more colours
    size_t num_locations = 2;
	// The location of the colors is at the start and end
    CGFloat locations[2] = { 0.0, 1.0 };
	// These are the colors! That's two RBGA values
    CGFloat components[8] = {
        0.4,0.4,0.4, 0.8,
        0.1,0.1,0.1, 0.5 };
	// Create a color space
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
	// Create a gradient with the values we've set up
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
	// Set the radius to a nice size, 80% of the width. You can adjust this
    float myRadius = (self.bounds.size.width*.8)/2;
	// Now we draw the gradient into the context. Think painting onto the canvas
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, self.center, 0, self.center, myRadius, kCGGradientDrawsAfterEndLocation);
	// Rip the 'canvas' into a UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	// And release memory
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
	// … obvious.
    return image;
}


+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView{
    	    // Create a new view with the same frame size as the superView
    
    SpinnerView* spinnerView;
    
    if(superView.bounds.size.width > superView.bounds.size.height){
            spinnerView = [[SpinnerView alloc] initWithFrame:CGRectMake(superView.bounds.origin.x, superView.bounds.origin.y, 568, superView.bounds.size.width)] ;
    }
    else{
    	    spinnerView = [[SpinnerView alloc] initWithFrame:CGRectMake(superView.bounds.origin.x, superView.bounds.origin.y, superView.bounds.size.width, 568)] ;
    }
    	    // If something's gone wrong, abort!
    	    if(!spinnerView){ return nil; }
    // Create a new image view, from the image made by our gradient method
    UIImageView *background = [[UIImageView alloc] initWithImage:[spinnerView addBackground]];
	// Make a little bit of the superView show through
    background.alpha = 0.7;
    [spinnerView addSubview:background];
    	    // Add the spinner view to the superView. Boom.
    	    [superView addSubview:spinnerView];
    if(!spinnerView){ return nil; }
    
    
   /* UIImageView* logoPic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AnimatedGrintLogo@2x.jpg"]];
    
    logoPic.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    // Place it in the middle of the view
    logoPic.center = superView.center;
    [spinnerView addSubview:logoPic];*/
    
    	    UIActivityIndicatorView *indicator =
    	    [[UIActivityIndicatorView alloc]
    	      initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge] ;
       // Set the resizing mask so it's not stretched
   	    indicator.autoresizingMask =
      UIViewAutoresizingFlexibleTopMargin |
    	    UIViewAutoresizingFlexibleRightMargin |
    	    UIViewAutoresizingFlexibleBottomMargin |
    	    UIViewAutoresizingFlexibleLeftMargin;
    	    // Place it in the middle of the view
    
   /* CGPoint center = superView.center;
    center.y += logoPic.frame.size.height / 2 + 30;
    center.x -= logoPic.frame.size.width / 2;*/
    	  //  indicator.center = center;
    indicator.center = superView.center;
    	    // Add it into the spinnerView
    	    [spinnerView addSubview:indicator];
    	    // Start it spinning! Don't miss this step
    	    [indicator startAnimating];
    
    
/*    UILabel* loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, superView.center.y + logoPic.frame.size.height / 2, superView.frame.size.width, 30)];
    loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    loadingLabel.text = @"loading...";
    
    CGPoint center1 = superView.center;
    center1.y += logoPic.frame.size.height / 2 + 30;
    center1.x += 120;
    loadingLabel.center = center1;
    loadingLabel.textAlignment = NSTextAlignmentLeft;
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    [spinnerView addSubview:loadingLabel];*/

        
    // Create a new animation
    CATransition *animation = [CATransition animation];
	// Set the type to a nice wee fade
	[animation setType:kCATransitionFade];
	// Add it to the superView
	[[superView layer] addAnimation:animation forKey:@"layerAnimation"];
    
    	    return spinnerView;
    	}

-(void)removeSpinner{
    // Add this in at the top of the method. If you place it after you've remove the view from the superView it won't work!
    CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[[self superview] layer] addAnimation:animation forKey:@"layerAnimation"];
   	    [super removeFromSuperview];
	}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
