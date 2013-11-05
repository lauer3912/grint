//
//  HandicapView.h
//  grint
//
//  Created by Mountain on 8/21/13.
//
//

#import <UIKit/UIKit.h>

@interface HandicapView : UIView<UIWebViewDelegate>

//outer param
@property float m_rHcpValue;
@property float m_rTrendHcpValue;
@property int m_nHoleType;
@property BOOL m_FGrayHcp;

//inner parma
@property (weak, nonatomic) IBOutlet UILabel *m_labelHcpIndex;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTrendHcp;
@property (weak, nonatomic) IBOutlet UILabel *m_labelOuter;
@property (weak, nonatomic) IBOutlet UILabel *m_labelNotValid;
@property (weak, nonatomic) IBOutlet UIWebView *m_webView;
@property (weak, nonatomic) IBOutlet UILabel *m_labelUnderline;
@property (weak, nonatomic) IBOutlet UIButton *m_btnWHYNH;
@end
