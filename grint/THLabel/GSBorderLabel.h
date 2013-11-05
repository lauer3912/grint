//
//  GSBorderLabel.h
//  GSBorderLabelDemo
//
//  Created by Giacomo Saccardo on 16/12/12.
//  Copyright (c) 2012 Giacomo Saccardo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSBorderLabel : UILabel

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) int borderWidth;

-(id) initWithTextColor:(UIColor *)textColor andBorderColor:(UIColor *)borderColor andBorderWidth:(int)borderWidth;

@end
