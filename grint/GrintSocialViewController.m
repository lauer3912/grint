//
//  GrintSocialViewController.m
//  grint
//
//  Created by Peter Rocker on 06/11/2012.
//
//

#import "GrintSocialViewController.h"

#import <Twitter/Twitter.h>

#import <FacebookSDK/FacebookSDK.h>
#import "GrintAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface GrintSocialViewController ()

@end

@implementation GrintSocialViewController

@synthesize tweetText, tweetImage, delegate;

- (IBAction)performShare:(id)sender{
    
    if(facebookON){
        [self openSession:sender];
    } else if(tweetON){
        [self tweetScore:sender];
    }

    
}

- (IBAction)cancelClick:(id)sender{
    
    [delegate dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)tweetScore:(id)sender{
    
//    if ([TWTweetComposeViewController canSendTweet])
//    {
//        TWTweetComposeViewController *tweetSheet =
//        [[TWTweetComposeViewController alloc] init];
//        
//        NSString* initialText = [[textView2.text stringByAppendingString:@". " ] stringByAppendingString:textView1.text];
//        
//        if (initialText.length > 140){
//            initialText = [initialText substringToIndex:139];
//        }
//        
//        [tweetSheet setInitialText:initialText];
//        if (imageView1.image)
//            [tweetSheet addImage: imageView1.image];
//        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
//            
//            //[self dismissModalViewControllerAnimated:YES];
//            [self.delegate dismissModalViewControllerAnimated:YES];
//            
//            switch (result) {
//                case TWTweetComposeViewControllerResultCancelled:
//                    break;
//                    
//                case TWTweetComposeViewControllerResultDone:
//                    break;
//                    
//                default:
//                    break;
//            }
//        };
//        [self presentModalViewController:tweetSheet animated:YES];
//    }
    NSString* initialText = [[textView2.text stringByAppendingString:@". " ] stringByAppendingString:textView1.text];
    if (initialText.length > 105){
        initialText = [initialText substringToIndex:105];
    }

    SLComposeViewController* vc = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
    [vc addImage: imageView1.image];
    [vc setInitialText: initialText];
    
    vc.completionHandler = ^(SLComposeViewControllerResult result) {
        [self.navigationController popViewControllerAnimated: YES];
    };

    [self presentViewController: vc animated: YES completion: nil];
}

- (void) postImageToFB:(UIImage*)image withDescription:(NSString*)description
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSData* imageData = UIImageJPEGRepresentation(image, 90);
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    description, @"message",
                                    imageData, @"source",
                                    nil];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              NSLog(@"%@", [error description]);
                              
                              
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              
                              if(!error){
                                  
                                  if(tweetON){
                                      [self tweetScore:self];
                                  }
                                  else{
                                      [delegate dismissModalViewControllerAnimated:YES];
                                  }
                              }
                              
                          }];
}


- (IBAction)openSession:(id)sender
{
//    GrintAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    
//    appDelegate.fbDelegate = self;
//    
//    [appDelegate openSession];
    
    NSString* initialText = [[textView2.text stringByAppendingString:@". " ] stringByAppendingString:textView1.text];
    SLComposeViewController* vc = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
    [vc setInitialText: initialText];
    if (imageView1.image)
        [vc addImage: imageView1.image];
    vc.completionHandler = ^(SLComposeViewControllerResult result)  {
        if (tweetON) {
            [self tweetScore: nil];
        } else {
            [self.navigationController popViewControllerAnimated: YES];
        }
        //            //[self dismissModalViewControllerAnimated:YES];
        //            [self.delegate dismissModalViewControllerAnimated:YES];
        //
        //            switch (result) {
        //                case TWTweetComposeViewControllerResultCancelled:
        //                    break;
        //
        //                case TWTweetComposeViewControllerResultDone:
        //                    break;
        //
        //                default:
        //                    break;
        //            }
    };
    [self presentViewController: vc animated: YES completion: nil];

}

- (IBAction)facebookScore:(id)sender{
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        // No permissions found in session, ask for it
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_stream"]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error)
         {
             // If permissions granted, publish the story
             if (!error) [self facebookScore:self];
         }];
    }
    // If permissions present, publish the story
    else {
        
        [self postImageToFB: imageView1.image withDescription:[[textView2.text stringByAppendingString:@"\n\n" ] stringByAppendingString:textView1.text]];
        
        
    }

}

- (IBAction)enableFB:(id)sender{
    if(facebookON){
        facebookON = NO;
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"facebook-off.png"] forState:UIControlStateNormal];
    }
    else{
        facebookON = YES;
        
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"facebook-on.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)enableTwitter:(id)sender{
    if(tweetON){
        tweetON = NO;
        
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"twitter-off.png"] forState:UIControlStateNormal];
    }
    else{
        tweetON = YES;
        
        [((UIButton*)sender) setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [imageView1 setImage:tweetImage];
    [textView2 setText:[tweetText stringByAppendingString:@" using TheGrint"]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14.0]];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14.0]];
    [button2.layer setCornerRadius:5.0f];
    
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:18]];

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [buttonDismiss setHidden:NO];
    [self animateTextView:textView up:YES];

}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO];
    [buttonDismiss setHidden:YES];
}


- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    int animatedDistance;
    int moveUpValue = textView.frame.origin.y+ textView.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-5);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-5);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(BOOL)textViewShouldReturn:(UITextView *)textView {
    
    [textView resignFirstResponder];
    return YES;
}

- (IBAction)buttonDismiss:(id)sender{
    
    [textView1 resignFirstResponder];
    
}

- (IBAction)actionTakePhoto:(id)sender {
    
    [self buttonDismiss: sender];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Add a picture to your post" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Camera Roll", nil];
    alert.tag = 13;
    [alert show];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView* alert;
    
    if(alertView.tag == 11){
        
        switch(buttonIndex){
            case 1:
                
                alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select photo source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photo Roll", nil];
                alert.tag = 13;
                [alert show];
                
                break;
        }
    } else if(alertView.tag == 13) {
        
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = (id)self;
                [self presentViewController: imagePicker animated: YES completion: nil];
                break;
            }
            case 1:
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id)self;
                [self presentViewController: imagePicker animated: YES completion: nil];
                
                break;
            }
        }
        
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imageView1 setImage: [info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    if (imageView1.image != nil)
        labelTemp.hidden = YES;
    [picker dismissViewControllerAnimated: YES completion: nil];
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
    
    [labelTemp setText: @"Add a \n Picture"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
