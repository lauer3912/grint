//
//  GrintBWriteScoreMultiplayerStats.m
//  grint
//
//  Created by Peter Rocker on 03/12/2012.
//
//

#import "GrintBWriteScoreMultiplayerStats2.h"
#import "GrintScore.h"
#import <QuartzCore/QuartzCore.h>

@interface GrintBWriteScoreMultiplayerStats2 ()

@end

@implementation GrintBWriteScoreMultiplayerStats2

@synthesize holeData, holeNumber, holeParYds, username1, username2, username3, username4, delegate, playerData, scores;

- (void)backClick:(id)sender{
    
    [delegate dismissModalViewControllerAnimated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    labelHoleNo.text = holeNumber;
    labelHoleParYds.text = holeParYds;
    
    /*labelScoreOverPar1.text = ((GrintScore*)[holeData objectAtIndex:0]).stats;
    labelTotalStrokes1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsTotalStrokes;
    labelFrontNine1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsFrontNine;
    labelBackNine1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsBackNine;
    
    labelScoreOverPar2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsAvgScore;
    labelTotalStrokes2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsTotalStrokes;
    labelFrontNine2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsFrontNine;
    labelBackNine2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsBackNine;
    
    labelScoreOverPar3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsAvgScore;
    labelTotalStrokes3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsTotalStrokes;
    labelFrontNine3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsFrontNine;
    labelBackNine3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsBackNine;
    
    labelScoreOverPar4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsAvgScore;
    labelTotalStrokes4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsTotalStrokes;
    labelFrontNine4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsFrontNine;
    labelBackNine4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsBackNine;*/
        
    labelUsername1.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username2 && username2.length > 0)
        labelUsername2.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username3 && username3.length > 0)
        labelUsername3.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username4 && username4.length > 0)
        labelUsername4.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    
    if(username3.length < 1){
        labelUsername3.hidden = YES;
        labelScoreOverPar3.hidden = YES;
        labelTotalStrokes3.hidden = YES;
        labelFrontNine3.hidden = YES;
        labelBackNine3.hidden = YES;
        
    }
    if(username4.length < 1){
        labelUsername4.hidden = YES;
        labelScoreOverPar4.hidden = YES;
        labelTotalStrokes4.hidden = YES;
        labelFrontNine4.hidden = YES;
        labelBackNine4.hidden = YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(backClick:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(backClick:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(backClick:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(backClick:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
        
    [labelScoreOverPar1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTotalStrokes1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelFrontNine1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelBackNine1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [labelScoreOverPar2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTotalStrokes2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelFrontNine2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelBackNine2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [labelScoreOverPar3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTotalStrokes3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelFrontNine3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelBackNine3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [labelScoreOverPar4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTotalStrokes4 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelFrontNine4 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [labelBackNine4 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [labelUsername1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:12.0]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:10]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:10]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:10]];
    
    [labelHoleNo setFont:[UIFont fontWithName:@"Oswald" size:28]];
    
    
    /*calculate stuff*/
    
    int totalPar = 0;
    int totalScore = 0;
    int frontNine = 0;
    int backNine = 0;
    
    NSArray* player = [scores objectAtIndex:0];
    
    for(GrintScore* tempscore in player){
        
        if(tempscore.score && tempscore.score.length > 0){
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
            
            if([player indexOfObject:tempscore] < 9){
                frontNine += [tempscore.score intValue];
            }
            else{
                backNine += [tempscore.score intValue];
            }
            
        }
        
    }
    
    labelTotalStrokes1.text = [NSString stringWithFormat:@"%d", totalScore];
    labelScoreOverPar1.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    labelFrontNine1.text = [NSString stringWithFormat:@"%d", frontNine];
    labelBackNine1.text = [NSString stringWithFormat:@"%d", backNine];
    
    player = [scores objectAtIndex:1];
    
    
    totalPar = 0;
    totalScore = 0;
    frontNine = 0;
    backNine = 0;
    
    for(GrintScore* tempscore in player){
        
        if(tempscore.score && tempscore.score.length > 0){
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
            
            if([player indexOfObject:tempscore] < 9){
                frontNine += [tempscore.score intValue];
            }
            else{
                backNine += [tempscore.score intValue];
            }
            
        }
        
    }
    
    labelTotalStrokes2.text = [NSString stringWithFormat:@"%d", totalScore];
    labelScoreOverPar2.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    labelFrontNine2.text = [NSString stringWithFormat:@"%d", frontNine];
    labelBackNine2.text = [NSString stringWithFormat:@"%d", backNine];
    
    player = [scores objectAtIndex:2];
    
    totalPar = 0;
    totalScore = 0;
    frontNine = 0;
    backNine = 0;
    
    for(GrintScore* tempscore in player){
        
        if(tempscore.score && tempscore.score.length > 0){
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
            
            if([player indexOfObject:tempscore] < 9){
                frontNine += [tempscore.score intValue];
            }
            else{
                backNine += [tempscore.score intValue];
            }
            
        }
        
    }
    
    labelTotalStrokes3.text = [NSString stringWithFormat:@"%d", totalScore];
    labelScoreOverPar3.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    labelFrontNine3.text = [NSString stringWithFormat:@"%d", frontNine];
    labelBackNine3.text = [NSString stringWithFormat:@"%d", backNine];
    
    player = [scores objectAtIndex:3];
    
    totalPar = 0;
    totalScore = 0;
    frontNine = 0;
    backNine = 0;
    
    for(GrintScore* tempscore in player){
        
        if(tempscore.score && tempscore.score.length > 0){
            totalPar += [tempscore.par intValue];
            totalScore += [tempscore.score intValue];
            
            if([player indexOfObject:tempscore] < 9){
                frontNine += [tempscore.score intValue];
            }
            else{
                backNine += [tempscore.score intValue];
            }
            
        }
        
    }
    
    labelTotalStrokes4.text = [NSString stringWithFormat:@"%d", totalScore];
    labelScoreOverPar4.text = [NSString stringWithFormat:@"%@%d", (totalScore - totalPar) >= 0 ? @"+" : @"",totalScore - totalPar];
    labelFrontNine4.text = [NSString stringWithFormat:@"%d", frontNine];
    labelBackNine4.text = [NSString stringWithFormat:@"%d", backNine];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
