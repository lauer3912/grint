//
//  DrawView.m
//  grint
//
//  Created by Mountain on 7/9/13.
//
//

#import "DrawView.h"

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    for (int nIdx = 0; nIdx < m_nPointCount / 2; nIdx ++) {
        CGContextMoveToPoint(context, m_arrayPoints[2 * nIdx].x, m_arrayPoints[2* nIdx].y); //start at this point
        CGContextAddLineToPoint(context, m_arrayPoints[2 * nIdx + 1].x, m_arrayPoints[2 * nIdx + 1].y); //draw to this point
    }
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    for (int nIdx = 0; nIdx < m_nPointCount / 2; nIdx ++) {
        CGContextMoveToPoint(context, m_arrayPoints[2 * nIdx].x, m_arrayPoints[2* nIdx].y); //start at this point
        CGContextAddLineToPoint(context, m_arrayPoints[2 * nIdx + 1].x, m_arrayPoints[2 * nIdx + 1].y); //draw to this point
    }
    CGContextStrokePath(context);
    
}

- (void) addPoint:(CGPoint)ptPoint
{
    m_arrayPoints[m_nPointCount ++] = ptPoint;
}

- (void) doDraw
{
    [self setNeedsDisplay];
}

- (void) clear
{
    m_nPointCount = 0;
}

@end
