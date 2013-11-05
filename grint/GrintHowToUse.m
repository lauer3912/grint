//
//  GrintHowToUse.m
//  grint
//
//  Created by Peter Rocker on 02/11/2012.
//
//

#import "GrintHowToUse.h"

@interface GrintHowToUse ()

@end

@implementation GrintHowToUse

@synthesize delegate;

- (IBAction)backClick:(id)sender{

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstrunHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
}


- (void)swipeRightDetected:(id)sender{
    
    [delegate dismissModalViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
