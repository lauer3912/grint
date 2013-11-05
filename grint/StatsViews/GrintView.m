//
//  GrintView.m
//  grint
//
//  Created by Mountain on 8/22/13.
//
//

#import "GrintView.h"
#import "PCPieChart.h"
#import <QuartzCore/QuartzCore.h>

@implementation GrintView

@synthesize m_arrayData;

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
    // Drawing code: 4,5,6: par3's, par4's, par5's
    for (int nIdx = 1; nIdx < 7; nIdx ++) {
        UILabel* label = (UILabel*)[self viewWithTag: nIdx];
        [label.layer setCornerRadius: label.frame.size.height / 2];
    }
    [_m_labelCenterCircle.layer setCornerRadius: _m_labelCenterCircle.frame.size.height / 2];
    
    [self drawChat];
    
    [self bringSubviewToFront: _m_labelCenterCircle];
    [self bringSubviewToFront: _m_labelTop];
    [self bringSubviewToFront: _m_labelBottom];
    
    for (int nIdx = 0; nIdx < 3; nIdx ++) {
        ((UILabel*)[self viewWithTag: nIdx + 4]).text = [NSString stringWithFormat: @"%d%%", [[m_arrayData objectAtIndex: nIdx + 7] integerValue]];
    }
    
    _m_labelCenterCircle.text = [NSString stringWithFormat: @"%d%%", [[m_arrayData objectAtIndex: 0] intValue]];
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

- (void) drawChat
{
    for (UIView* view in self.m_chartView.subviews) {
        [view removeFromSuperview];
    }
    int height = [_m_chartView bounds].size.height;
    int width = [_m_chartView bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([_m_chartView bounds].size.width-width)/2,([_m_chartView bounds].size.height-height)/2+5,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:height - 30];
    [pieChart setSameColorLabel: NO];
    [pieChart setSuffix: @"%"];
    
    [_m_chartView addSubview:pieChart];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
        pieChart.percentageFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50];
    }
    
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 1; i < 7; i++)
    {
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:@"" value:[[m_arrayData objectAtIndex:i] floatValue]];
        [components addObject:component];
        
        [component setColour:[self viewWithTag: 10 + i].backgroundColor];
    }
    [pieChart setComponents:components];
    
    [self sendSubviewToBack: pieChart];
}


@end
