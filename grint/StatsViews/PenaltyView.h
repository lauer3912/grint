//
//  PenaltyView.h
//  grint
//
//  Created by Mountain on 8/22/13.
//
//

#import <UIKit/UIKit.h>

@interface PenaltyView : UIView

@property(nonatomic, retain) NSArray* m_arrayData;
@property (weak, nonatomic) IBOutlet UIView *m_chartView;
@property (weak, nonatomic) IBOutlet UILabel *m_labelCenterCircle;
@property (weak, nonatomic) IBOutlet UILabel *m_labelTop;
@property (weak, nonatomic) IBOutlet UILabel *m_labelBottom;
@end
