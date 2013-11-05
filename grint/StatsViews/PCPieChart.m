/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "PCPieChart.h"

@implementation PCPieComponent

- (id)initWithTitle:(NSString*)title value:(float)value
{
    self = [super init];
    if (self)
    {
        _title = title;
        _value = value;
        _colour = PCColorDefault;
    }
    return self;
}

+ (id)pieComponentWithTitle:(NSString*)title value:(float)value
{
    return [[super alloc] initWithTitle:title value:value];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}

@end

@implementation PCPieChart
{
    NSString* m_strSuffix;
}

- (void) setSuffix : (NSString*) strSuffix
{
    m_strSuffix = strSuffix;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
		
		_titleFont = [UIFont boldSystemFontOfSize:10];
		_percentageFont = [UIFont fontWithName: @"Oswald" size: 12];
		_showArrow = YES;
		_sameColorLabel = NO;
        m_strSuffix = @"";
	}
    return self;
}

#define LABEL_TOP_MARGIN 15
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4

- (void)drawRect:(CGRect)rect
{
    float margin = 15;
    if (self.diameter==0)
    {
        self.diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
    }
    float x = (rect.size.width - self.diameter)/2;
    float y = (rect.size.height - self.diameter)/2;
    float gap = 1;
    float inner_radius = self.diameter/2;
    float origin_x = x + self.diameter/2;
    float origin_y = y + self.diameter/2;
    
    // label stuff
    float left_label_y = LABEL_TOP_MARGIN;
    float right_label_y = LABEL_TOP_MARGIN;
    
    
    if ([self.components count] > 0)
    {
        
        float total = 0;
        for (PCPieComponent *component in self.components)
        {
            total += component.value;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
		CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
		//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
		CGContextFillEllipseInRect(ctx, CGRectMake(x, y, self.diameter, self.diameter));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
		UIGraphicsPopContext();
//		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
		
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i=0; i<[self.components count]; i++)
		{
			PCPieComponent *component  = [self.components objectAtIndex:i];
			float perc = [component value]/total;
			endDeg = nextStartDeg+perc*360;
			
			CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextFillPath(ctx);
			
			CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
			CGContextSetLineWidth(ctx, gap);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextStrokePath(ctx);
			
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
			if (nextStartDeg<180)
			{
				[tmpComponents addObject:component];
			}
			else
			{
				if (last_insert==-1)
				{
					last_insert = i;
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
		
		nextStartDeg = 0;
		endDeg = 0;
		float max_text_width = x -  10;
		for (int i=0; i<[tmpComponents count]; i++)
		{
			PCPieComponent *component  = [tmpComponents objectAtIndex:i];
            if (component.value <= 0)
                continue;
			nextStartDeg = component.startDeg;
			endDeg = component.endDeg;
			
			if (nextStartDeg > 180 ||  (nextStartDeg < 180 && endDeg> 270) )
			{
				// left
				
				// display percentage label
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 3);
				
				//float text_x = x + 10;
                NSString *percentageText;
                if (![m_strSuffix isEqualToString: @""])
                    percentageText = [NSString stringWithFormat:@"%d%@", (int)component.value, m_strSuffix];
                else
                    percentageText = [NSString stringWithFormat:@"%.1f%@", component.value, m_strSuffix];

                
                int x1 = inner_radius/5*5*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x;
                int y1 = inner_radius/5*5*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
                
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
                
				CGRect percFrame;
                if (y1 < self.diameter)
                    percFrame = CGRectMake(x1 - max_text_width, y1 - optimumSize.height, max_text_width, optimumSize.height);
                else
                    percFrame = CGRectMake(x1 - max_text_width, y1, max_text_width, optimumSize.height);
        
                if (self.hasOutline) {
                  CGContextSaveGState(ctx);
                  
                  CGContextSetLineWidth(ctx, 1.0f);
                  CGContextSetLineJoin(ctx, kCGLineJoinRound);
                  CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
                  CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 0.8f);
                  
                  [percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
                  
                  CGContextRestoreGState(ctx);
                } else {
                  [percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
                }
				
				// display title on the left
				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
				left_label_y += optimumSize.height - 4;
				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect titleFrame = CGRectMake(5, left_label_y, max_text_width, optimumSize.height);
				[component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
				left_label_y += optimumSize.height + 10;
			}
			else 
			{
				// right
				
				// display percentage label
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.5);
					//CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 2);
				
				float text_x = x + self.diameter + 10;
				NSString *percentageText;
                if (![m_strSuffix isEqualToString: @""])
                    percentageText = [NSString stringWithFormat:@"%d%@", (int)component.value, m_strSuffix];
                else
                    percentageText = [NSString stringWithFormat:@"%.1f%@", component.value, m_strSuffix];
                
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
                CGRect percFrame;
                int x1 = inner_radius/5*5*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x;
                int y1 = inner_radius/5*5*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;

                if (y1 < (self.frame.origin.y + self.frame.size.height) / 2)
                    percFrame = CGRectMake(x1, y1 - optimumSize.height, max_text_width, optimumSize.height);
                else
                    percFrame = CGRectMake(x1, y1, max_text_width, optimumSize.height);
//				CGRect percFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
        
            if (self.hasOutline) {
              CGContextSaveGState(ctx);
              
              CGContextSetLineWidth(ctx, 1.0f);
              CGContextSetLineJoin(ctx, kCGLineJoinRound);
              CGContextSetTextDrawingMode (ctx, kCGTextFillStroke);
              CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 0.8f);
              
              [percentageText drawInRect:percFrame withFont:self.percentageFont];
              
              CGContextRestoreGState(ctx);
            } else {
              [percentageText drawInRect:percFrame withFont:self.percentageFont];
            }
				
//				if (self.showArrow)
//				{
//					// draw line to point to chart
//					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
//                    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
//					
//					CGContextSetLineWidth(ctx, 1);
//					int x1 = inner_radius/5*4.5*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x;
//					int y1 = inner_radius/5*4.5*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
//					
//					
//					if (right_label_y + optimumSize.height/2 < y)//(right_label_y==LABEL_TOP_MARGIN)
//					{
//						
//						CGContextMoveToPoint(ctx, text_x - 3, right_label_y + optimumSize.height/2);
////						CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//						CGContextAddLineToPoint(ctx, x1, y1);
//						CGContextStrokePath(ctx);
//						
//						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
////						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
////						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
////						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
////						CGContextClosePath(ctx);
////						CGContextFillPath(ctx);
//					}
//					else
//					{
//						float y_diff = y1 - (right_label_y + optimumSize.height/2);
//						if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
//						{
//							// straight arrow
//							y1 = right_label_y + optimumSize.height/2;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx);
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
////							CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
////							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_LENGTH, y1);
////							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
////							CGContextClosePath(ctx);
////							CGContextFillPath(ctx);
//						}
//						else if (right_label_y + optimumSize.height/2<y1)
//						{
//							// arrow point down
//							
//							y1 -= ARROW_HEAD_LENGTH;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
////							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//							//CGContextAddLineToPoint(ctx, x1+5, y1);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx); 
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
////							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
////							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
////							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
////							CGContextClosePath(ctx);
////							CGContextFillPath(ctx);
//						}
//						else //if (nextStartDeg<180 && endDeg>180)
//						{
//							// arrow point up
//							y1 += ARROW_HEAD_LENGTH;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
////							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx);
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
////							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
////							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
////							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
////							CGContextClosePath(ctx);
////							CGContextFillPath(ctx);
//						}
//					}
//				}
				
				// display title on the left
				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
				right_label_y += optimumSize.height - 4;
				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
				CGRect titleFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
				[component.title drawInRect:titleFrame withFont:self.titleFont];
				right_label_y += optimumSize.height + 10;
			}
			nextStartDeg = endDeg;
		}
    }
}

@end
