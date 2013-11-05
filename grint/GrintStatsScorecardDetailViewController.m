//
//  GrintStatsScorecardDetailViewController.m
//  grint
//
//  Created by Peter Rocker on 12/12/2012.
//
//

#import "GrintStatsScorecardDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintScore.h"
#import "GrintStatsScorecardDetailViewController2.h"

@interface GrintStatsScorecardDetailViewController ()

@end

@implementation GrintStatsScorecardDetailViewController

@synthesize scores, username, nameString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewWillAppear:(BOOL)animated{
    
    //NSLog(self.courseName);
    
    [super viewWillAppear:animated];
    [label1 setText:scores.courseName];
    self.navigationController.navigationBar.hidden = YES;
    
    for(int i = 100; i <= 500; i += 100){
        
        float total = 0;
        
        for(int j = 0; j <= 18; j++){
            
            if(i != 100){
                
                [self.view viewWithTag:i + j].layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
                [self.view viewWithTag:i + j].layer.borderWidth = 1.0;
            }
            
            if(i == 100){
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scores.scores objectAtIndex:j]).par;
                    total += [((GrintScore*)[scores.scores objectAtIndex:j]).par intValue];
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            else if(i == 200){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scores.scores objectAtIndex:j]).score;
                    total += [((GrintScore*)[scores.scores objectAtIndex:j]).score intValue];
                }
                else{
                    
                    if(scores.isShort && [scores.isShort isEqualToString:@"1"]){
                        total = [scores.shortScore floatValue];
                    }
                    
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
                
                if(!((UILabel*)[self.view viewWithTag:200 + j]).text){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                    
                }
                else if( [((UILabel*)[self.view viewWithTag:200 + j]).text intValue] ==  [((UILabel*)[self.view viewWithTag:100 + j]).text intValue] ){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:0.12 green:0.32 blue:0.37 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                }
                else if([((UILabel*)[self.view viewWithTag:200 + j]).text intValue] <  [((UILabel*)[self.view viewWithTag:100 + j]).text intValue] ){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                }
                else{
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                    
                }
                
            }
            else if(i == 300){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scores.scores objectAtIndex:j]).putts;
                    total += [((GrintScore*)[scores.scores objectAtIndex:j]).putts intValue];
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
                
                
            }
            
            else if(i == 400){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scores.scores objectAtIndex:j]).penalty;
                    if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"S "]) {
                        total += 0.5;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"F"]) {
                        total += 0.5;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"W"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"O"]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"D"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"SS"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"FF"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"WW"]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"OO"]) {
                        total += 4;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"DD"]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"FS"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"WS"]) {
                        total += 1.5;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"OS"]) {
                        total += 2.5;
                    }
                    else if([((GrintScore*)[scores.scores objectAtIndex:j]).penalty isEqualToString:@"DS"]) {
                        total += 1.5;
                    }
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            else if(i == 500){
                
                if(j <= 17){
                    
                 /*   if([((UILabel*)[self.view viewWithTag:100 + j]).text isEqualToString:@"3"]){
                        [self.view viewWithTag:i + j].layer.borderWidth = 0.0;
                    }*/
                    
                    if(((GrintScore*)[scores.scores objectAtIndex:j]).fairway.length < 1){
                        ((GrintScore*)[scores.scores objectAtIndex:j]).fairway = @" ";
                    }
                    
                    ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    if([[((GrintScore*)[scores.scores objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"3"]){
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @"✔";
                        //          ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.12 green:0.32 blue:0.37 alpha:1.0];
                    }
                    else if([[((GrintScore*)[scores.scores objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"1"]){
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @"◀";
                        //          ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                    }
                    else if([[((GrintScore*)[scores.scores objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"2"]){
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @"▶";
                        //         ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                    }
                    else if([[((GrintScore*)[scores.scores objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"4"]){
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @"▼";
                        //         ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                    }
                    else{
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @" ";
                    }
                    
                    if([[((GrintScore*)[scores.scores objectAtIndex:j]).fairway substringToIndex:1]isEqualToString:@"3"]) {
                        total++;
                    }
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, 460.0, 320.0);
   
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeUpDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    furtherStatsEnabled = YES;
}

- (void) disableFurtherStats{
    
    furtherStatsEnabled = NO;
    imageView1.image = [UIImage imageNamed:@""];
    
}

- (void)swipeUpDetected:(id)sender{
    
    if(furtherStatsEnabled){
    
    GrintStatsScorecardDetailViewController2* controller = [[GrintStatsScorecardDetailViewController2 alloc]initWithNibName:@"GrintStatsScorecardDetailViewController2" bundle:nil];
    controller.courseID = [NSNumber numberWithInt:[self.scores.courseId intValue]];
    controller.courseName = self.scores.courseName;
    controller.username = self.username;
    controller.delegate = self;
    controller.date = scores.date;
    [self.navigationController pushViewController:controller animated:YES];
        
    }
}

- (void)swipeRightDetected:(id)sender{
    
    [[self navigationController]popViewControllerAnimated:YES];
    
}

@end
