//
//  MyStoreObserver.m
//  grint
//
//  Created by Peter Rocker on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyStoreObserver.h"
#import "GrintDetailViewController.h"

@implementation MyStoreObserver

@synthesize data, appdelegate, connection;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                      otherButtonTitles:nil] show];
}

//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
//    
//    NSLog(responseText);
//    
//    [[appdelegate navigationController] popToRootViewControllerAnimated:YES];
//    
//    
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Purchase successful!" message:@"Enjoy our Scorecard Picture Service!" delegate:appdelegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//    

    
//}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions

{
       
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];   
            default:
                break;
                
        }
        
    }
    
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    
    // Your application should implement these two methods.
    
    //[self recordTransaction:transaction];
    //[self provideContent:transaction.payment.productIdentifier];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/upgrade_account_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@&new_type=%@&receipt=%@&purchase_period=%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"username"], [[NSUserDefaults standardUserDefaults]valueForKey:@"password"], [transaction.payment.productIdentifier rangeOfString:@"Gold"].location != NSNotFound ? @"4" : @"3", [transaction transactionIdentifier], [transaction.payment.productIdentifier rangeOfString:@"Monthly"].location != NSNotFound ? @"M" : @"Y"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];
        
    }


    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    [((GrintDetailViewController*)[[appdelegate navigationController].childViewControllers objectAtIndex:1]) removeSpinnerIfExists];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction

{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        // Optionally, display an error here.
    }
    [((GrintDetailViewController*)[[appdelegate navigationController].childViewControllers objectAtIndex:1]) removeSpinnerIfExists];

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
