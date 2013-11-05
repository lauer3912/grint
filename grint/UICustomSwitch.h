//
//  UICustomSwitch.h
//
//  Created by Hardy Macia on 10/28/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
//  Code can be freely redistruted and modified as long as the above copyright remains.
//

#import <Foundation/Foundation.h>


@interface UICustomSwitch : UISlider {
	BOOL on;
	UIColor *tintColor;
	UIView *clippingView;
	UILabel *rightLabel;
	UILabel *leftLabel;
	
	// private member
	BOOL m_touchedSelf;
}

@property(nonatomic,getter=isOn) BOOL on;
@property (nonatomic,strong) UIColor *tintColor;
@property (nonatomic,strong) UIView *clippingView;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *leftLabel;

+ (UICustomSwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)scaleSwitch:(CGSize)newSize;

@end
