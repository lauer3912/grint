//
//  GrintBWriteScoreMultiplayer.m
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

#import "GrintBWriteScoreMultiplayer.h"
#import "GrintBReviewScoreMultiplayer.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintScore.h"
#import "GrintBWriteScoreMultiplayerStats.h"
#import "Flurry.h"

#import "RageIAPHelper.h"
#import "Communication.h"

#import "KxMenu.h"
#import "UIXOverlayController.h"
#import "GPSUseGuideController.h"


#import "ShowHoleMapController.h"

@implementation GrintBWriteScoreMultiplayer
@synthesize detailViewController = _detailViewController;

@synthesize holeID;//added code
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
@synthesize pickerData, scores, currentHole, playerData, maxHole, numberHoles;

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

- (void)displayStats:(id)sender{
    
    if(picker1.hidden){
    
    GrintBWriteScoreMultiplayerStats* controller = [[GrintBWriteScoreMultiplayerStats alloc]initWithNibName:@"GrintBWriteScoreMultiplayerStats" bundle:nil];
    controller.holeData = [[NSArray alloc]initWithObjects:
                           [[scores objectAtIndex:0]objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])],
                           [[scores objectAtIndex:1]objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])],
                           [[scores objectAtIndex:2]objectAtIndex:(currentHole + [ holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])],
                           [[scores objectAtIndex:3]objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])], nil];
    controller.holeNumber = [NSString stringWithFormat:@"HOLE %d", ((currentHole +1 + [holeOffset intValue]) > (maxHole + 1)? (currentHole +1 + [holeOffset intValue] - (numberHoles + 1)) : (currentHole +1 + [holeOffset intValue]))];
    controller.holeParYds = ((GrintScore*)[[scores objectAtIndex:0]objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).statsHoleParYds;
    controller.username1 = player1;
    controller.username2 = player2;
    controller.username3 = player3;
    controller.username4 = player4;
    controller.playerData = self.playerData;
    controller.delegate = self;
        controller.scores = scores;
    [self presentModalViewController:controller animated:YES];
    }
    
}

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
    
    if([[connection.originalRequest.URL description]isEqualToString:@"https://www.thegrint.com/holedata_iphone_new_multiplayer"]){
        
        NSLog(responseText);
                
        for(int h = 1; h <= 4; h++){
            
            NSString* playerString = [self stringBetweenString:[NSString stringWithFormat:@"<player%d>", h] andString:[NSString stringWithFormat:@"</player%d>", h] forString:responseText];
            
            for(int i = 1; i < 19; i++){
            
            NSString* tempString = [self stringBetweenString:[NSString stringWithFormat:@"<hole%d>", i] andString:[NSString stringWithFormat:@"</hole%d>", i] forString:playerString];
            
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).par = [self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString];
            
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsHoleParYds = [NSString stringWithFormat:@"Par %d / %d yards", [[self stringBetweenString:@"<par>" andString:@"</par>" forString:tempString] intValue],[[self stringBetweenString:@"<yards>" andString:@"</yards>" forString:tempString] intValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsAvgScore = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgscore>" andString:@"</avgscore>" forString:tempString] floatValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsAvgPutts = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgputts>" andString:@"</avgputts>" forString:tempString] floatValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsAvgPenalty = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avgpenalty>" andString:@"</avgpenalty>" forString:tempString] floatValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsTeeAccuracy = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<teeaccuracy>" andString:@"</teeaccuracy>" forString:tempString] intValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsAvgGir = [NSString stringWithFormat:@"%.1f", [[self stringBetweenString:@"<avggir>" andString:@"</avggir>" forString:tempString] floatValue]];
            ((GrintScore*)[[self.scores objectAtIndex:h - 1] objectAtIndex:i - 1]).statsGrints = [NSString stringWithFormat:@"%d", [[self stringBetweenString:@"<grints>" andString:@"</grints>" forString:tempString] intValue]];
                      
            }
            
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
        [labelPutts1 setHidden:NO];
        [labelPutts2 setHidden:NO];
        [labelPutts3 setHidden:NO];
        [labelPutts4 setHidden:NO];
    }
    else{
        [labelPutts1 setHidden:YES];
        [labelPutts2 setHidden:YES];
        [labelPutts3 setHidden:YES];
        [labelPutts4 setHidden:YES];
    }
    if([penalties isEqualToString:@"YES"]){
        [labelPenalty1 setHidden:NO];
        [labelPenalty2 setHidden:NO];
        [labelPenalty3 setHidden:NO];
        [labelPenalty4 setHidden:NO];
    }
    else{
        [labelPenalty1 setHidden:YES];
        [labelPenalty2 setHidden:YES];
        [labelPenalty3 setHidden:YES];
        [labelPenalty4 setHidden:YES];
    }
    if([accuracy isEqualToString:@"YES"]){
        [labelFairway1 setHidden:NO];
        [labelFairway2 setHidden:NO];
        [labelFairway3 setHidden:NO];
        [labelFairway4 setHidden:NO];
    }
    else{
        [labelFairway1 setHidden:YES];
        [labelFairway2 setHidden:YES];
        [labelFairway3 setHidden:YES];
        [labelFairway4 setHidden:YES];
    }
    
    if(player3.length < 1){
        labelUsername3.hidden = YES;
        labelScore3.hidden = YES;
        labelPutts3.hidden = YES;
        labelPenalty3.hidden = YES;
        labelFairway3.hidden = YES;
    }
    if(player4.length < 1){
        labelUsername4.hidden = YES;
        labelScore4.hidden = YES;
        labelPutts4.hidden = YES;
        labelPenalty4.hidden = YES;
        labelFairway4.hidden = YES;
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

    
    GrintScore* currentScore = [[scores objectAtIndex: 0] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];
    
    
    
  //  if([currentScore.par intValue] == 3){
    if(NO){
        [labelFairway1 setHidden:YES];
        [labelFairway2 setHidden:YES];
        [labelFairway3 setHidden:YES];
        [labelFairway4 setHidden:YES];
    }
    else if([accuracy isEqualToString:@"YES"]){
        [labelFairway1 setHidden:NO];
        [labelFairway2 setHidden:NO];
         if(player3.length > 0)
        [labelFairway3 setHidden:NO];
         if(player4.length > 0)
        [labelFairway4 setHidden:NO];
    }
    
    
    if(currentScore.score){
        labelScore1.text = currentScore.score;
        if([[pickerData objectAtIndex:0]containsObject:currentScore.score]){
            [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.score] inComponent:0 animated:NO];
        }
    }
    else{
        labelScore1.text = @"";
        if([[pickerData objectAtIndex:0]containsObject:currentScore.par]){
            [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.par] inComponent:0 animated:NO];
        }
    }
    if(currentScore.putts){
        labelPutts1.text = currentScore.putts;
        if([[pickerData objectAtIndex:1]containsObject:currentScore.putts]){
            [picker1 selectRow:[[pickerData objectAtIndex:1]indexOfObject:currentScore.putts] inComponent:1 animated:NO];
        }
    }
    else{
        labelPutts1.text = @"";
        [picker1 selectRow:2 inComponent:1 animated:NO];
    }
    if(currentScore.penalty){
        labelPenalty1.text = currentScore.penalty;
        if([[pickerData objectAtIndex:2] containsObject:currentScore.penalty]){
            [picker1 selectRow:[[pickerData objectAtIndex:2]indexOfObject:currentScore.penalty] inComponent:2 animated:NO];
        }
    }
    else{
        labelPenalty1.text = @"";
        [picker1 selectRow:0 inComponent:2 animated:NO];
    }
    if(currentScore.fairway){
        labelFairway1.text = currentScore.fairway;
        if([[pickerData objectAtIndex:3]containsObject:currentScore.fairway]){
            [picker1 selectRow:[[pickerData objectAtIndex:3]indexOfObject:currentScore.fairway] inComponent:3 animated:NO];
        }
    }
    else{
        labelFairway1.text = @"";
        [picker1 selectRow:0 inComponent:3 animated:NO];
    }
    
    m_strHoleYards = [currentScore.statsHoleParYds copy];
    labelHoleParYds.text = m_strHoleYards;
    
    
    currentScore = [[scores objectAtIndex: 1] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];
    
    if(currentScore.score){
        labelScore2.text = currentScore.score;
    }
    else{
        labelScore2.text = @"";
    }
    if(currentScore.putts){
        labelPutts2.text = currentScore.putts;
       }
    else{
        labelPutts2.text = @"";
     }
    if(currentScore.penalty){
        labelPenalty2.text = currentScore.penalty;
    }
    else{
        labelPenalty2.text = @"";
    }
    if(currentScore.fairway){
        labelFairway2.text = currentScore.fairway;
     }
    else{
        labelFairway2.text = @"";
    }

    currentScore = [[scores objectAtIndex: 2] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];
    
    if(currentScore.score){
        labelScore3.text = currentScore.score;
    }
    else{
        labelScore3.text = @"";
    }
    if(currentScore.putts){
        labelPutts3.text = currentScore.putts;
    }
    else{
        labelPutts3.text = @"";
    }
    if(currentScore.penalty){
        labelPenalty3.text = currentScore.penalty;
    }
    else{
        labelPenalty3.text = @"";
    }
    if(currentScore.fairway){
        labelFairway3.text = currentScore.fairway;
    }
    else{
        labelFairway3.text = @"";
    }

    currentScore = [[scores objectAtIndex: 3] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];
    
    if(currentScore.score){
        labelScore4.text = currentScore.score;
    }
    else{
        labelScore4.text = @"";
    }
    if(currentScore.putts){
        labelPutts4.text = currentScore.putts;
    }
    else{
        labelPutts4.text = @"";
    }
    if(currentScore.penalty){
        labelPenalty4.text = currentScore.penalty;
    }
    else{
        labelPenalty4.text = @"";
    }
    if(currentScore.fairway){
        labelFairway4.text = currentScore.fairway;
    }
    else{
        labelFairway4.text = @"";
    }
    
    [picker1 reloadAllComponents];
    
    int totalPar= 0;
    int totalScore = 0;
    
    for(GrintScore* tempscore in [scores objectAtIndex:0]){
        
        if(tempscore.score){
            
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
        }
        
    }
    
    labelScoreSoFar.text = [NSString stringWithFormat:@"(%d)", totalScore];
    labelStrokesSoFar.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    
    
}

- (IBAction)showPicker:(id)sender{
    
    
    if(picker1.isHidden){
        editingScoreIndex = [sender tag];
        
        GrintScore* currentScore = [[scores objectAtIndex: editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])];

        
        if(currentScore.score && currentScore.score.length > 0){
            if([[pickerData objectAtIndex:0]containsObject:currentScore.score]){
                [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.score] inComponent:0 animated:NO];
            }
        }
        else{
            if([[pickerData objectAtIndex:0]containsObject:currentScore.par]){
                [picker1 selectRow:[[pickerData objectAtIndex:0]indexOfObject:currentScore.par] inComponent:0 animated:NO];
            }
        }
        if(currentScore.putts && currentScore.putts.length > 0){
            if([[pickerData objectAtIndex:1]containsObject:currentScore.putts]){
                [picker1 selectRow:[[pickerData objectAtIndex:1]indexOfObject:currentScore.putts] inComponent:1 animated:NO];
            }
        }
        else{
            [picker1 selectRow:2 inComponent:1 animated:NO];
        }
        if(currentScore.penalty && currentScore.penalty.length > 0){
            if([[pickerData objectAtIndex:2] containsObject:currentScore.penalty]){
                [picker1 selectRow:[[pickerData objectAtIndex:2]indexOfObject:currentScore.penalty] inComponent:2 animated:NO];
            }
            else{
                [picker1 selectRow:0 inComponent:2 animated:NO];
            }
        }
        else{
            [picker1 selectRow:0 inComponent:2 animated:NO];
        }
        if(currentScore.fairway && currentScore.fairway.length > 0){
            if([[pickerData objectAtIndex:3]containsObject:currentScore.fairway]){
                [picker1 selectRow:[[pickerData objectAtIndex:3]indexOfObject:currentScore.fairway] inComponent:3 animated:NO];
            }
            else{
                [picker1 selectRow:0 inComponent:3 animated:NO];
            }

        }
        else{
            [picker1 selectRow:0 inComponent:3 animated:NO];
        }
        
        switch (editingScoreIndex){
        
            case 0:
                
                [picker1 setHidden:NO];
                [buttonEnter setHidden:NO];
                
                labelScore1.text = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                
//                if(!labelPutts1.hidden){
                    labelPutts1.text = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
//                }
                
                if(!labelPenalty1.hidden){
                    if([picker1 selectedRowInComponent:2] == 0){
                        labelPenalty1.text = @"";
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                    }
                    else{
                        labelPenalty1.text = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                    }
                }
                
                if(!labelFairway1.hidden){
                    if([[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                        labelFairway1.text = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        
                    }
                    else{
                        labelFairway1.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    }
                }
                
                break;
                
                
            case 1:
                
                [picker1 setHidden:NO];
                [buttonEnter setHidden:NO];
                
                labelScore2.text = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                
//                if(!labelPutts2.hidden){
                    labelPutts2.text = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
//                }
                
                if(!labelPenalty2.hidden){
                    if([picker1 selectedRowInComponent:2] == 0){
                        labelPenalty2.text = @"";
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                    }
                    else{
                        labelPenalty2.text = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                    }
                }
                
                if(!labelFairway2.hidden){
                    if([[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                        labelFairway2.text = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        
                    }
                    else{
                        labelFairway2.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    }
                }
                
                break;
                
                
            case 2:
                
                if(player3 && player3.length > 0){
                    
                    
                    [picker1 setHidden:NO];
                    [buttonEnter setHidden:NO];
                
                labelScore3.text = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                
//                if(!labelPutts3.hidden){
                    labelPutts3.text = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
//                }
                
                if(!labelPenalty3.hidden){
                    if([picker1 selectedRowInComponent:2] == 0){
                        labelPenalty3.text = @"";
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                    }
                    else{
                        labelPenalty3.text = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                    }
                }
                
                if(!labelFairway3.hidden){
                    if([[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                        labelFairway3.text = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        
                    }
                    else{
                        labelFairway3.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    }
                }
                
                }
                
                break;
                
                
            case 3:
                
                
                if(player4 && player4.length > 0){
                    
                    
                    [picker1 setHidden:NO];
                    [buttonEnter setHidden:NO];

                
                labelScore4.text = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:[picker1 selectedRowInComponent:0]];
                
//                if(!labelPutts4.hidden){
                    labelPutts4.text = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:[picker1 selectedRowInComponent:1]];
//               }
                
                if(!labelPenalty4.hidden){
                    if([picker1 selectedRowInComponent:2] == 0){
                        labelPenalty4.text = @"";
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                    }
                    else{
                        labelPenalty4.text = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:[picker1 selectedRowInComponent:2]] substringToIndex:2];
                    }
                }
                
                if(!labelFairway4.hidden){
                    if([[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] isEqualToString:@"Hit"]){
                        labelFairway4.text = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]];
                        
                    }
                    else{
                        labelFairway4.text = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:[picker1 selectedRowInComponent:3]]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                    }
                }
                }
                
                break;
                
                
                
                
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

#define STR_PURCHASE_MESSAGE_PREFIX @"PURCHASE_MULTIPLE"

- (BOOL) getPurchaseStatus
{
    Communication* comm = [[Communication alloc] init];
    NSString* strData = [NSString stringWithFormat:@"check_purchase?user_name=%@&course=%d", username, [courseID integerValue]];
    BOOL FPurchase = [comm getPurchaseState: strData];
    
    return NO;//FPurchase;
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
//        
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
        spinnerView = [SpinnerView loadSpinnerIntoView: self.view];

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

////

- (IBAction)prevHole:(id)sender{
    if (m_FOnByGlance == YES) {
        m_FOnByGlance = NO;
        [self changeGPSState];
    }
    

    currentHole --;
    [self updateHole];

    //added code
//    CGPoint ptCenter = labelGPS.center;
//    ptCenter.y += 7;
//    labelGreenCenter.center = ptCenter;
//    
//    [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
//    [labelExtra setText: @"Tap for"];
//    labelExtra.hidden = NO;
//    labelGPS.text = @"";
//
//    [labelGreenCenter setText: @"GPS"];
//    [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
//
//    //2013.9.11
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
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setBool:YES forKey:@"savedState"];
        [defaults setBool:YES forKey:@"savedState_multiplayer"];
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
        
        for(int i = 0; i < 4; i++){
        
        [defaults setValue:[NSArray arrayWithObjects:
                            [(GrintScore*)[[scores objectAtIndex:i]objectAtIndex:0] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:1] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:2] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:3] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:4] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:5] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:6] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:7] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:8] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:9] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:10] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:11] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:12] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:13] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:14] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:15] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:16] toArray],
                            [(GrintScore*)[[scores objectAtIndex:i] objectAtIndex:17] toArray],
                            nil]  forKey:[NSString stringWithFormat:@"savedState_scores%i", i]];
            
        }
        
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                [defaults setValue:playerData forKey:@"savedState_playerData"];
        
        [defaults setInteger:currentHole forKey:@"savedState_currentHole"];
        
        [defaults synchronize];

        
        
        if(labelScore1.text.length < 1){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 1 Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if (labelPutts1.text.length < 1 && !labelPutts1.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 1 Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if (labelFairway1.text.length < 1 && !labelFairway1.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 1 Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([labelPutts1.text intValue] >= [labelScore1.text intValue]){
            if (labelPutts1.hidden) {
                GrintScore* curScore = ((GrintScore*)[[scores objectAtIndex:0] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]);
                curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
                labelPutts1.text = curScore.putts;
                [self nextScreen: sender];
            } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 1 Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else if(labelScore2.text.length < 1){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 2 Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if (labelPutts2.text.length < 1 && !labelPutts2.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 2 Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if (labelFairway2.text.length < 1 && !labelFairway2.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 2 Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([labelPutts2.text intValue] >= [labelScore2.text intValue]){
            if (labelPutts2.hidden) {
                GrintScore* curScore = ((GrintScore*)[[scores objectAtIndex:1] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]);
                curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
                labelPutts2.text = curScore.putts;
                [self nextScreen: sender];
            } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 2 Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else if(labelScore3.text.length < 1 && !labelScore3.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 3 Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if (labelPutts3.text.length < 1 && !labelPutts3.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 3 Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if (labelFairway3.text.length < 1 && !labelFairway3.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 3 Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([labelPutts3.text intValue] >= [labelScore3.text intValue] && !labelScore3.hidden){
            if (labelPutts3.hidden) {
                GrintScore* curScore = ((GrintScore*)[[scores objectAtIndex:2] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]);
                curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
                labelPutts3.text = curScore.putts;
                [self nextScreen: sender];
            } else {

                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 3 Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else if(labelScore4.text.length < 1 && !labelScore4.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 4 Missing data" message:@"Please enter a score for this hole" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if (labelPutts4.text.length < 1 && !labelPutts4.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 4 Missing data" message:@"You have selected to track putts data - please enter a figure in this field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if (labelFairway4.text.length < 1 && !labelFairway4.hidden){
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 4 Missing data" message:@"You have selected to track accuracy data - please enter a hit or missed fairway" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([labelPutts4.text intValue] >= [labelScore4.text intValue] && !labelScore4.hidden){
            if (labelPutts4.hidden) {
                GrintScore* curScore = ((GrintScore*)[[scores objectAtIndex:3] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]);
                curScore.putts = [NSString stringWithFormat: @"%d", (curScore.score.integerValue - 1)];
                labelPutts4.text = curScore.putts;
                [self nextScreen: sender];
            } else {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Player 4 Putts too high" message:@"Putts can never be same or higher than the score" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
//                [m_LocationManager stopUpdatingLocation];
//                CGPoint ptCenter = labelGPS.center;
//                ptCenter.y += 7;
//                labelGreenCenter.center = ptCenter;
//                
//                [labelExtra setFont: [UIFont fontWithName:@"Oswald" size: 15]];
//                [labelExtra setText: @"Tap for"];
//                labelExtra.hidden = NO;
//                labelGPS.text = @"";
//                [labelGreenCenter setText: @"GPS"];
//                [labelGreenCenter setFont:[UIFont fontWithName:@"Oswald" size: 28]];
                
                gpsMapController.m_nFirstDraw = 1;
                
                /////////////////
            }
            else{
                [self updateHole];
                
//                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
//                
//                [[self navigationItem] setBackBarButtonItem:backButton];
                
                
//                if (!self.detailViewController) {
//                    self.detailViewController = [[GrintBReviewScoreMultiplayer alloc] initWithNibName:@"GrintBReviewScoreMultiplayer" bundle:nil];
//                }
//                
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).teeID = self.teeID;
//                
//                
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).username = self.username;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).courseName= self.courseName;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).courseAddress= self.courseAddress;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).date = self.date;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).score = self.score;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).putts = self.putts;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).penalties = self.penalties;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).accuracy = self.accuracy;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).player1 = self.player1;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).player2 = self.player2;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).player3 = self.player3;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).player4 = self.player4;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).courseID = self.courseID;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).scores = self.scores;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).holeOffset = self.holeOffset;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).playerData = self.playerData;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).isNine = self.isNine;
//                ((GrintBReviewScoreMultiplayer*)self.detailViewController).nineType = self.maxHole > 8 ? @"back" : @"front";
                
                
                [Flurry logEvent:@"playgolf_end"];
                
//                [self.navigationController pushViewController:self.detailViewController animated:YES];
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
        NSArray* temp4 = [NSArray arrayWithObjects:@"Hit",@"Missed Left",@"Missed Right", @"Missed Short", @"Missed Long", @" Shank", nil];
        
        self.pickerData = [NSArray arrayWithObjects:temp1, temp2, temp3, temp4, nil];
        
        self.scores = [NSArray arrayWithObjects:[NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], nil];
        
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
        self.scores = [NSArray arrayWithObjects:[NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], [NSArray arrayWithObjects:[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init],[[GrintScore alloc]init], nil], nil];

        
    }
    
    labelUsername1.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(player2 && player2.length > 0)
    labelUsername2.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(player3 && player3.length > 0)
    labelUsername3.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(player4 && player4.length > 0)
    labelUsername4.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    
    [labelUsername1 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername2 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername3 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername4 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    
    [self updateHole];
    self.navigationController.navigationBar.hidden = YES;
    [m_LocationManager startUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /// updated code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseResult:) name:STR_PURCHASE_MESSAGE_PREFIX object:nil];
    /////////////

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

    
    [buttonPrev.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [buttonPrev.layer setCornerRadius:5.0f];
    [buttonNext.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [buttonNext.layer setCornerRadius:5.0f];
    [buttonEnter.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [buttonEnter.layer setCornerRadius:5.0f];
    
    [labelHoleNo setFont:[UIFont fontWithName:@"Oswald" size:24]];
    
    [labelScore1.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPutts1.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPenalty1.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelFairway1.layer setCornerRadius: labelScore1.bounds.size.width/2];
    
    [labelScore2.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPutts2.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPenalty2.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelFairway2.layer setCornerRadius: labelScore1.bounds.size.width/2];
    
    [labelScore3.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPutts3.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPenalty3.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelFairway3.layer setCornerRadius: labelScore1.bounds.size.width/2];
    
    [labelScore4.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPutts4.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelPenalty4.layer setCornerRadius: labelScore1.bounds.size.width/2];
    [labelFairway4.layer setCornerRadius: labelScore1.bounds.size.width/2];
    
    [labelScore1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPenalty1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelFairway1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelScore2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPenalty2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelFairway2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelScore3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPenalty3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelFairway3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelScore4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPutts4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelPenalty4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelFairway4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];

    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label5 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label9 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label10 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    
    [labelStrokesSoFar setFont:[UIFont fontWithName:@"Oswald" size:30.0]];
    [labelScoreSoFar setFont:[UIFont fontWithName:@"Oswald" size:15.0]];
    
    currentHole = 0;
    
    // [self updateHole];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(displayStats:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/holedata_iphone_new_multiplayer"]];
    NSString* requestBody = [NSString stringWithFormat:@"username1=%@&username2=%@&username3=%@&username4=%@&course_id=%d&teeid=%@", self.player1, self.player2, self.player3, self.player4, [self.courseID intValue], self.teeID];
    if(self.numberHoles < 10){
        requestBody = [requestBody stringByAppendingString:@"&is_nine=1"];
    }
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection ) {
        data = [NSMutableData data];
        if (spinnerView == nil)
            spinnerView = [SpinnerView loadSpinnerIntoView: self.view];

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

            [[self navigationController]popViewControllerAnimated:YES];
            
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
            
            switch (editingScoreIndex) {
                case 0:
                    labelScore1.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    ////2013.9.11
                    [self calcTotalScore];
                    ///////////

                    break;
                case 1:
                    labelScore2.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    break;
                case 2:
                    labelScore3.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    break;
                case 3:
                    labelScore4.text = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).score = [[pickerData objectAtIndex:0] objectAtIndex:row];
                    break;
                    
            }
            break;
        case 1:
            switch (editingScoreIndex) {
                    
                case 0:
                    if(!labelPutts1.hidden){
//                        NSString* strPutts = [[pickerData objectAtIndex:1] objectAtIndex:row];
//                        if (labelScore1.text.integerValue <= strPutts.integerValue) {
//                            labelPutts1.text = [[pickerData objectAtIndex:1] objectAtIndex:0];
//                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Putts too high" message: @"Putts can never be same or higher than the score" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                            [alertView show];
//                            return;
//                        }

                        labelPutts1.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
                    }
                    break;
                    
                case 1:
                    if(!labelPutts2.hidden){
//                        NSString* strPutts = [[pickerData objectAtIndex:1] objectAtIndex:row];
//                        if (labelScore2.text.integerValue <= strPutts.integerValue) {
//                            labelPutts2.text = [[pickerData objectAtIndex:1] objectAtIndex:0];
//                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Putts too high" message: @"Putts can never be same or higher than the score" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                            [alertView show];
//                            return;
//                        }

                        labelPutts2.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
                    }
                    break;
                    
                case 2:
                    if(!labelPutts3.hidden){
//                        NSString* strPutts = [[pickerData objectAtIndex:1] objectAtIndex:row];
//                        if (labelScore3.text.integerValue <= strPutts.integerValue) {
//                            labelPutts3.text = [[pickerData objectAtIndex:1] objectAtIndex:0];
//                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Putts too high" message: @"Putts can never be same or higher than the score" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                            [alertView show];
//                            return;
//                        }

                        labelPutts3.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
                    }
                    break;
                    
                case 3:
                    if(!labelPutts4.hidden){
//                        NSString* strPutts = [[pickerData objectAtIndex:1] objectAtIndex:row];
//                        if (labelScore4.text.integerValue <= strPutts.integerValue) {
//                            labelPutts4.text = [[pickerData objectAtIndex:1] objectAtIndex:0];
//                            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Putts too high" message: @"Putts can never be same or higher than the score" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
//                            [alertView show];
//                            return;
//                        }

                        labelPutts4.text = [[pickerData objectAtIndex:1] objectAtIndex:row];
                        ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).putts = [[pickerData objectAtIndex:1] objectAtIndex:row];
                    }
                    break;
                    
                    
            }
           
            break;
        case 2:
            
            switch (editingScoreIndex) {
                case 0:
                    if(!labelPenalty1.hidden){
                        if(row == 0){
                            labelPenalty1.text = @"";
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                        }
                        else{
                            labelPenalty1.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                        }
                    }
                    
                    break;
                    
                case 1:
                    if(!labelPenalty2.hidden){
                        if(row == 0){
                            labelPenalty2.text = @"";
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                        }
                        else{
                            labelPenalty2.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                        }
                    }
                    
                    break;
                    
                case 2:
                    if(!labelPenalty3.hidden){
                        if(row == 0){
                            labelPenalty3.text = @"";
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                        }
                        else{
                            labelPenalty3.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                        }
                    }
                    
                    break;
                    
                case 3:
                    if(!labelPenalty4.hidden){
                        if(row == 0){
                            labelPenalty4.text = @"";
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = @"";
                        }
                        else{
                            labelPenalty4.text = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).penalty = [[[pickerData objectAtIndex:2] objectAtIndex:row] substringToIndex:2];
                        }
                    }
                    
                    break;
                    
            }
           
            break;
        case 3:
            
            switch (editingScoreIndex) {
                case 0:
                    if(!labelFairway1.hidden){
                        if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                            labelFairway1.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            
                        }
                        else{
                            labelFairway1.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        }
                    }
                    break;
                case 1:
                    if(!labelFairway2.hidden){
                        if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                            labelFairway2.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            
                        }
                        else{
                            labelFairway2.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        }
                    }
                    break;
                case 2:
                    if(!labelFairway3.hidden){
                        if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                            labelFairway3.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            
                        }
                        else{
                            labelFairway3.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        }
                    }
                    break;
                case 3:
                    if(!labelFairway4.hidden){
                        if([[[pickerData objectAtIndex:3] objectAtIndex:row] isEqualToString:@"Hit"]){
                            labelFairway4.text = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[pickerData objectAtIndex:3] objectAtIndex:row];
                            
                        }
                        else{
                            labelFairway4.text = [[[[pickerData objectAtIndex:3] objectAtIndex:row] componentsSeparatedByString:@" "]objectAtIndex:1 ];
                            ((GrintScore*)[[scores objectAtIndex:editingScoreIndex] objectAtIndex:(currentHole + [holeOffset intValue]) > maxHole? (currentHole + [holeOffset intValue] - (numberHoles + 1)) : (currentHole + [holeOffset intValue])]).fairway = [[[[pickerData objectAtIndex:3] objectAtIndex:row]  componentsSeparatedByString:@" "]objectAtIndex:1 ];
                        }
                    }
                    break;
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
    [pickerLabel setTextAlignment:UITextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    if(component == 0){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    }
    else if(component == 1){
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        if(labelPutts1.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
    }
    else if(component == 2){
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        
        if(labelPenalty1.isHidden){
            [pickerLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8]];
        }
        else{
            [pickerLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
        }
        
    }
    else{
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        if(labelFairway1.isHidden){
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
    
    return [[pickerData objectAtIndex:component] count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[pickerData objectAtIndex:component] objectAtIndex:row];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (currentHole == [holeOffset integerValue])
        self.navigationController.navigationBar.hidden = NO;
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
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

- (IBAction)gotToNext:(id)sender {
    [self nextScreen: sender];
}

- (IBAction)goToPrev:(id)sender {
    [self swipeRightDetected: self];
}

/////2013.9.11

- (void) calcTotalScore
{
    int nTotalScore = 0;
    int nStroke = 0;
    for (GrintScore* curScore in [self.scores objectAtIndex: 0]) {
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
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:strTitle delegate:self cancelButtonTitle: @"Not now, thanks!" otherButtonTitles: @"$0.99 Unlimited access to this Map", @"One Hole Sneak Peek!", nil];
//    [alertView show];
}


- (void) processWithIAP
{
    if (m_FEnableGPS == NO) {
//        NSString* strTitle = @"Get accurate GPS Maps and \n distances for this golf course";
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"$0.99 Unlimited access to this Map", @"Not now, thanks!", @"", nil];
//        [[alertView viewWithTag: 3] removeFromSuperview];
//        CGRect rect = alertView.bounds;
//        rect.size.height -= 30;
//        [alertView setBounds: rect];
//        [alertView show];
        [self showAlertView];
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

- (BOOL) isCompleteToInputByIndex: (NSInteger) nIdx
{
    int nCount = 0;
    for (GrintScore* curScore in [self.scores objectAtIndex: nIdx]) {
        int nScore = [curScore.score integerValue];
        if (nScore > 0)
            nCount ++;
    }
    if (nCount < self.numberHoles + 1)
        return NO;
    
    return YES;
}

- (BOOL) isCompleteToInput
{
    BOOL FState = [self isCompleteToInputByIndex: 0];
    if (!FState)
        return NO;
    if (player2 && player2.length > 0) {
        FState = [self isCompleteToInputByIndex: 1];
        if (!FState)
            return NO;
    }
    if (player3 && player3.length > 0) {
        FState = [self isCompleteToInputByIndex: 2];
        if (!FState)
            return NO;
    }
    if (player4 && player4.length > 0) {
        FState = [self isCompleteToInputByIndex: 3];
        if (!FState)
            return NO;
    }
    return YES;
}

- (void) showScoreView
{
    if (!self.detailViewController) {
        if ([UIScreen mainScreen].bounds.size.height > 490 || [UIScreen mainScreen].bounds.size.width > 490) {
            self.detailViewController = [[GrintBNewMultiReviewScore alloc] initWithNibName:@"GrintBNewMultiReviewScore5" bundle:nil];
        } else {
            self.detailViewController = [[GrintBNewMultiReviewScore alloc] initWithNibName:@"GrintBNewMultiReviewScore" bundle:nil];
        }
    }
    self.detailViewController.m_strCourseName = self.courseName;
    self.detailViewController.m_scores = self.scores;
    
    self.detailViewController.FComplete = [self isCompleteToInput];

    self.detailViewController.teeID = self.teeID;


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
    self.detailViewController.playerData = self.playerData;
    self.detailViewController.isNine = self.isNine;
    self.detailViewController.nineType = self.maxHole > 8 ? @"back" : @"front";
    
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

    [self changeGPSState];}

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