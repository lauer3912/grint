//
//  DrawView.h
//  grint
//
//  Created by Mountain on 7/9/13.
//
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
{
    CGPoint m_arrayPoints[100];
    int m_nPointCount;
}

- (void) addPoint: (CGPoint) ptFirst;
- (void) clear;
- (void) doDraw;
@end
