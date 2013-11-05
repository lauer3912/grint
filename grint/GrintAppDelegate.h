//
//  GrintAppDelegate.h
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStoreObserver.h"
#import "GrintBReviewStats.h"
#import <FacebookSDK/FacebookSDK.h>

@interface GrintAppDelegate : UIResponder <UIApplicationDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) MyStoreObserver *observer;

@property (nonatomic, assign) GrintBReviewStats* fbDelegate;

- (void)openSession;

@end
