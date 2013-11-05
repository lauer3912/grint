//
//  IronsView.h
//  grint
//
//  Created by Mountain on 8/21/13.
//
//

#import <UIKit/UIKit.h>

@interface IronsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *m_labelLong;
@property (weak, nonatomic) IBOutlet UILabel *m_labelRight;
@property (weak, nonatomic) IBOutlet UILabel *m_labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *m_labelShort;
@property (weak, nonatomic) IBOutlet UILabel *m_labelMissed;
@property (weak, nonatomic) IBOutlet UILabel *m_labelHit;
@end
