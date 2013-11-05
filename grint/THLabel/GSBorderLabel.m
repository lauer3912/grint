//
//  GSBorderLabel.m
//  GSBorderLabelDemo
//
//  Created by Giacomo Saccardo on 16/12/12.
//  Copyright (c) 2012 Giacomo Saccardo. All rights reserved.
//

#import "GSBorderLabel.h"

#define BORDERWIDTH 3
#define BORDERCOLOR [UIColor blackColor]

@implementation GSBorderLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(id) initWithTextColor:(UIColor *)textColor andBorderColor:(UIColor *)borderColor andBorderWidth:(int)borderWidth {
    
    self = [super init];
    if (self) {
        
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        self.textColor = textColor;
        
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    
    UIColor *borderColor;
    if (self.borderColor) {
        borderColor = self.borderColor;
    }
    else {
        borderColor = BORDERCOLOR;
    }
    
    UIColor *textColor = self.textColor;
    
    int border;
    if (self.borderWidth) {
        border = self.borderWidth;
    }
    else {
        border = BORDERWIDTH;
    }
    
    
    CGSize shadowOffset = self.shadowOffset;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, border);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end
