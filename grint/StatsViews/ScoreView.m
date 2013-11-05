//
//  ScoreView.m
//  grint
//
//  Created by Mountain on 8/21/13.
//
//

#import "ScoreView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScoreView

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
    [_m_label1.layer setCornerRadius: _m_label1.frame.size.height/2];
    [_m_label2.layer setCornerRadius: _m_label2.frame.size.height/2];
    [_m_label3.layer setCornerRadius: _m_label3.frame.size.height/2];
    [_m_label7.layer setCornerRadius: _m_label7.frame.size.height/2];
    [_m_label8.layer setCornerRadius: _m_label8.frame.size.height/2];
    [_m_label9.layer setCornerRadius: _m_label9.frame.size.height/2];
    [_m_labelOuter7.layer setCornerRadius: _m_labelOuter7.frame.size.height/2];
    [_m_labelOuter8.layer setCornerRadius: _m_labelOuter8.frame.size.height/2];
    [_m_labelOuter9.layer setCornerRadius: _m_labelOuter9.frame.size.height/2];
    
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
