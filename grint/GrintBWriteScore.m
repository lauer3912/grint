//
//  GrintBWriteScore.m
//  grint
//
//  Created by Peter Rocker on 15/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintBWriteScore.h"
//#import "GrintBReviewScore.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintScore.h"
#import "Flurry.h"

#import "Communication.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "ShowHoleMapController.h"

#import "KxMenu.h"
#import "UIXOverlayController.h"
#import "GPSUseGuideController.h"


@implementation GrintBWriteScore
@synthesize detailViewController = _detailViewController;

@synthesize holeID;
@synthesize m_strHoleYards;

@synthesize username, fname, lname;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize score;
@synthesize putts;
@synthesize penalties;
@synthesize accuracy;
@synthesize date;
@synthesize courseID;
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize teeID;
@synthesize spinnerView;
@synthesize data;
@synthesize holeOffset;
@synthesize connection;

@synthesize pickerData, scores, currentHole, maxHole, numberHoles;

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


/**
 ***** NB: currentHole is 0-based! (0 - 17)
 **/


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/holedata_iphone_new"]){
        
        NSLog(responseText);
                
       // if([[self stringBetweenString:@"<hole>" andString:@"</hole>" forString:responseText] intValue] == currentHole +1){
        
        for(int i = 1; i < 19; i++){
        
            NSString* tempString = [self stringBetweenString:[NSString stringWithFormat:@"<hole%d>", i] andString:[NSString stringWithFormat:@"</hole%d>", i] forString:responseText];
            
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).par = [self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString];
            
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsHoleParYds = [NSString stringWithFormat:@"Par %d / %d yards", [[self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString] intValue],[[self stringBetweenString:@"<yards>" andString:@"</yards>" forString:tempString] intValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgScore = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore>" andString:@"</avgscore>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgPutts = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts>" andString:@"</avgputts>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgPenalty = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty>" andString:@"</avgpenalty>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsTeeAccuracy = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<teeaccuracy>" andString:@"</teeaccuracy>" forString:tempString] intValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsAvgGir = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avggir>" andString:@"</avggir>" forString:tempString] floatValue]];
            ((GrintScore*)[self.scores objectAtIndex:i - 1]).statsGrints = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<grints>" andString:@"</grints>" forString:tempString] intValue]];
            
            //THIS IS UI UPDATING STUFF
            /*
            if([labelScore.text isEqualToString:@""]){
            [picker1 selectRow:[[self stringBetweenString:@"<par>" andString:@"</par>" forString:responseText] intValue] - 1 inComponent:0 animated:NO];
            }
            
            if([[self stringBetweenString:@"<par>" andString:@"</par>" forString:responseText] intValue] == 3){
                [labelTeeAccuracy setHidden:YES]; //TODO: disable fairway
                [labelFairway setHidden:YES];
            }
            else {
                [labelTeeAccuracy setHidden: NO]; 
                if([accuracy isEqualToString:@"YES"]){
                    [labelFairway setHidden:NO];
                }
            }*/
            
        }
     
        ///2013.9.11
        [self calcTotalScore];
        
        for (int nIdx = 0; nIdx < 18; nIdx ++) {
            m_astHoleMap[nIdx] = [[S_HoleForGPS alloc] init];
        }
        
        [self updateHole];
        
//        [self loadActivity];
        [NSThread detachNewThreadSelector: @selector(loadPurchaseCourse) toTarget: self withObject: nil];

        
    } else {
        if(spinnerView){
            [spinnerView removeSpinner];
            spinnerView = nil;
        }
    }
    
}


- (void) updateHole{
    
    if([putts isEqualToString:@"YES"]){
        [labelPutts setHidden:NO];
    }
    else{
        [labelPutts setHidden:YES];
    }
    if([penalties isEqualToString:@"YES"]){
        [labelPenalty setHidden:NO];
    }
    else{
        [labelPenalty setHidden:YES];
    }
    if([accuracy isEqualToString:@"YES"]){
        [labelFairway setHidden:NO];
    }
    else{
        [labelFairway setHidden:YES];
    }
    
    
    if(currentHole == 0){
        buttonPrev.hidden = YES;
    }
    else{
   //     buttonPrev.hidden = NO;
    }
    
    if(currentHole == maxHole){
        [buttonNext setTitle:@"Finish Scoring" forState:UIControlStateNormal];
    }
    else{
        [buttonNext setTitle:@"Next Hole" forState:UIControlStateNormal];
    }
    
    holeID = ((currentHole +1 + [holeOffset intValue]) > (maxHole + 1)? (currentHole +1 + [holeOffset intValue] - (numberHoles + 1)) : (currentHole +1 + [holeOffset intValue]));
    labelHoleNo.text = [NSString stringWithFormat:@"HOLE %d", holeID];
    
    //////2013.9.11
    if (m_nMaxHole < currentHole) {
        m_nMaxHole = currentHole;
    }
    
    _m_labelHole.text = [NSString stringWithFormat: @"%d", holeID];
    if (holeID == 1) {
        _m_labelTh.text = @"st";
    } else if (holeID == 2) {
        _m_labelTh.text = @"nd";
    } else if (holeID == 3) {
        _m_labelTh.text = @"rd";
    } else {
        _m_labelTh.text = @"th";
    }

    [self loadMapInfo];
    
    ///////////
    GrintScore* currentScore = [scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];
    
  //  if([currentScore.par intValue] == 3){
    if(NO){
        //[labelTeeAccuracy setHidden:YES]; //TODO: disable fairway
        [labelFairway setHidden:YES];
    }
    else if([accuracy isEqualToString:@"YES"]){
        [labelFairway setHidden:NO];
    }

    
    if(currentScore.score && currentScore.score.length > 0){
        labelScore.text = currentScore.score;
        if([[pickerData objectAtIndex:0]containsObject:currentScore.score]){
        [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.score] inComponent:0 animated:NO];
        }
    }
    else{
        labelScore.text = @"";
        if([[pickerData objectAtIndex:0]containsObject:currentScore.par]){
        [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.par] inComponent:0 animated:NO];
        }
    }
    if(currentScore.putts && currentScore.putts.length > 0){
        labelPutts.text = currentScore.putts;
        if([[pickerData objectAtIndex:1]containsObject:currentScore.putts]){
        [picker1 selectRow:[[pickerData objectAtIndex:1]indexOfObject:currentScore.putts] inComponent:1 animated:NO];
        }
    }
    else{
        labelPutts.text = @"";
        [picker1 selectRow:2 inComponent:1 animated:NO];
    }
    if(currentScore.penalty && currentScore.penalty.length > 0){
        labelPenalty.text = currentScore.penalty;
        if([[pickerData objectAtIndex:2] containsObject:currentScore.penalty]){
        [picker1 selectRow:[[pickerData objectAtIndex:2]indexOfObject:currentScore.penalty] inComponent:2 animated:NO];
        }
    }
    else{
        labelPenalty.text = @"";
        [picker1 selectRow:0 inComponent:2 animated:NO];
    }
    if(currentScore.fairway && currentScore.fairway.length > 0){
        labelFairway.text = currentScore.fairway;
        if([[pickerData objectAtIndex:3]containsObject:currentScore.fairway]){
        [picker1 selectRow:[[pickerData objectAtIndex:3]indexOfObject:currentScore.fairway] inComponent:3 animated:NO];
        }
    }   
    else{
        labelFairway.text = @"";
        [picker1 selectRow:0 inComponent:3 animated:NO];
    }
    
    m_strHoleYards = [currentScore.statsHoleParYds copy];
    
    labelHoleParYds.text = currentScore.statsHoleParYds;
    labelAvgScore.text = currentScore.statsAvgScore;
    labelAvgPutts.text = currentScore.statsAvgPutts;
    labelAvgPenalty.text = currentScore.statsAvgPenalty;
    labelTeeAccuracy.text = currentScore.statsTeeAccuracy;
    labelAvgGir.text = currentScore.statsAvgGir;
    labelGrints.text = currentScore.statsGrints;
    
    
    
    [picker1 reloadAllComponents];
    
    int totalPar= 0;
    int totalScore = 0;
    
    for(GrintScore* tempscore in scores){
    
        if(tempscore.score && tempscore.score.length > 0){
        
        totalPar += [tempscore.par intValue];
        totalScore += [tempscore.score intValue];
        }
        
    }
    
    labelScoreSoFar.text = [NSString stringWithFormat:@"(%d)", totalScore];
    labelStrokesSoFar.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    
}

- (IBAction)showPicker:(id)sender{

    if(picker1.isHidden){
        [picker1 setHidden:NO];
        [buttonEnter setHidden:NO];
        
        labelScore.text = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];

                //if(!labelPutts.hidden){
                    labelPutts.text = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                //}
                
        if(!labelPenalty.hidden){
                    if([picker1 selectedRowInComponent:2] == 0){
                        labelPenalty.text = @"";
                        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                    }
                    else{
                        labelPenalty.text = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                    }
                }
        
          if(!labelFairway.hidden){
                    if([[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                        labelFairway.text = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        
                    }
                    else{
                        labelFairway.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    }
                }
    }
    else{
        [picker1 setHidden:YES];
        [buttonEnter setHidden:YES];
        
        ///2013.9.11
        [self calcTotalScore];
        /////
    }
    
}

//added code

#define STR_PURCHASE_MESSAGE_PREFIX @"PURCHASE_SINGLE"

- (BOOL) getPurchaseStatus
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat:@"check_purchase?user_name=%@&course=%d", username, [courseID integerValue]];
    BOOL FPurchase = [comm getPurchaseState: strData];
    
    return FPurchase;
}

- (BOOL) getMapState: (S_HoleForGPS*) stMap
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat:@"index?course=%d&hole=%d", [courseID integerValue], holeID];
    
    stMap.s_dictInfo = [[NSMutableDictionary alloc] init];
    stMap.s_FIsMap = [comm isMapped: strData MAP: stMap.s_dictInfo];
    stMap.s_FLoaded = YES;
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    if (_m_btnGPSState.selected)
        [self showGPSDistance: stMap.s_dictInfo CURPOS: m_LocationManager.location.coordinate];
    
    return stMap.s_FIsMap;
}

- (void) loadActivity
{
    if (spinnerView == nil)
        spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
}

- (IBAction)showGPSInfo:(id)sender {
    m_FMapButton = YES;

    if (_m_btnGPSState.selected == YES) {
        [self gpsOnProcess];
    } else {
        [self performSelector:@selector(loadActivity)];
        [self performSelector: @selector(mapProcess) withObject:nil afterDelay: 0.01];
    }
}

- (void) mapProcess
{
    if ([username isEqualToString:@"Guest"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Guest is allowed to show the GPS Data." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self turnOnGPS];
}

- (void) turnOnGPS {
    S_HoleForGPS* stHole = m_astHoleMap[holeID - 1];
    if (stHole.s_FIsMap) {
        [self processWithIAP];
    } else {
//        NSString* strTitle = @"This Golf Course is not mapped. \n Map it yourself with our tools \n and get free access to it.";
        
//        UIActionSheet *alertView = [[UIActionSheet alloc] initWithTitle:strTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle: @"Sure!  Email me the instructions" otherButtonTitles: @"Not now, thanks!", nil];
//        [alertView showInView: self.view];
//        alertView.center = self.view.center;
        
        UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
        MapperActionSheet* mapperController = [[MapperActionSheet alloc] initWithNibName: @"MapperActionSheet" bundle:nil];
        mapperController.delegate = self;
        overlay.dismissUponTouchMask = NO;
        
        [overlay presentOverlayOnView:self.view withContent:mapperController animated: YES];
    }
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

//- (void) willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView* view in [actionSheet subviews]) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton* button = (UIButton*)view;
//            [button.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: 18]];
//            if ([button.titleLabel.text rangeOfString: @"Email"].length > 0) {
//                NSString *version = [[UIDevice currentDevice] systemVersion];
//                
//                BOOL isAtLeast7 = [version floatValue] >= 7.0;
//                if (!isAtLeast7)
//                    [button setBackgroundImage:[UIImage imageNamed: @"button_green.png"] forState: UIControlStateNormal];
//            }
//        }
//    }
//}

- (void) acceptMakeMap
{
    [self sendMail];
}

- (void) sendMail
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat: @"make_map?user_name=%@&course=%d", username, [courseID integerValue]];
    BOOL FRequest = [comm requestMakeMap: strData];
    
    if (FRequest) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"We just sent you the instructions via email. Thanks for your help!" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message: @"Unfortunately your request has failed." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showHoleMap
{
    if (!m_astHoleMap[holeID-1].s_FIsMap) {
        return;
    }
    NSMutableDictionary* dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setObject:courseID forKey:@"courseid"];
    [dictParam setObject:[NSNumber numberWithInt: holeID] forKey:@"holeno"];
    [dictParam setObject:m_strHoleYards forKey:@"holepar"];
    
    gpsMapController.m_dictCourseInfo = [dictParam copy];
    gpsMapController.m_dictMapInfo = [[NSDictionary alloc] initWithDictionary: m_astHoleMap[holeID-1].s_dictInfo copyItems: YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGreenInfo:) name:STR_SHOW_GREEN_INFO object: gpsMapController];

    //        [self presentModalViewController: gpsMapController animated: YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:gpsMapController animated: YES];
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

- (void) showGreenInfo: (NSNotification*) aNotification
{
    ShowHoleMapController* gpsInfoController = (ShowHoleMapController*)aNotification.object;
    [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
    labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
    labelExtra.hidden = YES;
    
    CGPoint ptCenter = labelGPS.center;
    labelGreenCenter.center = ptCenter;
    [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
    labelGreenCenter.text = [NSString stringWithFormat: @"%d", gpsInfoController.m_nDistCenter];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //no thanks
            return;
            break;
        case 1: //$1.29
            m_nPurchaseKind = 0;
            [self buyPurchase: 1];
            break;
        case 2: //$14.99
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey: @"glance"] == nil || [[defaults objectForKey: @"glance"] integerValue] == 0) {
                [self getGlance];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void) getGlance
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: @"1" forKey: @"glance"];
    [defaults synchronize];

    m_FOnByGlance = YES;
    
    if ([defaults objectForKey: @"first_gps_state"] == nil || [[defaults objectForKey: @"first_gps_state"] integerValue] <= 0)
    {
        UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
        GPSUseGuideController* guideController = [[GPSUseGuideController alloc] initWithNibName:@"GPSUseGuideController" bundle:nil];
        guideController.m_parentController = self;
        overlay.dismissUponTouchMask = NO;
        
        [overlay presentOverlayOnView:self.view withContent:guideController animated: YES];
    } else {
        [self gpsOnProcess];
    }
}

- (void) buyPurchase: (int) nIdx {
    _products = [RageIAPHelper sharedInstance]._products;
    if (_products == nil || [_products count] < 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: nil message: @"Not ready now, please try again in a few seconds." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        [alertView show];
        return;
    }
    SKProduct *product = [_products objectAtIndex: nIdx];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[RageIAPHelper sharedInstance] buyProduct:product NOTIFICATION: STR_PURCHASE_MESSAGE_PREFIX];
    
    if (spinnerView == nil)
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            *stop = YES;
        }
    }];
    
}

- (void)purchaseResult:(NSNotification *)notification {
    NSString* strParam;
    IAPHelper* helper = notification.object;
    if (helper.m_nState == 0) { //success
        if (m_nPurchaseKind == 0)
            strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%d", username, [courseID integerValue]];
        else
            strParam = [NSString stringWithFormat:@"purchase?user_name=%@&course=%@", username, @"all"];
        
        Communication* comm = [[Communication alloc] init];
        [comm setPurchaseState: strParam];

        m_FEnableGPS = YES;

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey: @"first_gps_state"] == nil || [[defaults objectForKey: @"first_gps_state"] integerValue] <= 0) {
            UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
            GPSUseGuideController* guideController = [[GPSUseGuideController alloc] initWithNibName:@"GPSUseGuideController" bundle:nil];
            guideController.m_parentController = self;
            overlay.dismissUponTouchMask = NO;
            
            [overlay presentOverlayOnView:self.view withContent:guideController animated: YES];
        } else {
            [self gpsOnProcess];
        }
    } else { //restore or failure
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Purchase Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

- (void) gpsOnProcess
{
    _m_btnGPSState.selected = YES;
    _m_labelGPSState.text = @"GPS ON";
    [self showGPSDistance: m_astHoleMap[holeID - 1].s_dictInfo CURPOS: m_LocationManager.location.coordinate];
    
    if (m_FMapButton) {
        [self showHoleMap];
    }
}

- (double) getDistanceFromLatLonInM: (CLLocationCoordinate2D) firstLoc SECOND: (CLLocationCoordinate2D) secondLoc {
    double R = 6371000 * YARDS_PER_METER; // Radius of the earth in km
    double dLat = (PI / 180) * (secondLoc.latitude - firstLoc.latitude);  // deg2rad below
    double dLon = (PI / 180) * (secondLoc.longitude - firstLoc.longitude);
    double a = sin(dLat/2) * sin(dLat/2) + cos((PI / 180) * firstLoc.latitude) * cos((PI / 180) * (secondLoc.latitude)) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c; // Distance in km
    return d;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (m_FEnableGPS && _m_btnGPSState.selected && locations && [locations count] > 0) {
        CLLocation* loc = locations.lastObject;
        CLLocationCoordinate2D currentPos = loc.coordinate;
        
        NSDictionary* dictMap = m_astHoleMap[holeID - 1].s_dictInfo;
        
        [self showGPSDistance: dictMap CURPOS: currentPos];
    }
}

- (void) showGPSDistance: (NSDictionary*) dictMap CURPOS: (CLLocationCoordinate2D) currentPos
{
    if (_m_btnGPSState.selected == YES) {
        if ([dictMap objectForKey: STR_KEY_GREEN_CENTER]) {
            NSDictionary* dictCenter = [dictMap objectForKey: STR_KEY_GREEN_CENTER];
            CLLocationCoordinate2D centerPos = CLLocationCoordinate2DMake([[dictCenter objectForKey: @"lat"] doubleValue], [[dictCenter objectForKey: @"lng"] doubleValue]);
            int nDist = [self getDistanceFromLatLonInM: currentPos SECOND: centerPos];
            if (nDist < 2000) {
                [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
                labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
                labelExtra.hidden = YES;
                
                CGPoint ptCenter = labelGPS.center;
                labelGreenCenter.center = ptCenter;
                [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
                labelGreenCenter.text = [NSString stringWithFormat: @"%d", nDist];
            } else {
                [self calcDistanceFromTeeToGreen];
            }
        }
    } else {
        CGPoint ptCenter = labelGPS.center;
        ptCenter.y += 7;
        labelGreenCenter.center = ptCenter;
        
        [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
        [labelExtra setText: @"Tap for"];
        labelExtra.hidden = NO;
        labelGPS.text = @"";
        [labelGreenCenter setText: @"GPS"];
        [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    }
}

- (void) calcDistanceFromTeeToGreen
{
    NSDictionary* dictMap = m_astHoleMap[holeID - 1].s_dictInfo;
    NSDictionary* dictTee = [dictMap objectForKey: STR_KEY_TEEBOX];
    NSDictionary* dictCenter = [dictMap objectForKey: STR_KEY_GREEN_CENTER];
    CLLocationCoordinate2D centerPos = CLLocationCoordinate2DMake([[dictCenter objectForKey: @"lat"] doubleValue], [[dictCenter objectForKey: @"lng"] doubleValue]);
    CLLocationCoordinate2D teePos = CLLocationCoordinate2DMake([[dictTee objectForKey: @"lat"] doubleValue], [[dictTee objectForKey: @"lng"] doubleValue]);
    
    int nDist = [self getDistanceFromLatLonInM: teePos SECOND: centerPos];
    
    [labelGPS setFont: [UIFont fontWithName: @"Oswald" size: 11]];
    labelGPS.text = @"Yards to pin \n \n \n Tap for Map";//[NSString stringWithFormat:@"Yards to pin \n \n Tap for Map", gpsInfoController.m_nDistBack, gpsInfoController.m_nDistFront];
    labelExtra.hidden = YES;
    
    
    CGPoint ptCenter = labelGPS.center;
    labelGreenCenter.center = ptCenter;
    [labelGreenCenter setFont: [UIFont fontWithName: @"Oswald" size: 32]];
    labelGreenCenter.text = [NSString stringWithFormat: @"%d", nDist];
}

- (void) loadMapInfo {
    S_HoleForGPS* stMap = m_astHoleMap[holeID - 1];
    if (!stMap.s_FLoaded) {
        if (spinnerView == nil)
            spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
        [NSThread detachNewThreadSelector:@selector(getMapState:) toTarget:self withObject:stMap];
    } else {
        if (_m_btnGPSState.selected)
            [self showGPSDistance: stMap.s_dictInfo CURPOS: m_LocationManager.location.coordinate];
    }
}

- (IBAction)prevHole:(id)sender{
    if (m_FOnByGlance == YES) {
        m_FOnByGlance = NO;
        [self changeGPSState];
    }
    
    currentHole --;
    [self updateHole];

    //added code
    //[m_LocationManager stopUpdatingLocation];
    
    
//    CGPoint ptCenter = labelGPS.center;
//    ptCenter.y += 7;
//    labelGreenCenter.center = ptCenter;
//    
//    [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
//    [labelExtra setText: @"Tap for"];
//    labelExtra.hidden = NO;
//    labelGPS.text = @"";
//    [labelGreenCenter setText: @"GPS"];
//    [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    
    //2013.9.11
//    if (_m_btnGPSState.selected) {
//        if (!m_FEnableGPS || !m_astHoleMap[holeID - 1].s_FLoaded || !m_astHoleMap[holeID - 1].s_FIsMap) {
//            _m_btnGPSState.selected = NO;
//            _m_labelGPSState.text = @"GPS OFF";
//        }
//    }
    
    gpsMapController.m_nFirstDraw = 1;
    /////////////////

}

-(IBAction)nextScreen:(id)sender{
    if(picker1.hidden){
    
        
    /*
     
     serialize state
     
     */
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setBool:YES forKey:@"savedState"];
        [defaults setBool:NO forKey:@"savedState_multiplayer"];
        [defaults setValue:username forKey:@"savedState_username"];
        [defaults setValue:courseName forKey:@"savedState_courseName"];
        [defaults setValue:courseAddress forKey:@"savedState_courseAddress"];
        [defaults setValue:teeboxColor forKey:@"savedState_teeboxColor"];
        [defaults setValue:score forKey:@"savedState_score"];
        [defaults setValue:putts forKey:@"savedState_putts"];
        [defaults setValue:penalties forKey:@"savedState_penalties"];
        [defaults setValue:accuracy forKey:@"savedState_accuracy"];
        [defaults setValue:date forKey:@"savedState_date"];
        [defaults setValue:player1 forKey:@"savedState_player1"];
        [defaults setValue:player2 forKey:@"savedState_player2"];
        [defaults setValue:player3 forKey:@"savedState_player3"];
        [defaults setValue:player4 forKey:@"savedState_player4"];
        [defaults setValue:courseID forKey:@"savedState_courseID"];
        [defaults setValue:teeID forKey:@"savedState_teeID"];
        [defaults setValue:holeOffset forKey:@"savedState_holeOffset"];
        [defaults setValue:pickerData forKey:@"savedState_pickerData"];
        [defaults setInteger:currentHole forKey:@"savedState_currentHole"];
        [defaults setInteger:maxHole forKey:@"savedState_maxHole"];
        [defaults setInteger:numberHoles forKey:@"savedState_numberHoles"];
        
        [defaults setValue:[NSArray arrayWithObjects:
                            [(GrintScore*)[scores objectAtIndex:0] toArray],
                            [(GrintScore*)[scores objectAtIndex:1] toArray],
                            [(GrintScore*)[scores objectAtIndex:2] toArray],
                            [(GrintScore*)[scores objectAtIndex:3] toArray],
                            [(GrintScore*)[scores objectAtIndex:4] toArray],
                            [(GrintScore*)[scores objectAtIndex:5] toArray],
                            [(GrintScore*)[scores objectAtIndex:6] toArray],
                            [(GrintScore*)[scores objectAtIndex:7] toArray],
                            [(GrintScore*)[scores objectAtIndex:8] toArray],
                            [(GrintScore*)[scores objectAtIndex:9] toArray],
                            [(GrintScore*)[scores objectAtIndex:10] toArray],
                            [(GrintScore*)[scores objectAtIndex:11] toArray],
                            [(GrintScore*)[scores objectAtIndex:12] toArray],
                            [(GrintScore*)[scores objectAtIndex:13] toArray],
                            [(GrintScore*)[scores objectAtIndex:14] toArray],
                            [(GrintScore*)[scores objectAtIndex:15] toArray],
                            [(GrintScore*)[scores objectAtIndex:16] toArray],
                            [(GrintScore*)[scores objectAtIndex:17] toArray],
                            nil]  forKey:@"savedState_scores"];
        [defaults setInteger:currentHole forKey:@"savedState_currentHole"];
        
        [defaults synchronize];
        
    if(labelScore.text.length < 1){
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else if (labelPutts.text.length < 1 && !labelPutts.hidden){

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    else if (labelFairway.text.length < 1 && !labelFairway.hidden){
     
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    else if([labelPutts.text intValue] >= [[[pickerData objectAtIndex:0]objectAtIndex:[picker1 selectedRowInComponent:0]] intValue]){
        
        if (labelPutts.hidden == YES) {
            GrintScore* curScore = ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]);
            curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
            labelPutts.text = curScore.putts;
            [self nextScreen: sender];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        if (m_FOnByGlance == YES) {
            m_FOnByGlance = NO;
            [self changeGPSState];
        }
        

        if(currentHole < numberHoles){
            currentHole ++;
            [self updateHole];
            //added code
            //[m_LocationManager stopUpdatingLocation];
            
            
//            CGPoint ptCenter = labelGPS.center;
//            ptCenter.y += 7;
//            labelGreenCenter.center = ptCenter;
//            
//            [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
//            [labelExtra setText: @"Tap for"];
//            labelExtra.hidden = NO;
//            labelGPS.text = @"";
//            [labelGreenCenter setText: @"GPS"];
//            [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
            
            gpsMapController.m_nFirstDraw = 1;
            
            //2013.9.1
//            if (_m_btnGPSState.selected) {
//                if (!m_FEnableGPS || !m_astHoleMap[holeID - 1].s_FLoaded || !m_astHoleMap[holeID - 1].s_FIsMap) {
//                    _m_btnGPSState.selected = NO;
//                    _m_labelGPSState.text = @"GPS OFF";
//                }
//            }
            
            /////////////////

        }
        else{
            [self updateHole];

        
            [Flurry logEvent:@"playgolf_end"];
            [self showScoreView];
        }
            
        }
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        NSArray* temp1 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11", @"12", nil];
        NSArray* temp2 = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
        NSArray* temp3 = [NSArray arrayWithObjects: @"None",
                          @"S Greenside Sand",
                          @"F Fairway Sand",
                          @"W Water Hazard",
                          @"O Out of Bounds",
                          @"D Drop shot",
                          @"SS",
                          @"FF",
                          @"WW",
                          @"OO",
                          @"DD",
                          @"FS",
                          @"WS",
                          @"OS",
                          @"DS", @"OF", @"OW", nil];
        NSArray* temp4 = [[NSArray alloc] initWithObjects:@"Hit",@"Missed Left",@"Missed Right", @"Missed Short", @"Missed Long", @" Shank", nil];
        
        self.pickerData = [NSArray arrayWithObjects:temp1, temp2, temp3, temp4, nil];
        
        self.scores = [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"resetScore"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"resetScore"];
        
        currentHole = 0;
        self.scores = [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil];

        
    }
    
    [self updateHole];
    self.navigationController.navigationBar.hidden = YES;
    
    [m_LocationManager startUpdatingLocation];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /// updated code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResult:) name:STR_PURCHASE_MESSAGE_PREFIX object:nil];
    /////////////

    [buttonPrev.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [buttonPrev.layer setCornerRadius:5.0f];
    [buttonNext.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [buttonNext.layer setCornerRadius:5.0f];
    [buttonEnter.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [buttonEnter.layer setCornerRadius:5.0f];
    
    [labelHoleNo setFont:[UIFont fontWithName:@"Oswald" size:24]];
    
    //update code//
    [labelGPS.layer setCornerRadius: labelGPS.bounds.size.width/2];
    [btnGPS.layer setCornerRadius: btnGPS.bounds.size.width/2];

    [btnGPS.layer setShadowColor:[UIColor blackColor].CGColor];
    [btnGPS.layer setShadowOpacity:0.7];
    [btnGPS.layer setShadowRadius:2];
    [btnGPS.layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    
    [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
    [labelExtra setText: @"Tap for"];
    labelExtra.hidden = NO;
    labelGPS.text = @"";
    
    [labelBottom setFont: [UIFont fontWithName:@"Oswald" size: 17]];
    
    CGPoint ptCenter = labelGPS.center;
    ptCenter.y += 7;
    labelGreenCenter.center = ptCenter;
    [labelGreenCenter setText: @"GPS"];
    [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    [labelGrint setFont: [UIFont fontWithName:@"Oswald" size: 28]];
    
    
    m_LocationManager = [[CLLocationManager alloc] init];
    m_LocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_LocationManager.delegate = self;
    
    gpsMapController = [[ShowHoleMapController alloc] initWithNibName:@"ShowHoleMapController" bundle:nil];
    
    [_m_labelScore1 setFont:[UIFont fontWithName:@"Oswald" size:20]];
    [_m_labelScore2 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [_m_labelHole setFont:[UIFont fontWithName:@"Oswald" size:20]];
    [_m_labelGPSState setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [_m_labelTrack setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [_m_labelScore setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [_m_labelHoleCaption setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [_m_labelTh setFont:[UIFont fontWithName:@"Oswald" size:15]];

    ///////////////
    
    [labelScore.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelPutts.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelPenalty.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelFairway.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelAvgScore.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelAvgPutts.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelAvgPenalty.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelTeeAccuracy.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelAvgGir.layer setCornerRadius: labelScore.bounds.size.width/2];
    [labelGrints.layer setCornerRadius: labelScore.bounds.size.width/2];
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label5 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label9 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label10 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    
    [labelStrokesSoFar setFont:[UIFont fontWithName:@"Oswald" size:30.0]];
    [labelScoreSoFar setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    
   // currentHole = 0;
    
   // [self updateHole];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/holedata_iphone_new"]];
    NSString* requestBody = [NSString stringWithFormat:@"username=%@&course_id=%d&teeid=%@", self.username, [self.courseID intValue], self.teeID];
    if(self.numberHoles < 10){
        requestBody = [requestBody stringByAppendingString:@"&is_nine=1"];
    }
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
        if (spinnerView == nil)
            spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    }

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(swipeRightDetected:)];
    
    [[self navigationItem] setLeftBarButtonItem:backButton];
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
    [[self navigationItem]setRightBarButtonItem:leftButton];
    
}


- (void)swipeRightDetected:(id)sender{
    
    if (holeID == [holeOffset integerValue] + 1)
        self.navigationController.navigationBar.hidden = NO;
    
    if (picker1.hidden){
    
    if(currentHole == 0){
    
        if(spinnerView){
            [spinnerView removeSpinner];
            spinnerView = nil;
        }

        [[self navigationController] popViewControllerAnimated:YES];
        
        //added code
        [m_LocationManager stopUpdatingLocation];

    }
    else{
        [self prevHole:sender];
    }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            labelScore.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
            ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
            
            ////2013.9.11
            [self calcTotalScore];
            ///////////
            
            break;
        case 1:
            if(!labelPutts.hidden){
//                NSString* strPutts = [[pickerData objectAtIndex:1] objectAtIndex:row];
//                if (labelScore.text.integerValue <= strPutts.integerValue) {
//                    labelPutts.text = [[pickerData objectAtIndex:1] objectAtIndex:0];
//                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Putts too high" message: @"Putts can never be same or higher than the score" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                    [alertView show];
//                    return;
//                }
                labelPutts.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
            }
            break;
        case 2:
            if(!labelPenalty.hidden){
            if(row == 0){
                labelPenalty.text = @"";
                ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
            }
            else{
            labelPenalty.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
             ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
            }
            }
            break;
        case 3:
            if(!labelFairway.hidden){
                if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                    labelFairway.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                    
                }
                else{
                    labelFairway.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    ((GrintScore*)[scores objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                }
            }
            break;
            
        default:
            break;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    CGRect frame = view.frame;
    pickerLabel = [[UILabel alloc] initWithFrame:frame];
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    if(component == 0){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    }
    else if(component == 1){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        if(labelPutts.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
    }
    else if(component == 2){
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        
        if(labelPenalty.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }

    }
    else{
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        if(labelFairway.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }

    }
    [pickerLabel setNumberOfLines:2];
    [pickerLabel setText:[[pickerData objectAtIndex:component] objectAtIndex:row]];
      
    
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray* array = [self.pickerData objectAtIndex:component];
    int nCount = [array count];
    return nCount;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* strTitle = [[pickerData objectAtIndex:component] objectAtIndex:row];
    return strTitle;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
    if (currentHole == [holeOffset integerValue])
        self.navigationController.navigationBar.hidden = NO;
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToNext:(id)sender {
    [self nextScreen: sender];
}

- (IBAction)goToPrev:(id)sender {
    [self swipeRightDetected: sender];
}


/////2013.9.11

- (void) calcTotalScore
{
    int nTotalScore = 0;
    int nStroke = 0;
    for (GrintScore* curScore in self.scores) {
        int nScore = [curScore.score integerValue];
        if (nScore > 0) {
            nTotalScore += nScore;
            nStroke += (nScore - [curScore.par integerValue]);
        }
    }
    if (nStroke > 0)
        _m_labelScore1.text = [NSString stringWithFormat: @"+%d", nStroke];
    else
        _m_labelScore1.text = [NSString stringWithFormat: @"%d", nStroke];
    
    _m_labelScore2.text = [NSString stringWithFormat:@"(%d)", nTotalScore];
}

- (void) loadPurchaseCourse
{
    m_FEnableGPS = [self getPurchaseStatus];
    
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
}

- (void) willPresentAlertView:(UIAlertView *)alertView
{
//    for (int nIdx = 0; nIdx < 10; nIdx ++) {
//        UIView* view = [alertView viewWithTag: nIdx];
//        if ([view isKindOfClass: [UIButton class]]) {
//            UIButton* button = (UIButton*) view;
//            if ([button.titleLabel.text isEqualToString: @"a"]) {
//                button.hidden = YES;
//            }
//        }
//    }
//    [self hideExtraButton: alertView];
}

- (void) hideExtraButton: (UIView*) parent
{
    for (UIView* view in [parent subviews]) {
        if ([view isKindOfClass: [UIButton class]]) {
            UIButton* button = (UIButton*) view;
            if ([button.titleLabel.text isEqualToString: @"a"]) {
                button.hidden = YES;
            }
        } else if ([view isKindOfClass: [UIView class]]) {
            [self hideExtraButton: view];
        }
    }
}

- (void) showAlertView
{
    TSAlertView* av = [[TSAlertView alloc] init];
	av.title = @"";
	av.message = @"Get accurate GPS Maps and distances \n for this golf course";
	
    [av addButtonWithTitle: @"$0.99 Unlimited access to this Map"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: @"glance"] == nil || [[defaults objectForKey: @"glance"] integerValue] == 0)
        [av addButtonWithTitle: @"One Hole Sneak Peek!"];
    
	[av addButtonWithTitle: @"Not now, thanks!"];
	
	av.style = TSAlertViewStyleNormal;//_hasInputFieldSwitch.on ? TSAlertViewStyleInput : TSAlertViewStyleNormal;
	av.buttonLayout = TSAlertViewButtonLayoutStacked;//_stackedSwitch.on ? TSAlertViewButtonLayoutStacked : TSAlertViewButtonLayoutNormal;
	av.usesMessageTextView = NO;//_usesTextViewSwitch.on;
	
	av.width = 0;//[_widthTextField.text floatValue];
	av.maxHeight = 0;//[_maxHeightTextField.text floatValue];
    av.delegate = self;
    
	[av show];

//    NSString* strTitle = @"Get accurate GPS Maps and distances for this golf course";
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey: @"glance"] == nil || [[defaults objectForKey: @"glance"] integerValue] == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strTitle delegate:self cancelButtonTitle: @"Not now, thanks!" otherButtonTitles: @"$0.99 Unlimited access to this Map", @"One Hole Sneak Peek!", nil];
//        [alertView show];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strTitle delegate:self cancelButtonTitle: @"Not now, thanks!" otherButtonTitles: @"$0.99 Unlimited access to this Map", nil];
//        [alertView setAutoresizesSubviews: YES];
//        [alertView show];
//    }
}

- (void) processWithIAP
{
    if (m_FEnableGPS == NO) {
        [self showAlertView];
//        NSString* strTitle = @"Get accurate GPS Maps and \n distances for this golf course";
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strTitle delegate:self cancelButtonTitle: nil otherButtonTitles: @"$0.99 Unlimited access to this Map", @"Not now, thanks!", @"a", nil];
//        alertView.cancelButtonIndex = -1;
//        
//        [[alertView viewWithTag: 3] removeFromSuperview];
//        CGRect rect = alertView.bounds;
//        rect.size.height -= 30;
//        [alertView setBounds: rect];
//        [alertView show];
    } else {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey: @"first_gps_state"] == nil || [[defaults objectForKey: @"first_gps_state"] integerValue] <= 0) {
            UIXOverlayController* overlay = [[UIXOverlayController alloc] init];
            GPSUseGuideController* guideController = [[GPSUseGuideController alloc] initWithNibName:@"GPSUseGuideController" bundle:nil];
            guideController.m_parentController = self;
            overlay.dismissUponTouchMask = NO;
            
            [overlay presentOverlayOnView:self.view withContent:guideController animated: YES];
        } else {
            [self gpsOnProcess];
        }
    }
}

//////2013.9.11
- (IBAction)onTouchScoreButton:(id)sender {
    [self showScoreView];
}

- (void) showScoreView
{
    if (!self.detailViewController) {
        if ([UIScreen mainScreen].bounds.size.height > 490 || [UIScreen mainScreen].bounds.size.width > 490) {
            self.detailViewController = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore5" bundle:nil];
        } else
            self.detailViewController = [[GrintBNewReviewScore alloc] initWithNibName:@"GrintBNewReviewScore" bundle:nil];
    }
    self.detailViewController.m_strCourseName = self.courseName;
    self.detailViewController.m_strUserName = [[NSString stringWithFormat: @"%@ %@", [fname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] , [lname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] uppercaseString];
    self.detailViewController.m_scores = self.scores;
    
    int nCount = 0;
    for (int nIdx = 0; nIdx < 18; nIdx ++) {
        GrintScore* curscore = [self.scores objectAtIndex: nIdx];
        if ([curscore.score integerValue] > 0)
            nCount ++;
    }
    
    if (nCount >= self.numberHoles + 1)
        self.detailViewController.FComplete = YES;
    else
        self.detailViewController.FComplete = NO;
    
    self.detailViewController.teeID = self.teeID;
    self.detailViewController.isNine = self.numberHoles > 8 ? NO : YES;
    self.detailViewController.nineType = self.maxHole > 8 ? @"back" : @"front";
    //
    //
    self.detailViewController.username = self.username;
    self.detailViewController.courseName= self.courseName;
    self.detailViewController.courseAddress= self.courseAddress;
    self.detailViewController.teeboxColor= self.teeboxColor;
    self.detailViewController.date = self.date;
    self.detailViewController.score = self.score;
    self.detailViewController.putts = self.putts;
    self.detailViewController.penalties = self.penalties;
    self.detailViewController.accuracy = self.accuracy;
    self.detailViewController.player1 = self.player1;
    self.detailViewController.player2 = self.player2;
    self.detailViewController.player3 = self.player3;
    self.detailViewController.player4 = self.player4;
    self.detailViewController.courseID = self.courseID;
    self.detailViewController.scores = self.scores;
    self.detailViewController.holeOffset = self.holeOffset;
    [self.navigationController pushViewController: self.detailViewController animated: YES];

}

- (IBAction)onTouchHoleButton:(id)sender {
    
    NSMutableArray* menuItems = [[NSMutableArray alloc] init];
    NSString* strCaption;
    KxMenuItem* item;
    int nHoleID = 0;
    for (int nIdx = 0; nIdx <= m_nMaxHole; nIdx ++) {
        nHoleID = holeID = ((nIdx +1 + [holeOffset intValue]) > (maxHole + 1)? (nIdx +1 + [holeOffset intValue] - (numberHoles + 1)) : (nIdx +1 + [holeOffset intValue]));
        strCaption = [NSString stringWithFormat: @"Hole %d", nHoleID];
        item = [KxMenuItem menuItem: strCaption
                              image:nil
                             target:self
                             action:@selector(pushMenuItem:)
                                tag: nIdx];
        [menuItems addObject: item];
    }
    
    UIView* view = ((UIButton*)sender).superview;
    CGRect rect = view.frame;
    rect.origin.y = view.superview.frame.origin.y;
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems type: 1];
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem* item = ((KxMenuItem*)sender);
    currentHole = item.nTag;
    
    [self updateHole];
    
    //added code
    //[m_LocationManager stopUpdatingLocation];
    CGPoint ptCenter = labelGPS.center;
    ptCenter.y += 7;
    labelGreenCenter.center = ptCenter;
    
    [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
    [labelExtra setText: @"Tap for"];
    labelExtra.hidden = NO;
    labelGPS.text = @"";
    [labelGreenCenter setText: @"GPS"];
    [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    
//    if (_m_btnGPSState.selected) {
//        if (!m_FEnableGPS || !m_astHoleMap[holeID - 1].s_FLoaded || !m_astHoleMap[holeID - 1].s_FIsMap) {
//            _m_btnGPSState.selected = NO;
//            _m_labelGPSState.text = @"GPS OFF";
//        }
//    }
    
    gpsMapController.m_nFirstDraw = 1;
    
}



- (IBAction)onTouchGPSStateButton:(id)sender {
    
    m_FMapButton = NO;
    
    [self changeGPSState];
}

- (void) changeGPSState
{
    if (_m_btnGPSState.selected == NO) {
        [self performSelector:@selector(loadActivity)];
        [self performSelector: @selector(mapProcess) withObject:nil afterDelay: 0.01];
    } else {
        _m_btnGPSState.selected = NO;
        _m_labelGPSState.text = @"GPS OFF";

        CGPoint ptCenter = labelGPS.center;
        ptCenter.y += 7;
        labelGreenCenter.center = ptCenter;

        [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
        [labelExtra setText: @"Tap for"];
        labelExtra.hidden = NO;
        labelGPS.text = @"";
        [labelGreenCenter setText: @"GPS"];
        [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
    }
}


////


@end
