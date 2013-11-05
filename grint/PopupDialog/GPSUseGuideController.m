//
//  GPSUseGuideController.m
//  grint
//
//  Created by Passioner on 9/18/13.
//
//

#import "GPSUseGuideController.h"

@interface GPSUseGuideController ()

@end

@implementation GPSUseGuideController

@synthesize m_label1, m_label2, m_label3, m_label4, m_labelTitle, m_parentController;

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
    
    [m_labelTitle setFont: [UIFont fontWithName: @"CALIBRI" size: 18]];
    [m_label1 setFont: [UIFont fontWithName: @"CALIBRI" size: 16]];
    [m_label2 setFont: [UIFont fontWithName: @"CALIBRI" size: 16]];
    [m_label3 setFont: [UIFont fontWithName: @"CALIBRI" size: 16]];
    [m_label4.titleLabel setFont: [UIFont fontWithName: @"CALIBRI" size: 16]];
    
}

- (void) dealloc
{
    [super dealloc];
    
    [m_labelTitle release];
    [m_label1 release];
    [m_label2 release];
    [m_label3 release];
    [m_label4 release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCancel:(id)sender {
    [self.overlayController dismissOverlay: YES];
}

- (IBAction)actionDontShow:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: @"1" forKey: @"first_gps_state"];
    [defaults synchronize];
    
    if (m_parentController && [m_parentController canPerformAction:@selector(gpsOnProcess) withSender:nil]) {
        [m_parentController performSelector: @selector(gpsOnProcess) withObject:nil afterDelay:0.01];
//        [NSThread detachNewThreadSelector: @selector(gpsOnProcess) toTarget: m_parentController withObject: nil];
    }
    
    [self.overlayController dismissOverlay: YES];
}

- (IBAction)actionContinue:(id)sender {
    if (m_parentController && [m_parentController canPerformAction:@selector(gpsOnProcess) withSender:nil]) {
        [m_parentController performSelector: @selector(gpsOnProcess) withObject:nil afterDelay:0.01];
//        [NSThread detachNewThreadSelector: @selector(gpsOnProcess) toTarget: m_parentController withObject: nil];
    }

    [self.overlayController dismissOverlay: YES];
}


@end
