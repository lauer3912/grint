//
//  GrintHowSPSWorksViewController.m
//  grint
//
//  Created by Peter Rocker on 24/04/2013.
//
//

#import "GrintHowSPSWorksViewController.h"
#import "GrintCourseDownload.h"

@interface GrintHowSPSWorksViewController ()

@end

@implementation GrintHowSPSWorksViewController

- (IBAction)dontShowAgain:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    GrintCourseDownload* detailViewController = [[GrintCourseDownload alloc] initWithNibName:@"GrintCourseDownload" bundle:nil];
    
    detailViewController.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"sps_dont_show_again"];
    
}

- (IBAction)gotToScorecardShoot:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    GrintCourseDownload* detailViewController = [[GrintCourseDownload alloc] initWithNibName:@"GrintCourseDownload" bundle:nil];
    
    detailViewController.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"Instructions";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(gotToScorecardShoot:)];
    [self.navigationItem setRightBarButtonItem:button];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    //[label2 setFont:[UIFont fontWithName:@"Merriweather-Bold" size:14]];
    
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:20]];
    
    [label3.layer setCornerRadius:label3.bounds.size.width / 2];
    [label3  setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [label4.layer setCornerRadius:label3.bounds.size.width / 2];
    [label4  setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [label5.layer setCornerRadius:label3.bounds.size.width / 2];
    [label5  setFont: [UIFont fontWithName:@"Oswald" size:23.0]];
    [label6 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label7 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [label8 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:15]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:15]];
    [button2.layer setCornerRadius:5.0f];
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
