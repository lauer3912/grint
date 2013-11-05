//
//  Communication.m
//  OpsightLite
//
//  Created by MacBook on 10/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Communication.h"
#import "JSON.h"

const NSString *multipartBoundary = @"-------------111";

/**
 Implementation for Communication class
 **/
@implementation Communication

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)getOfferList:(NSString *)userid  respData:(NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"userid=%@",userid] autorelease];

    return [self sendRequest:SVC_GETOFFERIST data:strRequestParams respData:respData];
}
 
- (BOOL)getRewardList:(NSString *)userid status:(NSInteger) status respData: (NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@&status=%d", userid, status] autorelease];
    
    return [self sendRequest:SVC_GETREWARDLIST data:strRequestParams respData:respData];
}

- (BOOL)getCashHistoryList:(NSString *)userid respData: (NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@", userid] autorelease];
    
    return [self sendRequest:SVC_GETCASHLIST data:strRequestParams respData:respData];
}

/**
 ** Login
 */
- (BOOL)Login: (NSString *)userEmail password: (NSString *)userPass respData: (NSDictionary **)respData {
    
    NSMutableDictionary *dictParam = [[[NSMutableDictionary alloc] init] autorelease];
    [dictParam setValue:userEmail forKey:@"email"];
    [dictParam setValue:userPass forKey:@"password"];
    
    NSMutableDictionary* dictReq = [[[NSMutableDictionary alloc] init] autorelease];
    [dictReq setValue:@"signin" forKey:@"request_name"];
    [dictReq setValue:dictParam forKey:@"parameters"];
    
    SBJSON* jsonParam = [[[SBJSON alloc] init] autorelease];
    
    
    NSString *strRequestParams = [NSString stringWithFormat:@"param=%@", [jsonParam stringWithObject:dictReq]];//[[[NSMutableString alloc] initWithFormat:@"userEmail=%@&userPass=%@", userEmail, userPass] autorelease];

    return [self sendRequest:@"" data:strRequestParams respData:respData];
}

/**
 ** Register
 */
- (BOOL)Register: (NSString *)email FirstName : (NSString *) firstname LastName : (NSString *) lastname Password : (NSString *) password Paypal : (NSString *) paypal Country : (NSString *) country respData: (NSDictionary **)respData
{
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"email=%@&password=%@&firstname=%@&lastname=%@&paypal=%@&country=%@", email, password, firstname, lastname, paypal, country] autorelease];
    
    return [self sendRequest:SVC_REGISTER data:strRequestParams respData:respData];
}

/**
 ** Claim
 */
- (BOOL)ClaimReward: (NSString *)offerID UserID: (NSString*) userID imageData:(NSData *) imageData RespData: (NSDictionary **)respData {
    
    NSMutableData *body;
    
    NSArray *paramNames = [NSArray arrayWithObjects:@"offerid", @"userid", nil];
    NSArray *paramDatas = [NSArray arrayWithObjects:offerID, userID, nil];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:paramDatas forKeys:paramNames];
    
    body = [NSMutableData dataWithData: [self makeMultipartBody:dict]];
    
    [self appendFileToBody:body filenamekey:@"mobilereward" filenamevalue:[NSString stringWithFormat:@"%@_%@", userID, offerID] filedata: imageData];
    
   // NSLog(@"body : %@", body);
    
    return [self sendMultipartRequest:SVC_CLAIM data:body respData:respData];
}

/**
 ** Cashout
 */
- (BOOL)Cashout:(NSString*) userID RespData: (NSDictionary **)respData {
    
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@", userID] autorelease];
    
    return [self sendRequest:SVC_CASHOUT data:strRequestParams respData:respData];
}


- (BOOL)updateEmail:(NSString *)userid Email:(NSString *) email respData: (NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@&email=%@", userid, email] autorelease];
    
    return [self sendRequest:SVC_UPDATEEMAIL data:strRequestParams respData:respData];
}

- (BOOL)updatePaypal:(NSString *)userid Email:(NSString *) email respData: (NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@&email=%@", userid, email] autorelease];
    
    return [self sendRequest:SVC_UPDATEPAYPAL data:strRequestParams respData:respData];
}

- (BOOL)getAcctInfos:(NSString *)userid respData: (NSDictionary **)respData {
    NSMutableString *strRequestParams = [[[NSMutableString alloc] initWithFormat:@"&userid=%@", userid] autorelease];
    
    return [self sendRequest:SVC_GETACCTINFO data:strRequestParams respData:respData];
}


// parameter - respData is reatined in this function

#define SERVER_URL @"http://thegrint.com/course_mapper_iphone/"
- (BOOL)sendRequest:(NSString *)strService data:(NSString *)data respData:(NSDictionary **)respData;
{
    // Generate server URL
    NSMutableString *strURL = [NSMutableString stringWithString: SERVER_URL];
    
    [strURL appendString: data];
    
    NSLog(@"URL: %@", strURL);
    NSLog(@"PARAMS: %@", data);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format

    [dic retain];
    *respData = dic;
    return YES;
}

- (NSString*) sendRequest:(NSString *)strURL PARAM:(NSString *)data
{
    NSLog(@"URL: %@", strURL);
    NSLog(@"PARAMS: %@", data);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString* strResult = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"RECEIVED DATA : %@", strResult);
    
    return strResult;
}


- (BOOL) isMapped: (NSString*) strParam MAP:(NSMutableDictionary*) dictMap
{
    // Generate server URL
    NSMutableString *strURL = [NSMutableString stringWithString: SERVER_URL];
    
    [strURL appendString: strParam];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);

    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil || [dic objectForKey:@"error"])
        return NO;

    for (NSString* key in [dic allKeys]) {
        [dictMap setObject: [[dic objectForKey: key] copy] forKey: key];
    }

    if ([dictMap objectForKey: @"Green Center"])
        return YES;
    return NO;
}

- (BOOL) requestMakeMap: (NSString*) strParam
{
    // Generate server URL
    NSMutableString *strURL = [NSMutableString stringWithString: SERVER_URL];
    
    [strURL appendString: strParam];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    return YES;
}


- (BOOL) getPurchaseState: (NSString*) strParam
{
    // Generate server URL
    NSMutableString *strURL = [NSMutableString stringWithString: SERVER_URL];
    
    [strURL appendString: strParam];
    NSLog(@"REQUEST PARAM : %@", strURL);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);

    return [respString isEqualToString: @"SUCCESS"];
}

- (BOOL) setPurchaseState: (NSString*) strParam
{
    // Generate server URL
    NSMutableString *strURL = [NSMutableString stringWithString: SERVER_URL];
    
    [strURL appendString: strParam];
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    return [respString isEqualToString: @"SUCCESS"];
}


//- (BOOL)sendRequest:(NSString *)strService jsonData:(NSString *)data respData:(NSDictionary **)respData;
//{
//    // Generate server URL
//    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
//    NSMutableString *strURL = [NSMutableString stringWithString:dataKeeper.serverAddress];
//    
//    //    [strURL appendString:strService];
//    
//    NSLog(@"URL: %@", strURL);
//    // NSLog(@"PARAMS: %@", data);
//    
//    NSURL *url = [NSURL URLWithString:strURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSError *error;
//    NSURLResponse *response;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (!response) {
//        // "Connection Error", "Failed to Connect to the Internet"
//        NSLog(@"%@", [error description]);
//        return NO;
//    }
//    
//    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"RECEIVED DATA : %@", respString);
//    
//    
//    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
//    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
//    if (dic == nil)
//        return NO;  // invalid JSON format
//    
//    [dic retain];
//    *respData = dic;
//    return YES;
//}


///////////////////////////////////////////////
///////// File Upload
///////////////////////////////////////////////


//- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic
//{
//    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
//    NSMutableString *strURL = [NSMutableString stringWithString:dataKeeper.serverAddress];
//    
//    [strURL appendString:strService];
//    
//    NSLog(@"URL: %@", strURL);
//    NSLog(@"PARAMS: %@", data);
//    
//    NSURL *url = [NSURL URLWithString:strURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
//	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:data];
//    
//    NSError *error;
//    NSURLResponse *response;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (!response) {
//        // "Connection Error", "Failed to Connect to the URL"
//        NSLog(@"%@", [error description]);
//        return NO;
//    }
//    
//    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"RECEIVED DATA : %@", respString);
//    
//    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
//    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
//    if (dic == nil) 
//        return NO;  // invalid JSON format
//    
//    [dic retain];
//    *respDic = dic;
//    return YES;
//}

+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic {
    
    NSLog(@"URL: %@", strURL);
    NSLog(@"FileName: %@", filename);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orderfile\"; filename=\"%@\"\r\n", filename]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-type: application/octet-stream\r\n\r\n"] dataUsingEncoding: NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@", fileData]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody: body];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the URL"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format
    
    [dic retain];
    *respDic = dic;
    return YES;
}


- (NSData *)makeMultipartBody:(NSDictionary*)dic {
	
	NSMutableData *data = [NSMutableData data];
	
    for (NSString *key in dic) {
        NSString *value = [dic objectForKey:key];
        // set boundary
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"%@", logString);
    [logString release];
    
    return data;
}

- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata {
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", filenamekey, filenamevalue]] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:@"Content-type: application/octet-stream\r\n\r\n"] dataUsingEncoding: NSUTF8StringEncoding]];
	[data appendData:filedata];
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
}


@end

