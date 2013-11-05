//
//  GrintWhatIsThisController.m
//  grint
//
//  Created by Peter Rocker on 31/10/2012.
//
//

#import "GrintWhatIsThisController.h"
#import "GrintDetailViewController.h"

@interface GrintWhatIsThisController ()

@end

@implementation GrintWhatIsThisController

@synthesize delegate;

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
    
    UIImageView* imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"howto.png"]];
    
    [scrollView1 addSubview:imageView1];
    scrollView1.contentSize = CGSizeMake(imageView1.bounds.size.width, imageView1.bounds.size.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
