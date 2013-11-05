//
//  Leaderboard1ViewController.m
//  grint
//
//  Created by Peter Rocker on 08/05/2013.
//
//

#import "Leaderboard1ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GrintBCourseDownload.h"
#import "CreateLeaderboardViewController.h"
#import "SearchLeaderboardViewController.h"
#import "ReviewLeaderboardViewController.h"
#import "GrintWhatIsLeaderboardControllerViewController.h"

@interface Leaderboard1ViewController ()

@property IBOutlet UIButton* button1;
@property IBOutlet UIButton* button2;
@property IBOutlet UIButton* button3;
@property IBOutlet UIButton* button4;
@property IBOutlet UIButton* button5;
@property IBOutlet UILabel* label1;
@property IBOutlet UILabel* label2;
@property IBOutlet UILabel* label3;
@property IBOutlet UIView* buttonContainer;
@property IBOutlet UIButton* buttonI;

@property BOOL isShowingOptns;
@property CGRect oldFrame1;
@property CGRect oldFrame2;
@property CGRect oldFrameBtnI;

@end

@implementation Leaderboard1ViewController

- (IBAction)joinLeaderboard:(id)sender{
    
    SearchLeaderboardViewController* controller = [[SearchLeaderboardViewController alloc]initWithNibName:@"SearchLeaderboardViewController" bundle:nil];
    controller.nameString = self.nameString;
    controller.lastName = self.lastName;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)createLeaderboard:(id)sender{
    
    CreateLeaderboardViewController* controller = [[CreateLeaderboardViewController alloc]initWithNibName:@"CreateLeaderboardViewController" bundle:nil];
    controller.nameString = self.nameString;
    controller.lastName = self.lastName;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)reviewLeaderboard:(id)sender{
    ReviewLeaderboardViewController* controller = [[ReviewLeaderboardViewController alloc]initWithNibName:@"ReviewLeaderboardViewController" bundle:nil];
    controller.nameString = self.nameString;
    controller.lastName = self.lastName;
    [self.navigationController pushViewController:controller animated:YES];
}



- (IBAction)normalRound:(id)sender{
    GrintBCourseDownload* detailViewControllerB = [[GrintBCourseDownload alloc] initWithNibName:@"GrintBCourseDownload" bundle:nil];
    
    detailViewControllerB.username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    detailViewControllerB.fname = self.nameString;
    detailViewControllerB.lname = self.lastName;
    
    [self.navigationController pushViewController:detailViewControllerB animated:YES];

}

- (IBAction)liveLeaderboard:(id)sender{

    
    if(!_isShowingOptns){
    
        _oldFrame1 = _button2.frame;
        _oldFrame2 = _label3.frame;
        _oldFrameBtnI = _buttonI.frame;
        
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                        _button2.frame = _button1.frame;
                         _label3.frame = _label2.frame;
                         _buttonI.frame = CGRectMake(_oldFrameBtnI.origin.x, _oldFrameBtnI.origin.y - _button1.frame.origin.y, _oldFrameBtnI.size.width, _oldFrameBtnI.size.height) ;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                             _buttonContainer.hidden = NO;
                         } completion:^(BOOL finished){} ];
                         
                     }];
        _isShowingOptns = YES;
    }
    else{
        _buttonContainer.hidden = YES;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             _button2.frame = _oldFrame1;
                             _label3.frame = _oldFrame2;
                             _buttonI.frame = _oldFrameBtnI;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        _isShowingOptns = NO;
    }
    
    
}



- (IBAction)whatIsThisClick:(id)sender{
    
    GrintWhatIsLeaderboardControllerViewController* controller = [[GrintWhatIsLeaderboardControllerViewController alloc]initWithNibName:@"GrintWhatIsLeaderboardControllerViewController" bundle:nil];
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];
    
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
    
    [_button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [_button1.layer setCornerRadius:5.0f];
    [_button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [_button2.layer setCornerRadius:5.0f];
    
    [_label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    
    [_button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    _button3.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _button3.layer.borderWidth = 2.0f;
    [_button4.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    _button4.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _button4.layer.borderWidth = 2.0f;
    [_button5.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    _button5.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _button5.layer.borderWidth = 2.0f;
    
    self.navigationController.navigationBar.hidden = NO;
    
//    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
//    self.navigationItem.leftBarButtonItem = backItem;
}

- (void) goBack: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
