//
//  GrintScore.m
//  grint
//
//  Created by Peter Rocker on 21/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintScore.h"

@implementation GrintScore

@synthesize score, putts, penalty, fairway, par, gir, yard, statsHoleParYds, statsAvgScore, statsAvgPutts, statsAvgPenalty, statsTeeAccuracy, statsAvgGir, statsGrints;

- (void)insertNulls{
    
    if(score.length < 1){
        score = nil;
    }
    if(putts.length < 1){
        putts = nil;
    }
    if(penalty.length < 1){
        penalty = nil;
    }
    if(fairway.length < 1){
        fairway = nil;
    }
    if(par.length < 1){
        par = nil;
    }
    if(statsHoleParYds.length < 1)
        statsHoleParYds = nil;
    if(statsAvgScore.length < 1)
        statsAvgScore = nil;
    if(statsAvgPutts.length < 1)
        statsAvgPutts = nil;
    if(statsAvgPenalty.length < 1)
        statsAvgPenalty = nil;
    if(statsTeeAccuracy.length < 1)
        statsTeeAccuracy = nil;
    if(statsAvgGir.length < 1)
        statsAvgGir = nil;
    if(statsGrints.length < 1)
        statsGrints = nil;

    
    
}

- (void) removeNulls{
    
    if(!score){
        score = @"";
    }
    if(!putts){
        putts = @"";
    }
    if(!penalty){
        penalty = @"";
    }
    if(!fairway){
        fairway = @"";
    }
    if(!par){
        par = @"";
    }
    if(!statsHoleParYds)
        statsHoleParYds = @"";
    if(!statsAvgScore)
        statsAvgScore = @"";
    if(!statsAvgPutts)
        statsAvgPutts = @"";
    if(!statsAvgPenalty)
        statsAvgPenalty = @"";
    if(!statsTeeAccuracy)
        statsTeeAccuracy = @"";
    if(!statsAvgGir)
        statsAvgGir = @"";
    if(!statsGrints)
        statsGrints = @"";
    
    
}

- (NSArray*)toArray{
    
    [self removeNulls];
    
    return [[NSArray alloc]initWithObjects:score, putts, penalty, fairway, par, statsHoleParYds, statsAvgScore, statsAvgPutts, statsAvgPenalty, statsTeeAccuracy, statsAvgGir, statsGrints, nil];
    
    
}


+ (GrintScore*)inflateFromArray:(NSArray*) array{
    
    GrintScore* result = [[GrintScore alloc]init];
    result.score = [array objectAtIndex:0];
    result.putts = [array objectAtIndex:1];
    result.penalty = [array objectAtIndex:2];
    result.fairway = [array objectAtIndex:3];
    result.par = [array objectAtIndex:4];
    result.statsHoleParYds = [array objectAtIndex:5];
    result.statsAvgScore = [array objectAtIndex:6];
    result.statsAvgPutts = [array objectAtIndex:7];
    result.statsAvgPenalty = [array objectAtIndex:8];
    result.statsTeeAccuracy = [array objectAtIndex:9];
    result.statsAvgGir = [array objectAtIndex:10];
    result.statsGrints = [array objectAtIndex:11];
    
    [result insertNulls];
    
    return result;
    
}


@end
