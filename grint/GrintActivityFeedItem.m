//
//  GrintActivityFeedItem.m
//  grint
//
//  Created by Peter Rocker on 06/12/2012.
//
//

#import "GrintActivityFeedItem.h"
#import "GrintActivityFeedViewController.h"

@implementation GrintActivityFeedItem

@synthesize title, subTitle, thumbnailData, thumbnailDownloader, image_loc, thumbnail, delegate, scorecardId, date;

- (void)cancelConnection{
    [thumbnailDownloader cancel];
    delegate = nil;
    
}

- (void)downloadThumbnail{
        
    if (image_loc && [image_loc length] > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:image_loc]];
        self.thumbnailDownloader = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error{
    NSLog(@"%@", error.debugDescription);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.thumbnailData) {
        [self.thumbnailData appendData:data];
    } else {
        self.thumbnailData = [NSMutableData dataWithData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Load raw downloaded data into a UIImage object and release the data
    
    self.thumbnail = [UIImage imageWithData:self.thumbnailData];
    
    self.thumbnailData = nil;
    
    if (delegate ){
        if([delegate respondsToSelector:@selector(reloadTableData)]) {
            [delegate reloadTableData];
        }
    }
}




@end
