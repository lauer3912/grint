//
//  GrintWebModalViewController.h
//  grint
//
//  Created by Peter Rocker on 17/01/2013.
//
//

#import <UIKit/UIKit.h>

@interface GrintWebModalViewController : UIViewController<UIWebViewDelegate> {
    
    IBOutlet UIWebView* _webView1;
    BOOL m_FFirst;
}

@property (nonatomic, assign) UIViewController* delegate;
@property (nonatomic, assign) UIWebView* webView1;
@property(nonatomic, retain) NSString* m_strURL;
@property BOOL m_FFirst;

@end
