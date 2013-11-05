//
//  GrintStatsSelectViewController.m
//  grint
//
//  Created by Peter Rocker on 05/12/2012.
//
//

#import "GrintStatsSelectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintCheckStatsViewController.h"
#import "GrintStatsHandicapsViewController.h"
#import "GrintStatsSelectScoreViewController.h"
#import "GrintWebModalViewController.h"
#import "ReviewLeaderboardViewController.h"

#import "StatsController.h"

@interface GrintStatsSelectViewController ()

@end

@implementation GrintStatsSelectViewController

@synthesize username, nameString, lastName;


- (IBAction)button1Click:(id)sender{
 
//    GrintCheckStatsViewController* controller = [[GrintCheckStatsViewController alloc]initWithNibName:@"GrintCheckStatsViewController" bundle:nil];
//    controller.username = username;
//    controller.nameString = nameString;
//    [self.navigationController pushViewController:controller animated:YES];

    StatsController* controller = [[StatsController alloc]initWithNibName:@"StatsController" bundle:nil];
    controller.username = username;
    controller.nameString = nameString;
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)button2Click:(id)sender{
   
    GrintStatsSelectScoreViewController* controller = [[GrintStatsSelectScoreViewController alloc]initWithNibName:@"GrintStatsSelectScoreViewController" bundle:nil];
    controller.username = username;
    controller.nameString = nameString;
    controller.lastName = lastName;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)button3Click:(id)sender{
    
    GrintStatsHandicapsViewController* controller = [[GrintStatsHandicapsViewController alloc]initWithNibName:@"GrintStatsHandicapsViewController" bundle:nil];
    controller.username = username;
    controller.nameString = nameString;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}


- (IBAction)button4Click:(id)sender{
    
    ReviewLeaderboardViewController* controller = [[ReviewLeaderboardViewController alloc]initWithNibName:@"ReviewLeaderboardViewController" bundle:nil];
    controller.nameString = self.nameString;
    //controller.lastName = self.lastName;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button2.layer setCornerRadius:5.0f];
    [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button3.layer setCornerRadius:5.0f];
    [button4.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button4.layer setCornerRadius:5.0f];
    [button5.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button5.layer setCornerRadius:5.0f];
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[label1 setText:[nameString uppercaseString]];
    
    [label1 setText:@"STATS AND HANDICAP LOOKUP"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
