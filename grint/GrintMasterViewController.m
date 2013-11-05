//
//  GrintMasterViewController.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintMasterViewController.h"

#import "GrintDetailViewController.h"
#import "GrintRegisterScreen.h"
#import "SpinnerView.h"
#import "GrintVerticalWebModalViewController.h"
#import "Flurry.h"

@implementation NSString (NSAddition)
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end


@implementation GrintMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize data, spinnerView, connection;

- (IBAction)videoClick:(id)sender{
    
    GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];
    
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <iframe src=\"%@\" width=\"%0.0f\" height=\"%0.0f\"></iframe>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, @"http://www.youtube.com/embed/_tEn0E-QEDM", self.view.frame.size.width, self.view.frame.size.height];
    
    NSLog(html);
    
    [controller.webView1 loadHTMLString:html baseURL:nil];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    [spinnerView removeSpinner];
    
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                       otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Login Stream : %@", responseText);
    
    NSString* successCode = [responseText stringBetweenString:@"<success>" andString:@"</success>"];
    
    if(successCode){
        int successCodeInt = [successCode integerValue];
        if (successCodeInt < 1){
            [[[UIAlertView alloc] initWithTitle:@"Login Error"
                                        message:@"The username or password entered was incorrect. Please try again!"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else{

            [textField1 resignFirstResponder];
            [textField2 resignFirstResponder];
            
            NSString* strName = [responseText stringBetweenString:@"<username>" andString:@"</username>"];
            [[NSUserDefaults standardUserDefaults] setValue:strName forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:textField2.text forKey:@"password"];
            
            
            if (!self.detailViewController) {
                self.detailViewController = [[GrintDetailViewController alloc] initWithNibName:@"GrintDetailViewController" bundle:nil];
            }
            
            self.detailViewController.memberType = [[responseText stringBetweenString:@"<member_type>" andString:@"</member_type>"] integerValue];
            self.detailViewController.trialCounter = [[responseText stringBetweenString:@"<sps_trial_counter>" andString:@"</sps_trial_counter>"] integerValue];
            self.detailViewController.spsCounter = [[responseText stringBetweenString:@"<sps_counter>" andString:@"</sps_counter>"] integerValue];
            self.detailViewController.expired = [[responseText stringBetweenString:@"<purchase_expired>" andString:@"</purchase_expired>"] integerValue];
            
            self.detailViewController.handicap =  [responseText stringBetweenString:@"<official_hcp_index>" andString:@"</official_hcp_index>"];
            
            self.detailViewController.nameString = [responseText stringBetweenString:@"<fname>" andString:@"</fname>"];
            self.detailViewController.lastName = [responseText stringBetweenString:@"<lname>" andString:@"</lname>"];
            self.detailViewController.userImage = [responseText stringBetweenString:@"<image>" andString:@"</image>"];
            
            [self.navigationController pushViewController:self.detailViewController animated:YES];
            

            NSString* trialStatus = [responseText stringBetweenString:@"<membership>" andString:@"</membership>"];
            
            if([trialStatus isEqualToString:@"trial"]){
                
             /*   self.detailViewController.label2.text = @"You are currently on a 90-day trial!"; 
                
                self.detailViewController.label2.hidden = NO;
                self.detailViewController.button3.hidden = NO;*/
                
                self.detailViewController.isMember = YES;
                
                self.detailViewController.isGuest = NO;
                
            }
            else if([trialStatus isEqualToString:@"expired"]){
                
                self.detailViewController.isMember = NO;
                self.detailViewController.isGuest = NO;
                
               /* self.detailViewController.label2.text = @"Please purchase a subscription to make use of our online scorecard tracking service."; 
                self.detailViewController.label2.textColor = [UIColor colorWithRed:0.9f green:0.0f blue:0.0f alpha:1.0f];;
                self.detailViewController.label2.hidden = NO;
                self.detailViewController.button3.hidden = NO;*/
            }
            
            else{
                self.detailViewController.isMember = YES;
                self.detailViewController.isGuest = NO;

//            self.detailViewController.label2.hidden = YES;
//            self.detailViewController.button3.hidden = YES;
            }

        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex != alertView.cancelButtonIndex){
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/forgotpassword_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"email=%@", [[alertView textFieldAtIndex:0] text]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];        
    }
        
        [[[UIAlertView alloc]initWithTitle:@"Reset Message Sent" message:@"Check your email account for information about resetting your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        
    }
}


- (IBAction)forgotPassword:(id)sender{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Forgotten Password?" message:@"Enter your email address to have your password reset." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [alert show];
    
}

- (IBAction)showLoginUI:(id)sender {
    
    [loginView setFrame: CGRectMake(0, self.view.frame.size.height, loginView.frame.size.width, loginView.frame.size.height)];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.2];
    
    loginView.hidden = NO;
    [loginView setFrame: CGRectMake(0, 0, loginView.frame.size.width, loginView.frame.size.height)];
    
    [UIView commitAnimations];
    
    m_nDismiss = 0;
}

- (IBAction)goToSite:(id)sender {
    GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
    controller.delegate = self;
    [self presentViewController: controller animated: YES completion:nil];
    [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com"]]];
    controller.webView1.scalesPageToFit = YES;
}

-(IBAction)registerUser:(id)sender{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:textField1.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:textField2.text forKey:@"password"];
    
    GrintRegisterScreen* controller = [[GrintRegisterScreen alloc]initWithNibName:@"GrintRegisterScreen" bundle:nil];
    
    controller.delegate = self;
    
    [Flurry logEvent:@"register_start"];
    
    [self.navigationController pushViewController: controller animated: YES];
    
}

-(IBAction)loginUser:(id)sender{
    
    
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/login_iphone/"]];
//    NSMutableURLRequest *request = [NSMutableURLRequest
//									requestWithURL:[NSURL URLWithString:@"http://192.168.0.177/grintsite2/login_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&password=%@", textField1.text, textField2.text];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    if (connection) {
        data = [NSMutableData data];
        
    }

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}
-(IBAction)loginGuest:(id)sender{
    textField1.text = @"Guest";
    
    [Flurry logEvent:@"guest_login"];
    
    [self logIn:sender];
}

-(IBAction)logIn:(id)sender{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];

    [textField1 resignFirstResponder];
    
    [[self navigationItem] setBackBarButtonItem:backButton];

    [[NSUserDefaults standardUserDefaults] setValue:textField1.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:textField2.text forKey:@"password"];
    
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintDetailViewController alloc] initWithNibName:@"GrintDetailViewController" bundle:nil];
    }
    
    self.detailViewController.isGuest = YES;
    self.detailViewController.nameString = @"Guest";
    self.detailViewController.lastName = @"guest";
    self.detailViewController.handicap =  @"0";
    
   [self.navigationController pushViewController:self.detailViewController animated:YES];
   // self.detailViewController.label2.text = @"You are currently signed in as a guest. To start your 90-day free trial of our scorecard tracking service, please hit Back then Register!";
   /* self.detailViewController.label2.text = @"You are currently signed in as a guest. To make use of our scorecard tracking service, please hit Back then Register!";
    self.detailViewController.label2.hidden = NO;
    self.detailViewController.button3.hidden = YES;*/
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Guest User" message:@"You are currently signed in as a guest user. To make use of our fantastic scorecard tracking service, please hit 'back' then 'register'." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
}
       

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Welcome", @"Welcome");
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
}

- (IBAction)dismissTextViews:(id)sender{
    
    if (m_nDismiss == 1) {
        [textField1 resignFirstResponder];
        [textField2 resignFirstResponder];
    } else {
        [loginView setFrame: CGRectMake(0, 0, loginView.frame.size.width, loginView.frame.size.height)];
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.2];
        
        [loginView setFrame: CGRectMake(0, self.view.frame.size.height, loginView.frame.size.width, loginView.frame.size.height)];
        
        [UIView commitAnimations];
//        loginView.hidden = YES;
        
        return;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    m_nDismiss = 0;
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    m_nDismiss = 1;
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    CGPoint frameOrigin = CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y);
    
    if (!CGRectContainsPoint(aRect, frameOrigin) ) {
        
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+120);
        
        [scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    activeField = textField;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   // NSLog(@"Documents directory: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] error:nil]);
    
    [label1 setFont:[UIFont fontWithName:@"Merriweather" size:18]];
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    [button2.layer setCornerRadius:5.0f];
//    [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    [button3.layer setCornerRadius:5.0f];
    
    [buttonLogin.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [buttonJoin.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    scrollView.contentSize=CGSizeMake(scrollView.bounds.size.width,scrollView.bounds.size.height + 50);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    [scrollView setContentOffset:CGPointMake(0.0f, 0.0f)animated:YES];
    
    NSString* username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    if([username isEqualToString:@"Guest User"]){
        username = @"";
    }
    
    [textField1 setText:username];
    [textField2 setText:[[NSUserDefaults standardUserDefaults]valueForKey:@"password"]];

    loginView.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(textField1.text.length > 0 && textField2.text.length > 0){
        [self loginUser:self];
    }
    
//    [self dismissModalViewControllerAnimated:NO];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
