//
//  GrintVerticalWebModalViewController.h
//  grint
//
//  Created by Peter Rocker on 23/04/2013.
//
//

#import <UIKit/UIKit.h>

@interface GrintVerticalWebModalViewController : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView* _webView1;
    
}

@property (nonatomic, assign) UIViewController* delegate;
@property (nonatomic, assign) UIWebView* webView1;
@property(nonatomic, retain) NSString* m_strURL;
@property BOOL m_FFirst;


@end
