//
//  IronsView.m
//  grint
//
//  Created by Mountain on 8/21/13.
//
//

#import "IronsView.h"

#import <QuartzCore/QuartzCore.h>

@implementation IronsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for (int nIdx = 1; nIdx < 11; nIdx ++) {
        UILabel* label = (UILabel*)[self viewWithTag: nIdx];
        [label.layer setCornerRadius: label.frame.size.height / 2];
    }
    
    [self setOswaldFont: self];
}

- (void) setOswaldFont: (UIView*) parent
{
    if (parent.subviews == nil || [parent.subviews count] == 0) {
        if ([parent isKindOfClass: [UILabel class]]) {
            UILabel* label = (UILabel*)parent;
            float rFontSize = [label font].pointSize;
            NSString* strFontName = [label font].familyName;
            if (![strFontName isEqualToString: @"Oswald"])
                [label setFont: [UIFont fontWithName: @"Oswald" size: rFontSize]];
        }
        return;
    }
    for (UIView* view in parent.subviews) {
        [self setOswaldFont: view];
    }
}


@end
