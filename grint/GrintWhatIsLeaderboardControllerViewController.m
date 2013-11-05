//
//  GrintWhatIsLeaderboardControllerViewController.m
//  grint
//
//  Created by Peter Rocker on 22/05/2013.
//
//

#import "GrintWhatIsLeaderboardControllerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GrintWhatIsLeaderboardControllerViewController ()

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView1;
@property (nonatomic, retain) IBOutlet UILabel* label1;
@property (nonatomic, retain) IBOutlet UILabel* label2;
@property (nonatomic, retain) IBOutlet UILabel* label3;
@property (nonatomic, retain) IBOutlet UILabel* label4;
@property (nonatomic, retain) IBOutlet UILabel* label5;
@property (nonatomic, retain) IBOutlet UIButton* button1;

@end

@implementation GrintWhatIsLeaderboardControllerViewController

- (IBAction)backClick:(id)sender{
    
    [self.delegate dismissModalViewControllerAnimated:YES];
    
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
    _scrollView1.contentSize = CGSizeMake(320, 568);
    [_button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_button1.layer setCornerRadius:5.0f];
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_label2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_label3 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_label4 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_label5 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
