//
//  GrintActivityFeedItem.h
//  grint
//
//  Created by Peter Rocker on 06/12/2012.
//
//

#import <Foundation/Foundation.h>

@class GrintActivityFeedViewController;

@interface GrintActivityFeedItem : NSObject


@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subTitle;
@property (nonatomic, retain) NSString* scorecardId;
@property (nonatomic, retain) NSURLConnection *thumbnailDownloader;
@property (nonatomic, retain) NSMutableData *thumbnailData;
@property (nonatomic, retain) NSString* image_loc;
@property (nonatomic, retain) UIImage* thumbnail;
@property (nonatomic, assign) GrintActivityFeedViewController* delegate;
@property (nonatomic, retain) NSString* date;

- (void)downloadThumbnail;

- (void)cancelConnection;

@end
