//
//  GrintCourseScore.m
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import "GrintCourseScore.h"
#import "GrintScore.h"

@implementation GrintCourseScore

@synthesize courseName, date, scores, totalScore, courseId, shortScore, isShort;

- (void) removeNulls{
    
    for(GrintScore* s in scores){
        
        [s removeNulls];
        
    }
    
}

- (NSString*) getTotalScore{
    
    if(!totalScore){  //cache totalscore so we only have to do all this string parsing once
                
        float f = 0.0;
        
        for (GrintScore* s in scores){
         
            f += [s.score floatValue];
            
        }
        
        totalScore = [NSString stringWithFormat:@"%.0f", f];
        
    }
  
    return totalScore;
    
}

@end