//
//  MyStoreObserver.h
//  grint
//
//  Created by Peter Rocker on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface MyStoreObserver : NSObject<SKPaymentTransactionObserver>

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@property (nonatomic, retain) id appdelegate;

@property (nonatomic, retain) NSMutableData* data;

@property (nonatomic, retain) NSURLConnection * connection;
@end
