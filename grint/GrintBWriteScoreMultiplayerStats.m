//
//  GrintBWriteScoreMultiplayerStats.m
//  grint
//
//  Created by Peter Rocker on 03/12/2012.
//
//

#import "GrintBWriteScoreMultiplayerStats.h"
#import "GrintBWriteScoreMultiplayerStats2.h"
#import "GrintScore.h"
#import <QuartzCore/QuartzCore.h>

@interface GrintBWriteScoreMultiplayerStats ()

@end

@implementation GrintBWriteScoreMultiplayerStats

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
    
    labelAvgScore1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsAvgScore;
    labelAvgPutts1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsAvgPutts;
    labelAvgPenalty1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsAvgPenalty;
    labelTeeAccuracy1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsTeeAccuracy;
    labelAvgGir1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsAvgGir;
    labelGrints1.text = ((GrintScore*)[holeData objectAtIndex:0]).statsGrints;
    
    labelAvgScore2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsAvgScore;
    labelAvgPutts2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsAvgPutts;
    labelAvgPenalty2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsAvgPenalty;
    labelTeeAccuracy2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsTeeAccuracy;
    labelAvgGir2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsAvgGir;
    labelGrints2.text = ((GrintScore*)[holeData objectAtIndex:1]).statsGrints;
    
    labelAvgScore3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsAvgScore;
    labelAvgPutts3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsAvgPutts;
    labelAvgPenalty3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsAvgPenalty;
    labelTeeAccuracy3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsTeeAccuracy;
    labelAvgGir3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsAvgGir;
    labelGrints3.text = ((GrintScore*)[holeData objectAtIndex:2]).statsGrints;
    
    labelAvgScore4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsAvgScore;
    labelAvgPutts4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsAvgPutts;
    labelAvgPenalty4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsAvgPenalty;
    labelTeeAccuracy4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsTeeAccuracy;
    labelAvgGir4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsAvgGir;
    labelGrints4.text = ((GrintScore*)[holeData objectAtIndex:3]).statsGrints;
    
    
    [labelAvgScore1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints1 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints2 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints3 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints4 setFont: [UIFont fontWithName:@"Oswald" size:23.0]];

    [labelUsername1 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername2 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername3 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    [labelUsername4 setFont:[UIFont fontWithName:@"Oswald" size:23]];
    
    labelUsername1.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:0]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username2 && username2.length > 0)
        labelUsername2.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:1]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username3 && username3.length > 0)
        labelUsername3.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:2]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];
    if(username4 && username4.length > 0)
        labelUsername4.text = [NSString stringWithFormat:@"%@%@", [[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"fname"]substringToIndex:1] uppercaseString],[[(NSString*)[[playerData objectAtIndex:3]valueForKey:@"lname"]substringToIndex:1] uppercaseString] ];

    if(username3.length < 1){
        labelUsername3.hidden = YES;
        labelAvgScore3.hidden = YES;
        labelAvgPutts3.hidden = YES;
        labelAvgPenalty3.hidden = YES;
        labelTeeAccuracy3.hidden = YES;
        labelAvgGir3.hidden = YES;
        labelGrints3.hidden = YES;
        
    }
    if(username4.length < 1){
        labelUsername4.hidden = YES;
        labelAvgScore4.hidden = YES;
        labelAvgPutts4.hidden = YES;
        labelAvgPenalty4.hidden = YES;
        labelTeeAccuracy4.hidden = YES;
        labelAvgGir4.hidden = YES;
        labelGrints4.hidden = YES;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)nextSwipe:(id)sender{
    
    GrintBWriteScoreMultiplayerStats2* controller = [[GrintBWriteScoreMultiplayerStats2 alloc]initWithNibName:@"GrintBWriteScoreMultiplayerStats2" bundle:nil];
    controller.holeData = holeData;
    controller.holeNumber = holeNumber;
    controller.holeParYds = holeParYds;
    controller.username1 = username1;
    controller.username2 = username2;
    controller.username3 = username3;
    controller.username4 = username4;
    controller.playerData = self.playerData;
        
    controller.scores = scores;
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];

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
  
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextSwipe:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(backClick:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [labelAvgScore1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPutts1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPenalty1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelTeeAccuracy1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgGir1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelGrints1.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    
    [labelAvgScore2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPutts2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPenalty2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelTeeAccuracy2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgGir2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelGrints2.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    
    [labelAvgScore3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPutts3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPenalty3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelTeeAccuracy3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgGir3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelGrints3.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    
    [labelAvgScore4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPutts4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgPenalty4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelTeeAccuracy4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelAvgGir4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    [labelGrints4.layer setCornerRadius: labelAvgGir1.bounds.size.width/2];
    
    [labelAvgScore1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelAvgScore4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPutts4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgPenalty4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelTeeAccuracy4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelAvgGir4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelGrints4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    
    [labelUsername1 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername2 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername3 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [labelUsername4 setFont:[UIFont fontWithName:@"Oswald" size:23.0]];
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18.0]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label4 setFont:[UIFont fontWithName:@"Oswald" size:18]];

    [labelHoleNo setFont:[UIFont fontWithName:@"Oswald" size:28]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
