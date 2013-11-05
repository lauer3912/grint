//
//  GrintAppDelegate.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintAppDelegate.h"

#import "GrintMasterViewController.h"
#import <StoreKit/StoreKit.h>
#import "Flurry.h"
#import "UAirship.h"
#import "UAPush.h"
#import <GoogleMaps/GoogleMaps.h>

#import "RageIAPHelper.h"

//#define APIKey @"AIzaSyAvS33ssYhcIp0zekBxBbWrHn-B0eg5a9I"
#define APIKey @"AIzaSyATyf_fQDqizr_GwcsvHJ50o6SVHl_zmjM"
@implementation GrintAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize observer;
@synthesize fbDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [Flurry startSession:@"GHNVQKWFWQ42KX3M6DW5"];
    
    //google map setting
//    if ([APIKey length] == 0) {
//        // Blow up if APIKey has not yet been set.
//        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
//        NSString *reason =
//        [NSString stringWithFormat:@"Configure APIKey inside APIKey.h for your "
//         @"bundle `%@`, see README.GoogleMapsSDKDemos for more information",
//         bundleId];
//        //    @throw [NSException exceptionWithName:@"SDKDemosAppDelegate"
//        //                                   reason:reason
//        //                                 userInfo:nil];
//    }
    [GMSServices provideAPIKey: APIKey];
    
    NSLog(@"Open-source licenses info:\n%@\n",
          [GMSServices openSourceLicenseInfo]);
    /////////////////
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];
    
    [[UAPush shared]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:
      @"",
      @"username",
      @"",
      @"password",
      @"",
      @"history1",
      @"",
      @"history2",
      @"",
      @"history3",
      @"",
      @"history4",
      @"",
      @"history5",
      @"",
      @"history6",
      @"",
      @"history7",
      @"",
      @"history8",      
      [NSNumber numberWithInt:0],
      @"state",
      nil]];
    
//    self.window.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:162.0/255.0 blue:192.0/255.0 alpha:1];
    
    self.window.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:81.0/255.0 blue:96.0/255.0 alpha:0.8];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"Oswald" size:18.0], UITextAttributeFont,
                                                           [NSValue valueWithUIOffset:UIOffsetZero], UITextAttributeTextShadowOffset,
                                                            nil]];
    
    GrintMasterViewController *masterViewController;
    if ([UIScreen mainScreen].bounds.size.height > 500) {
        masterViewController = [[GrintMasterViewController alloc] initWithNibName:@"GrintMasterViewController5" bundle:nil];
    } else {
        masterViewController = [[GrintMasterViewController alloc] initWithNibName:@"GrintMasterViewController" bundle:nil];
    }
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    observer = [[MyStoreObserver alloc] init];
    observer.appdelegate = self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            [RageIAPHelper sharedInstance]._products = [[NSArray alloc] initWithArray:products];
        }
    }];
    
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    topView.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:162.0/255.0 blue:192.0/255.0 alpha:1];
    [self.window addSubview: topView];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
 [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UAirship land];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
           
            [fbDelegate facebookScore:self];
            
            }
       
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
           // [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
           // [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end
