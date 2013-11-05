//
//  GrintVerticalWebModalViewController.m
//  grint
//
//  Created by Peter Rocker on 23/04/2013.
//
//

#import "GrintVerticalWebModalViewController.h"

@interface GrintVerticalWebModalViewController ()

@end

@implementation GrintVerticalWebModalViewController

@synthesize delegate, webView1;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (IBAction)backClick:(id)sender{
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
    webView1 = _webView1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end