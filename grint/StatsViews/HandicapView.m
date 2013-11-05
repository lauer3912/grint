//
//  HandicapView.m
//  grint
//
//  Created by Mountain on 8/21/13.
//
//

#import "HandicapView.h"

#import <QuartzCore/QuartzCore.h>

@implementation HandicapView

@synthesize m_rHcpValue, m_rTrendHcpValue, m_nHoleType, m_FGrayHcp;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    float rFontSize = [self.m_btnWHYNH.titleLabel font].pointSize;
    [self.m_btnWHYNH.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: rFontSize]];

    [self.m_labelHcpIndex.layer setCornerRadius: self.m_labelHcpIndex.frame.size.height / 2];
    
    [self.m_labelOuter.layer setCornerRadius: self.m_labelOuter.frame.size.height / 2];
    [self.m_labelTrendHcp.layer setCornerRadius: self.m_labelTrendHcp.frame.size.height / 2];
    
    if (!m_FGrayHcp) {
        [self.m_labelHcpIndex setBackgroundColor: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
        self.m_labelNotValid.hidden = NO;
        self.m_btnWHYNH.hidden = NO;
        self.m_labelUnderline.hidden = NO;
    } else {
        [self.m_labelHcpIndex setBackgroundColor: self.m_labelOuter.backgroundColor];
        self.m_labelNotValid.hidden = YES;
        self.m_btnWHYNH.hidden = YES;
        self.m_labelUnderline.hidden = YES;
    }
    
    if (m_nHoleType == 0) {
        [self.m_labelHcpIndex setText: [NSString stringWithFormat: @"%.1f", m_rHcpValue]];
    } else {
        [self.m_labelHcpIndex setText: [NSString stringWithFormat: @"%.1f N", m_rHcpValue]];
    }
    [self.m_labelTrendHcp setText: [NSString stringWithFormat: @"%.1f", m_rTrendHcpValue]];
    
    [self setOswaldFont: self];
    
    [self initWebView];
}

- (void) initWebView
{
    NSString* strHtml = @"<html><head><style>p{margin-top:-6px;font-family:Calibri; font-size:11px;color:#666666;} a{color:#1e5160;font-weight:bold;}</style></head><body><p> TheGrint Handicaps are USGA compliant. <a href='TheGrint.com'>Visit TheGrint.com</a> <br /> and login to learn more and print your Handicap Card.</p> <p> By USGA guidelines handicaps are revised (calculated)  on the<BR/> 1st and  15th of every month. A minimum of 5 rounds of the <BR/> same type are required. </p> <p>Trending Handicap shows what your handicap would be if the<BR /> revision was Today. </p> <p>Full and 9 Hole Handicaps (N) are shown separately.</p></body></html>";
    [self.m_webView loadHTMLString: strHtml baseURL: nil];
    [self.m_webView setDelegate: self];
    
    self.m_webView.scrollView.scrollEnabled = NO;
    self.m_webView.scrollView.bounces = NO;
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"http://www.thegrint.com"]];
        return NO;
    }
    return YES;
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
