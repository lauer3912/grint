//
//  CreateLeaderboardViewController.m
//  grint
//
//  Created by Peter Rocker on 08/05/2013.
//
//

#import "CreateLeaderboardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintBCourseDownload.h"

@interface CreateLeaderboardViewController ()

@property (strong, nonatomic) IBOutlet UILabel* label1;
@property (strong, nonatomic) IBOutlet UIButton* button1;

@property (strong, nonatomic) IBOutlet UITextField* textFieldName;
@property (strong, nonatomic) IBOutlet UITextField* textFieldPass;

@end

@implementation CreateLeaderboardViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _textFieldName){
        [_textFieldPass becomeFirstResponder];
        return NO;
    }
    else{
        [_textFieldPass resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)createLeaderboard:(id)sender{
    
    GrintBCourseDownload* controller = [[GrintBCourseDownload alloc]initWithNibName:@"GrintBCourseDownload" bundle:nil];
    controller.isLeaderboard = YES;
    controller.leaderboardName = _textFieldName.text;
    controller.leaderboardPass = _textFieldPass.text;
    controller.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    controller.fname = self.nameString;
    controller.lname = self.lastName;
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
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [_button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [_button1.layer setCornerRadius:5.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
