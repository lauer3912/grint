    //
//  GrintDetailViewController.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintDetailViewController.h"
#import "GrintImageView.h"
#import "GrintCourseDownload.h"
#import "Leaderboard1ViewController.h"
#import <MessageUI/MessageUI.h>
#import "GrintWhatIsThisController.h"
#import "GrintStatsSelectViewController.h"
#import "GrintActivityFeedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintBWriteScoreMultiplayer.h"
#import "GrintBWriteScore.h"
#import "GrintScore.h"
#import "GrintVerticalWebModalViewController.h"
#import "GrintHowSPSWorksViewController.h"

#import "GrintWebModalViewController.h"
#import "GrintVerticalWebModalViewController.h"
#import "AddFriendsController.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBook/ABMultiValue.h>


@implementation GrintDetailViewController
{
    GrintVerticalWebModalViewController* m_webBrowser;
    NSMutableData* data;
    NSString* image_url;
}
@synthesize detailViewController = _detailViewController;
@synthesize detailViewControllerB = _detailViewControllerB;
@synthesize label2, button3;
@synthesize availableProducts, isMember, isGuest, nameString, lastName, handicap, userImage;


-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return nil;
}


- (void)removeSpinnerIfExists{
    if(self.spinnerView1){
        [self.spinnerView1 removeSpinner];
        self.spinnerView1 = nil;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    [self dismissModalViewControllerAnimated:YES];
       
}


- (IBAction)feedbackEmail:(id)sender{
    
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    
    mail.mailComposeDelegate = self;
    
    [mail setToRecipients:[NSArray arrayWithObject:@"info@thegrint.com"]];
    [mail setSubject:@"App Feedback"];
    [mail setMessageBody:@"Here's some feedback for The Grint iPhone and iPad app!\n\n" isHTML:NO];
    
    [self presentModalViewController:mail animated:YES];

    
}

- (void) requestProductData

{
    
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 
                                 [NSSet setWithObjects: @"GrintBlueMonthly", @"GrintBlueYearly", @"GrintGoldMonthly", @"GrintGoldYearly", nil ]];
    
    request.delegate = self;
    
    [request start];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    [self removeSpinnerIfExists];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response

{
    
    NSArray *myProducts = response.products;
    
    availableProducts = nil;
    availableProducts = [[NSArray alloc] initWithArray:myProducts];
    
    NSMutableArray* buttonTitles = [[NSMutableArray alloc]init];
    
    for (SKProduct* product in myProducts){
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        
        [buttonTitles addObject:[NSString stringWithFormat:@"%@ for %@", [product localizedTitle], formattedString]];
        
    }
    
    
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"BLUE membership - up to 6 uploads per month\nGOLD membership - unlimited uploads"
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    for (NSString* otherButtonTitle in buttonTitles)
    {
        [actionSheet addButtonWithTitle:otherButtonTitle];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:[actionSheet numberOfButtons] - 1];
    
    // Show the sheet
    [actionSheet showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    if(buttonIndex < [availableProducts count]){
    
    SKProduct *selectedProduct = [availableProducts objectAtIndex:buttonIndex];
            
            SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
            
            [[SKPaymentQueue defaultQueue] addPayment:payment];        
    }
    else{
        
        [self removeSpinnerIfExists];
    }
}


- (IBAction)tryPurchase:(id)sender{
    
    
    [self removeSpinnerIfExists];
    
    self.spinnerView1 = [SpinnerView loadSpinnerIntoView:self.view];
    
    if ([SKPaymentQueue canMakePayments]) {
        
        [self requestProductData];
        
    } else {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, your device does not appear to support in-app payment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self removeSpinnerIfExists];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10000) {
        if(buttonIndex == 1){
            GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
            [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com/loginapp"]]];
            controller.webView1.scalesPageToFit = YES;
        }
    } else if(alertView.tag == 8008){
        
        if(buttonIndex != alertView.cancelButtonIndex){
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"has_rated_app"];
            if([[alertView buttonTitleAtIndex:buttonIndex]rangeOfString:@"No"].location == NSNotFound){
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=532085262&type=Purple+Software"]];
            }
        }
        else{
            [[NSUserDefaults standardUserDefaults]setInteger:[[NSUserDefaults standardUserDefaults]integerForKey:@"number_times_uploaded"] + 1 forKey:@"number_times_uploaded"];
        }
    }
    
    else if(alertView.tag == 10){
        
        if(buttonIndex > 0){
            
            [self tryPurchase:self];
            
        }
        
    }
    
    else if(alertView.tag == 11){
    
        if(buttonIndex > 0){
            
            
            self.detailViewControllerB = [[GrintBWriteScore alloc] initWithNibName:@"GrintBWriteScore" bundle:nil];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            ((GrintBWriteScore*)self.detailViewControllerB).username = [defaults valueForKey:@"savedState_username"];
            ((GrintBWriteScore*)self.detailViewControllerB).courseName = [defaults valueForKey:@"savedState_courseName"];
            ((GrintBWriteScore*)self.detailViewControllerB).courseAddress = [defaults valueForKey:@"savedState_courseAddress"];
            ((GrintBWriteScore*)self.detailViewControllerB).teeboxColor = [defaults valueForKey:@"savedState_teeboxColor"];
            ((GrintBWriteScore*)self.detailViewControllerB).score = [defaults valueForKey:@"savedState_score"];
            ((GrintBWriteScore*)self.detailViewControllerB).putts = [defaults valueForKey:@"savedState_putts"];
            ((GrintBWriteScore*)self.detailViewControllerB).penalties = [defaults valueForKey:@"savedState_penalties"];
            ((GrintBWriteScore*)self.detailViewControllerB).accuracy = [defaults valueForKey:@"savedState_accuracy"];
            ((GrintBWriteScore*)self.detailViewControllerB).date  = [defaults valueForKey:@"savedState_date"];
            ((GrintBWriteScore*)self.detailViewControllerB).player1 = [defaults valueForKey:@"savedState_player1"];
            ((GrintBWriteScore*)self.detailViewControllerB).player2 = [defaults valueForKey:@"savedState_player2"];
            ((GrintBWriteScore*)self.detailViewControllerB).player3 = [defaults valueForKey:@"savedState_player3"];
            ((GrintBWriteScore*)self.detailViewControllerB).player4 = [defaults valueForKey:@"savedState_player4"];
            
            ((GrintBWriteScore*)self.detailViewControllerB).courseID = [defaults valueForKey:@"savedState_courseID"];
            ((GrintBWriteScore*)self.detailViewControllerB).teeID = [defaults valueForKey:@"savedState_teeID"];
            ((GrintBWriteScore*)self.detailViewControllerB).holeOffset = [defaults valueForKey:@"savedState_holeOffset"];
            ((GrintBWriteScore*)self.detailViewControllerB).pickerData = [defaults valueForKey:@"savedState_pickerData"];
            ((GrintBWriteScore*)self.detailViewControllerB).currentHole = [defaults integerForKey:@"savedState_currentHole"];
            ((GrintBWriteScore*)self.detailViewControllerB).maxHole = [defaults integerForKey:@"savedState_maxHole"];
            ((GrintBWriteScore*)self.detailViewControllerB).numberHoles = [defaults integerForKey:@"savedState_numberHoles"];
            ((GrintBWriteScore*)self.detailViewControllerB).fname = self.nameString;
            ((GrintBWriteScore*)self.detailViewControllerB).lname = self.lastName;
            
            [self.navigationController pushViewController:self.detailViewControllerB animated:YES];
            
            NSArray* savedStateScores = [defaults valueForKey:@"savedState_scores"];
            
            if(savedStateScores.count > 17){
                
                ((GrintBWriteScore*)self.detailViewControllerB).scores = [[NSArray alloc]initWithObjects:
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:0]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:1]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:2]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:3]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:4]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:5]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:6]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:7]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:8]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:9]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:10]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:11]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:12]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:13]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:14]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:15]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:16]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:17]],
                                                                          nil];
            }
            
            ((GrintBWriteScore*)self.detailViewControllerB).currentHole = [defaults integerForKey:@"savedState_currentHole"];
            
            

            
        }
        else{
            
            self.detailViewControllerB = [[Leaderboard1ViewController alloc] initWithNibName:@"Leaderboard1ViewController" bundle:nil];
            
            ((Leaderboard1ViewController*)self.detailViewControllerB).nameString = nameString;
            ((Leaderboard1ViewController*)self.detailViewControllerB).lastName = lastName;
            
            
            [self.navigationController pushViewController:self.detailViewControllerB animated:YES];
            
        }
        
    }
    
    else if (alertView.tag == 12){
        
        if(buttonIndex > 0){
            
            
            self.detailViewControllerB = [[GrintBWriteScoreMultiplayer alloc] initWithNibName:@"GrintBWriteScoreMultiplayer" bundle:nil];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).username = [defaults valueForKey:@"savedState_username"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).courseName = [defaults valueForKey:@"savedState_courseName"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).courseAddress = [defaults valueForKey:@"savedState_courseAddress"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).teeboxColor = [defaults valueForKey:@"savedState_teeboxColor"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).score = [defaults valueForKey:@"savedState_score"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).putts = [defaults valueForKey:@"savedState_putts"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).penalties = [defaults valueForKey:@"savedState_penalties"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).accuracy = [defaults valueForKey:@"savedState_accuracy"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).date  = [defaults valueForKey:@"savedState_date"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).player1 = [defaults valueForKey:@"savedState_player1"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).player2 = [defaults valueForKey:@"savedState_player2"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).player3 = [defaults valueForKey:@"savedState_player3"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).player4 = [defaults valueForKey:@"savedState_player4"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).courseID = [defaults valueForKey:@"savedState_courseID"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).teeID = [defaults valueForKey:@"savedState_teeID"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).holeOffset = [defaults valueForKey:@"savedState_holeOffset"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).pickerData = [defaults valueForKey:@"savedState_pickerData"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).currentHole = [defaults integerForKey:@"savedState_currentHole"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).maxHole = [defaults integerForKey:@"savedState_maxHole"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).numberHoles = [defaults integerForKey:@"savedState_numberHoles"];
            
            NSMutableArray* scoresTemp = [[NSMutableArray alloc]init];
            
            for(int i = 0; i < 4; i++){
            
            NSArray* savedStateScores = [defaults valueForKey:[NSString stringWithFormat:@"savedState_scores%i", i]];
            
            if(savedStateScores.count > 17){
                
                 [scoresTemp addObject:[[NSArray alloc]initWithObjects:
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:0]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:1]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:2]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:3]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:4]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:5]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:6]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:7]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:8]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:9]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:10]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:11]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:12]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:13]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:14]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:15]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:16]],
                                                                          [GrintScore inflateFromArray:[savedStateScores objectAtIndex:17]],
                                                                          nil]];
            }
            }
            
            
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).playerData = [defaults valueForKey:@"savedState_playerData"];
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).currentHole = [defaults integerForKey:@"savedState_currentHole"];
            [self.navigationController pushViewController:self.detailViewControllerB animated:YES];
            
            ((GrintBWriteScoreMultiplayer*)self.detailViewControllerB).scores = [NSArray arrayWithArray:scoresTemp];
            
            
        }
        
        else{
            
            self.detailViewControllerB = [[Leaderboard1ViewController alloc] initWithNibName:@"Leaderboard1ViewController" bundle:nil];
            
            ((Leaderboard1ViewController*)self.detailViewControllerB).nameString = nameString;
            ((Leaderboard1ViewController*)self.detailViewControllerB).lastName = lastName;
            
            [self.navigationController pushViewController:self.detailViewControllerB animated:YES];
            
        }
    }
        else if (alertView.tag == 101){
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue"]){
                [self gotToScorecardShoot];
            }
            else{
                [self tryPurchase:self];
            }
        }
        else if (alertView.tag == 102){
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"No Thanks"]){
                
            }
            else{                
                [self tryPurchase:self];
            }
        }
        else if (alertView.tag == 201){
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Continue"]){
                [self gotToScorecardShoot];
            }
            else{
                
                [self tryPurchase:self];
            }
            
        }
        else if (alertView.tag == 202){
            if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
                
            }
            else{
               
                [self tryPurchase:self];
                                
            }
            
        }
}

-(IBAction)cancelSubscription:(id)sender{
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/upgrade_account_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@&new_type=0&receipt=test0", [[NSUserDefaults standardUserDefaults]valueForKey:@"username"], [[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:nil];
    
    [self logOut:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(self.spinnerView1){
        [_spinnerView1 removeSpinner];
        _spinnerView1 = nil;
    }
    
//    NSString *responseText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    if ([connection.originalRequest.URL.absoluteString rangeOfString:@"get_leaderboard_comments_iphone"].location != NSNotFound){
//        
//        NSArray* rowsXml = [responseText componentsSeparatedByString:@"</comment>"];
//        
//        for(NSString* rowXml in rowsXml){
//            
//            if([self stringBetweenString:@"<user_fname>" andString:@"</user_fname>" forString:rowXml] != nil){
//                
//                image_url = [@"http://www.thegrint.com/user_pic_new/" stringByAppendingString:[self stringBetweenString:@"<image>" andString:@"</image>" forString:rowXml]];
//                break;
//            }
//        }
//    }
}

-(IBAction)launchWebsite:(id)sender{
    
            GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
            [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/loginapp"]]];
            controller.webView1.scalesPageToFit = YES;
        

}

- (void)gotToScorecardShoot{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"sps_dont_show_again"]){
    self.detailViewController = [[GrintCourseDownload alloc] initWithNibName:@"GrintCourseDownload" bundle:nil];    
    ((GrintCourseDownload*)self.detailViewController).username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    }
    else{
    self.detailViewController = [[GrintHowSPSWorksViewController alloc]initWithNibName:@"GrintHowSPSWorksViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

-(IBAction)shootCard:(id)sender{
    
    if(isGuest){
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Only available to registered users" message:@"Please hit 'Logout' then register." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    //else if(isMember){
    
    else{
    
        if(self.memberType == 4){
            
            if(self.expired == 0){

            [self gotToScorecardShoot];
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Time to renew your membership" message:@"Thanks for using our Gold membership service. Please renew your subscription to continue" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Renew", nil];
                alert.tag = 102;
                [alert show];
            }
        }
        else if (self.memberType == 3){
            
            if(self.expired == 0){

            
            if(self.spsCounter > 0){
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"As a Blue Member you have %d uploads left this month", self.spsCounter] message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Get Unlimited", nil];
                alert.tag = 101;
                [alert show];
                
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"As a Blue Member you have used all your monthly uploads." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Unlimited", nil];
                alert.tag = 102;
                [alert show];
                                
            }
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Time to renew your membership" message:@"Thanks for using our Blue membership service. Please renew your subscription to continue" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Renew", nil];
                alert.tag = 102;
                [alert show];
            }
            
        }
        else if (self.memberType == 1){
            if(self.spsCounter > 0){
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"As a Founding Member you have %d uploads left this month", self.spsCounter] message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Get Unlimited", nil];
                alert.tag = 101;
                [alert show];
                
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"As a Founding Member you have used all your monthly uploads." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Unlimited", nil];
                alert.tag = 102;
                [alert show];
                
            }

        }
        else{
            if(self.trialCounter > 0){
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Enjoy your free trial of our Premium SPS. You have %d free uploads left", self.trialCounter] message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Learn More", nil];
                alert.tag = 201;
                [alert show];
                
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Subscribe to our SPS Service (Your free trial is over)" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Learn more", nil];
                alert.tag = 202;
                [alert show];
            }
            
        }
        
        
       }
    
    
    /*else{
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Picture Service" message:@"Our Scorecard Picture Service requires a Standard membership. Would you like to purchase a subscription now?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Purchase Now", nil];
        alert.tag = 10;
        [alert show];
        
    }*/
    
    
}

- (IBAction)whatIsThisClick:(id)sender{
    
    GrintWhatIsThisController* controller = [[GrintWhatIsThisController alloc]initWithNibName:@"GrintWhatIsThisController" bundle:nil];
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];
    
}

- (IBAction)logOut:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(IBAction)viewStats:(id)sender{
    if(isGuest){
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Only available to registered users" message:@"Please hit 'Logout' then register." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    //else if(isMember){
    
    else{

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    GrintStatsSelectViewController* controller = [[GrintStatsSelectViewController alloc]initWithNibName:@"GrintStatsSelectViewController" bundle:nil];
    controller.nameString = nameString;
        controller.lastName = lastName;
    controller.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    }
}


-(IBAction)viewActivity:(id)sender{
    
    if(isGuest){
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Only available to registered users" message:@"Please hit 'Logout' then register." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    
    //else if(isMember){
    
    else{

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    GrintActivityFeedViewController* controller = [[GrintActivityFeedViewController alloc]initWithNibName:@"GrintActivityFeedViewController" bundle:nil];
    controller.nameString = nameString;
    controller.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    [self.navigationController pushViewController:controller animated:YES];
    }
}


-(IBAction)viewCards:(id)sender{
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"savedState"]){
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"savedState_multiplayer"]){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Incomplete score detected" message:[NSString stringWithFormat:@"Session interrupted while inputting score for %@, tee %@. Would you like to continue from your last scorecard?", [defaults valueForKey:@"savedState_courseName"], [defaults valueForKey:@"savedState_teeboxColor"]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 12;
            [alert show];

            
        }
        else{
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Incomplete score detected" message:[NSString stringWithFormat:@"Session interrupted while inputting score for %@, tee %@. Would you like to continue from your last scorecard?", [defaults valueForKey:@"savedState_courseName"], [defaults valueForKey:@"savedState_teeboxColor"]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 11;
                                  [alert show];
        }
        
        
        
    }
    else{
    
        self.detailViewControllerB = [[Leaderboard1ViewController alloc] initWithNibName:@"Leaderboard1ViewController" bundle:nil];
           
        ((Leaderboard1ViewController*)self.detailViewControllerB).nameString = nameString;
        ((Leaderboard1ViewController*)self.detailViewControllerB).lastName = lastName;
        
//        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController: self.detailViewControllerB];
//        
//        CATransition *animation = [CATransition animation];
//        [animation setDuration:0.5];
//        [animation setType:kCATransitionPush];
//        [animation setSubtype:kCATransitionFromRight];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [[nav.view layer] addAnimation:animation forKey:@"SwitchToView"];
//
//        [self presentViewController: nav animated: YES completion: nil];
        
        
        [self.navigationController pushViewController:self.detailViewControllerB animated:YES];
    }
    
    
 /*   NSArray* rows = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] error:nil];
    
    if(!(rows == nil || rows.count < 1)){
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]]){
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"] error:nil];
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp2.jpg"]]){
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp2.jpg"] error:nil];
    }  
    
    GrintImageView * giv = [[GrintImageView alloc] init];
    giv.delegate = self;
    [self presentModalViewController:giv animated:YES];
    
    }
    else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No scorecards found" message:@"Select Scorecard Upload to take a new scorecard picture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    */
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
 //   imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
 //   imagePicker.delegate = (id)self;
 //   imagePicker.allowsImageEditing = NO;
 //   [self presentModalViewController:imagePicker animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_m_labelName setFont:[UIFont fontWithName:@"Oswald-Bold" size:19]];
    [_m_labelTip setFont:[UIFont fontWithName:@"Oswald" size:10]];
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:24]];
    //[label2 setFont:[UIFont fontWithName:@"Merriweather-Bold" size:14]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [button2.layer setCornerRadius:5.0f];
  //  [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button4.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
   // [button5.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut:)];
    [button6.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [button6.layer setCornerRadius:5.0f];
    [button7.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [button7.layer setCornerRadius:5.0f];
    
    
    [_m_scrollview setContentSize: CGSizeMake(250, 500)];
    
    [labelLogo.layer setCornerRadius:labelLogo.bounds.size.width/2];
    
    [labelLogo setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
//    [[self navigationItem] setLeftBarButtonItem:backButton];
    
 //   [button3.layer setCornerRadius:5.0f];
    
    m_webBrowser = [[GrintVerticalWebModalViewController alloc] initWithNibName: @"GrintVerticalWebModalViewController" bundle: nil];
    
    [self initFont: _m_menuView];
    
    UISwipeGestureRecognizer* gesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipeRight:)];
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer: gesture];
    
    UISwipeGestureRecognizer* gesture1 = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(swipeLeft:)];
    gesture1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer: gesture1];

}

- (void) swipeRight:(id) sender
{
    [self actionGoBack: nil];
}

- (void) swipeLeft:(id) sender
{
    if (_m_menuView.frame.origin.x < 300)
        return;
    [self actionShowMenu: nil];
}

- (void) initFont: (UIView*) parent
{
    for (UIView* view in parent.subviews) {
        if ([view isKindOfClass: [UILabel class]]) {
            UILabel* label = (UILabel*) view;
            [label setFont: [UIFont fontWithName: @"Oswald" size: label.font.pointSize]];
            if (label.tag > 0)
                label.text = @"";
        } else if ([view isKindOfClass: [UIButton class]]) {
            UIButton* button = (UIButton*)view;
            [button.titleLabel setFont:[UIFont fontWithName: @"Oswald" size: button.titleLabel.font.pointSize]];
        } else if ([view isKindOfClass: [UIView class]])
            [self initFont: view];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[label1 setText:[@"WELCOME " stringByAppendingString:[nameString uppercaseString]]];
    
    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self removeSpinnerIfExists];
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget: self withObject: nil];
    _m_labelName.text = [NSString stringWithFormat: @"%@ %@", nameString, lastName];
    
}

- (void) loadImage {
    NSData* imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://www.thegrint.com/user_pic_new/%@", self.userImage]]];
    //    NSData* imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://192.168.0.177/grintsite2/user_pic_new/%@", self.userImage]]];
    [_m_imgPhoto setImage: [UIImage imageWithData: imageData]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
    _m_menuView.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  [button3 setTitle:[NSString stringWithFormat:@"not %@? Click here to logout", [[NSUserDefaults standardUserDefaults]valueForKey:@"username"]] forState:UIControlStateNormal];
//    [label1 setText:[@"WELCOME " stringByAppendingString:[nameString uppercaseString]]];
    [labelLogo setText:[NSString stringWithFormat:@"%@", handicap]];
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"has_rated_app"] && [[NSUserDefaults standardUserDefaults]integerForKey:@"number_times_uploaded"] != 0 && ([[NSUserDefaults standardUserDefaults]integerForKey:@"number_times_uploaded"] % 4 == 0)){
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Rate TheGrint!" message:@"Enjoyed using our app so far? Please help us out by rating us on the appstore!" delegate:self cancelButtonTitle:@"Remind me later" otherButtonTitles:@"Sure!", @"No thanks", nil];
        alert.tag=8008;
        [alert show];
    }
    _m_menuView.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Welcome", @"Welcome");
    }
    return self;
}
							
- (IBAction)actionEditProfile:(id)sender {
    self.navigationController.navigationBar.hidden = YES;
    [self showWebPage: @"http://www.thegrint.com/profile_edit"];
}

- (IBAction)actionShowMenu:(id)sender {
    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.3];
    
    [_m_menuView setFrame: CGRectMake(320 - _m_menuView.frame.size.width, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
    
    [UIView commitAnimations];
}

- (IBAction)actionGoBack:(id)sender {
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.3];
    
    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
    
    [UIView commitAnimations];
}

- (IBAction)actionPlayGolf:(id)sender {
//    [self actionGoBack: nil];
    [self viewCards: nil];
//    _m_menuView.hidden = NO;
//    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
}

- (IBAction)actionScorePicture:(id)sender {
//    [self actionGoBack: nil];
    [self shootCard: nil];
//    _m_menuView.hidden = NO;
//    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
}

- (IBAction)actionHandicapStats:(id)sender {
//    [self actionGoBack: nil];
    [self viewStats: nil];
//    _m_menuView.hidden = NO;
//    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
}

- (IBAction)actionActivityFeed:(id)sender {
//    [self actionGoBack: nil];
    [self viewActivity: nil];
//    _m_menuView.hidden = NO;
//    [_m_menuView setFrame: CGRectMake(320, 0, _m_menuView.frame.size.width, _m_menuView.frame.size.height)];
}

- (IBAction)actionEditScore:(id)sender {
    [self showWebPage: @"http://www.thegrint.com/score"];
}

- (void) showWebPage: (NSString*) strUrl
{
    GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
    controller.delegate = self;
    [self presentViewController: controller animated: YES completion:nil];
    [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    controller.webView1.scalesPageToFit = YES;
}

- (IBAction)actionMyUSGA:(id)sender {
    [self showWebPage: @"http://www.thegrint.com/clubs/my_club"];
}

- (IBAction)actionInviteFriends:(id)sender {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                NSLog(@"Access granted!");
                [self inviteFriends: addressBookRef];
            } else {
                NSLog(@"Access denied!");
            }
        });
    } else {
        [self inviteFriends: addressBookRef];
    }
    
}

- (void) inviteFriends: (ABAddressBookRef) addressBookRef
{
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBookRef);
    
    NSMutableArray* arrayContacts = [[NSMutableArray alloc] init];
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"Name:%@ %@", firstName, lstName);
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            [arrayContacts addObject: phoneNumber];
            if (arrayContacts.count > 20)
                break;

            NSLog(@"phone:%@", phoneNumber);
        }
    }
    
    if ([arrayContacts count] > 0) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"Hey! Check out TheGrint Golf App. I use it to get GPS and a USGA Compliant Handicap. Join so we can befriend each other. iOS download: https://itunes.apple.com/gb/app/thegrint-golf-handicap-tracker/id532085262?mt=8";
            //            controller.body = @"Hey! Check out TheGrint Golf App(http://www.thegrint.com). I use it to get GPS and a USGA Compliant Handicap. Join so we can befriend each other.";
            
            controller.recipients = arrayContacts;
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
//            NSMutableString* strNums = [[NSMutableString alloc] init];
//            [strNums appendString: [arrayContacts objectAtIndex: 0]];
//            for (int nIdx = 1; nIdx < [arrayContacts count]; nIdx ++) {
//                [strNums appendFormat: @",%@", [arrayContacts objectAtIndex: nIdx]];
//            }
//            
//            NSString* strUrl = [NSString stringWithFormat:@"sms:%@", strNums];
//            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: strUrl]];
        }
    }
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"" message:@"Friend Request Sent!" delegate: nil cancelButtonTitle:@"Continue" otherButtonTitles: nil];
            [alertView show];
            
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionAboutUs:(id)sender {
    [self showWebPage: @"http://www.thegrint.com/about_us"];
}

- (IBAction)actionAddFriends:(id)sender {
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Feature Coming Soon" message:@"If you want to add friends now you can do so at our website www.TheGrint.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Go to site", nil];
//    alertView.tag = 10000;
//    [alertView show];

    AddFriendsController* friendController = [[AddFriendsController alloc] initWithNibName: @"AddFriendsController" bundle: nil];
    friendController.m_strUserName = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    friendController.m_nType = 0;
    [self.navigationController pushViewController: friendController animated: YES];
}

- (IBAction)actionTerms:(id)sender {
    [self showWebPage: @"http://www.thegrint.com/terms"];
}
@end
