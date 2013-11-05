//
//  GrintWebModalViewController.m
//  grint
//
//  Created by Peter Rocker on 17/01/2013.
//
//

#import "GrintWebModalViewController.h"
#import "SpinnerView.h"

@interface GrintWebModalViewController ()

@end

@implementation GrintWebModalViewController
{
    SpinnerView* spinView;
}

@synthesize delegate, webView1, m_strURL, m_FFirst;


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, self.view.frame.size.width, 320.0);
}

- (IBAction)backClick:(id)sender{
    //[self dismissViewControllerAnimated:YES completion: nil];
    [self.navigationController popViewControllerAnimated: YES];
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
    self.webView1.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (!m_FFirst) {
        [self.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_strURL]]];
        self.webView1.scalesPageToFit = YES;
        
        spinView = [SpinnerView loadSpinnerIntoView: self.view];
        m_FFirst = YES;
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    if (spinView) {
        [spinView removeSpinner];
        spinView = nil;
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (spinView) {
        [spinView removeSpinner];
        spinView = nil;
    }    
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
