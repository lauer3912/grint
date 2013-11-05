//
//  GrintCourseScore.h
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import <Foundation/Foundation.h>

@interface GrintCourseScore : NSObject

@property (nonatomic, retain) NSString* courseName;
@property (nonatomic, retain) NSString* courseId;
@property (nonatomic, retain) NSString* date;
@property (nonatomic, retain) NSString* totalScore;
@property (nonatomic, retain) NSMutableArray* scores;
@property (nonatomic, retain) NSString* isShort;
@property (nonatomic, retain) NSString* shortScore;


- (void)removeNulls;
- (NSString*)getTotalScore;

@end
