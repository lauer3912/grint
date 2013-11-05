//
//  MapperActionSheet.m
//  grint
//
//  Created by Mountain on 10/8/13.
//
//

#import "MapperActionSheet.h"

@interface MapperActionSheet ()

@end

@implementation MapperActionSheet

@synthesize delegate;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionMakeMap:(id)sender {
    
    [self.overlayController dismissOverlay: YES];
    
    if (delegate && [delegate respondsToSelector: @selector(acceptMakeMap)])
        [delegate acceptMakeMap];
}

- (IBAction)actionCancel:(id)sender {
    [self.overlayController dismissOverlay: YES];
}
@end
