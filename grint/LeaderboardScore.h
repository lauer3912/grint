//
//  LeaderboardScore.h
//  grint
//
//  Created by Peter Rocker on 14/05/2013.
//
//

#import <Foundation/Foundation.h>

@interface LeaderboardScore : NSObject

@property (nonatomic, retain)  NSString* player;
@property int over;
@property int gross;
@property int net;
@property int thru;


@end
