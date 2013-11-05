//
//  Communication.h
//  OpsightLite
//
//  Created by MacBook on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SVC_GETOFFERIST     @"getofferlist.php"
#define SVC_GETREWARDLIST   @"getrewardlist.php"
#define SVC_GETCASHLIST     @"getcashhistory.php"



#define SVC_LOGIN           @"login.php"
#define SVC_REGISTER        @"signup.php"
#define SVC_CLAIM           @"claimreward.php"
#define SVC_UPDATEEMAIL     @"updateemail.php"
#define SVC_CASHOUT         @"cashout.php"
#define SVC_UPDATEPAYPAL    @"updatepaypal.php"
#define SVC_GETACCTINFO     @"getacctinfo.php"

extern const NSString *multipartBoundary;

// communication interface
@interface Communication : NSObject 

// Get Offer List
- (BOOL)getOfferList: (NSString *)userid respData:(NSDictionary **)respData;

// Get Reward List
- (BOOL)getRewardList: (NSString *)userid status:(NSInteger) status respData: (NSDictionary **)respData;

// Get Cash History List
- (BOOL)getCashHistoryList:(NSString *)userid respData: (NSDictionary **)respData;

// Login
- (BOOL)Login: (NSString *)userEmail password: (NSString *)userPass respData: (NSDictionary **)respData;

// Sign up
- (BOOL)Register: (NSString *)email FirstName : (NSString *) firstname LastName : (NSString *) lastname Password : (NSString *) password Paypal : (NSString *) paypal Country : (NSString *) country respData: (NSDictionary **)respData;

// Claim
- (BOOL)ClaimReward: (NSString *)offerID UserID: (NSString*) userID imageData:(NSData *) imageData RespData: (NSDictionary **)respData;

// Cash out
- (BOOL)Cashout:(NSString*) userID RespData: (NSDictionary **)respData;

// Update Email address
- (BOOL)updateEmail:(NSString *)userid Email:(NSString *) email respData: (NSDictionary **)respData;

// Update Paypal address
- (BOOL)updatePaypal:(NSString *)userid Email:(NSString *) email respData: (NSDictionary **)respData;

- (BOOL)getAcctInfos:(NSString *)userid respData: (NSDictionary **)respData;

// internal function
- (BOOL)sendRequest:(NSString *)strService data:(NSString *)data respData:(NSDictionary **)respData;
//get mapped state
- (BOOL) isMapped: (NSString*) strParam;
- (BOOL) isMapped: (NSString*) strParam MAP:(NSMutableDictionary*) dictMap;

//  Upload File
- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic;
+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic;
- (NSData *)makeMultipartBody:(NSDictionary*)dic;
- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata;

- (BOOL) getPurchaseState: (NSString*) strParam;
- (BOOL) setPurchaseState: (NSString*) strParam;
- (BOOL) requestMakeMap: (NSString*) strParam;

- (NSString*) sendRequest:(NSString *)strUrl PARAM:(NSString *)data;

@end
