//
//  ScramblingView.m
//  grint
//
//  Created by Mountain on 8/22/13.
//
//

#import "ScramblingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScramblingView

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
    [_m_label1.layer setCornerRadius: _m_label1.frame.size.height / 2];
    [_m_label2.layer setCornerRadius: _m_label2.frame.size.height / 2];
    [_m_label3.layer setCornerRadius: _m_label3.frame.size.height / 2];
    [_m_label4.layer setCornerRadius: _m_label4.frame.size.height / 2];
    [_m_label5.layer setCornerRadius: _m_label5.frame.size.height / 2];
    [_m_label6.layer setCornerRadius: _m_label6.frame.size.height / 2];
    [_m_labelOuter4.layer setCornerRadius: _m_labelOuter4.frame.size.height / 2];
    [_m_labelOuter5.layer setCornerRadius: _m_labelOuter5.frame.size.height / 2];
    [_m_labelOuter6.layer setCornerRadius: _m_labelOuter6.frame.size.height / 2];
    
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
