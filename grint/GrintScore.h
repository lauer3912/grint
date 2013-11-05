//
//  GrintScore.h
//  grint
//
//  Created by Peter Rocker on 21/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrintScore : NSObject


@property (nonatomic, retain) NSString* score;
@property (nonatomic, retain) NSString* putts;
@property (nonatomic, retain) NSString* penalty;
@property (nonatomic, retain) NSString* fairway;
@property (nonatomic, retain) NSString* par;
@property (nonatomic, retain) NSString* gir;
@property (nonatomic, retain) NSString* yard;
@property (nonatomic, retain) NSString* statsHoleParYds;
@property (nonatomic, retain) NSString* statsAvgScore;
@property (nonatomic, retain) NSString* statsAvgPutts;
@property (nonatomic, retain) NSString* statsAvgPenalty;
@property (nonatomic, retain) NSString* statsTeeAccuracy;
@property (nonatomic, retain) NSString* statsAvgGir;
@property (nonatomic, retain) NSString* statsGrints;

- (NSArray*)toArray;

-(void)removeNulls;

+ (GrintScore*)inflateFromArray:(NSArray*) array;

@end
