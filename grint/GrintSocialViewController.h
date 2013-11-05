//
//  GrintSocialViewController.h
//  grint
//
//  Created by Peter Rocker on 06/11/2012.
//
//

#import <UIKit/UIKit.h>

@interface GrintSocialViewController : UIViewController<UIAlertViewDelegate, UIImagePickerControllerDelegate>{
    
    IBOutlet UIImageView* imageView1;
    IBOutlet UITextView* textView1;
    IBOutlet UILabel* textView2;
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;
    IBOutlet UILabel* label3;
    
    IBOutlet UILabel* labelTemp;
    IBOutlet UIButton* buttonDismiss;
    
    bool tweetON;
    bool facebookON;
    
}

@property (nonatomic, retain) NSString* tweetText;
@property (nonatomic, retain) UIImage* tweetImage;
@property (nonatomic, assign) UIViewController* delegate;

- (IBAction)enableFB:(id)sender;
- (IBAction)enableTwitter:(id)sender;
- (IBAction)buttonDismiss:(id)sender;
- (IBAction)actionTakePhoto:(id)sender;

@end
