//
//  GrintBReviewScoreMultiplayer.m
//  grint
//
//  Created by Peter Rocker on 02/12/2012.
//
//

#import "GrintBReviewScoreMultiplayer.h"
#import "GrintBReviewStatsMultiplayer.h"
#import "GrintBDetail7Multiplayer.h"
#import "GrintScore.h"
#import "Flurry.h"

@implementation GrintBReviewScoreMultiplayer
@synthesize detailViewController = _detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize score;
@synthesize putts;
@synthesize penalties;
@synthesize accuracy;
@synthesize date;
@synthesize courseID;
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize scores;
@synthesize teeID;
@synthesize holeOffset;
@synthesize playerData;

int photoNumberD = 0;
bool doublePhotosD = NO;

- (IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIBarButtonItem* backButton;
    UIAlertView* alert;
    
    if(alertView.tag == 11){
        
        switch(buttonIndex){
            case 0:
                
                [Flurry logEvent:@"playgolf_picture_not_added"];
                backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
                
                [[self navigationItem] setBackBarButtonItem:backButton];
                
                
                if (!self.detailViewController) {
                    self.detailViewController = [[GrintBDetail7Multiplayer alloc] initWithNibName:@"GrintBDetail7Multiplayer" bundle:nil];
                }
                
                
                ((GrintBDetail7Multiplayer*)self.detailViewController).teeID = self.teeID;
                
                
                ((GrintBDetail7Multiplayer*)self.detailViewController).username = self.username;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseName= self.courseName;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseAddress= self.courseAddress;
                ((GrintBDetail7Multiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
                ((GrintBDetail7Multiplayer*)self.detailViewController).date = self.date;
                ((GrintBDetail7Multiplayer*)self.detailViewController).score = self.score;
                ((GrintBDetail7Multiplayer*)self.detailViewController).putts = self.putts;
                ((GrintBDetail7Multiplayer*)self.detailViewController).penalties = self.penalties;
                ((GrintBDetail7Multiplayer*)self.detailViewController).accuracy = self.accuracy;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player1 = self.player1;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player2 = self.player2;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player3 = self.player3;
                ((GrintBDetail7Multiplayer*)self.detailViewController).player4 = self.player4;
                ((GrintBDetail7Multiplayer*)self.detailViewController).courseID = self.courseID;
                ((GrintBDetail7Multiplayer*)self.detailViewController).scores = self.scores;
                ((GrintBDetail7Multiplayer*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:0];
                ((GrintBDetail7Multiplayer*)self.detailViewController).holeOffset = self.holeOffset;
                ((GrintBDetail7Multiplayer*)self.detailViewController).isNine = self.isNine;
                ((GrintBDetail7Multiplayer*)self.detailViewController).nineType = self.nineType;
                ((GrintBDetail7Multiplayer*)self.detailViewController).leaderboardID = self.leaderboardID;

                
                [self.navigationController pushViewController:self.detailViewController animated:YES];
                
                
                break;
                
            case 1:
                
                [Flurry logEvent:@"playgolf_pictureadded"];
                alert = [[UIAlertView alloc] initWithTitle:@"Upload scorecard" message:@"Select photo source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photo Roll", nil];
                alert.tag = 13;
                [alert show];
                
                
                break;
        }
        
        
    }
    
    else if(alertView.tag == 13){
        
        switch (buttonIndex) {
            case 0:
                alert = [[UIAlertView alloc] initWithTitle:@"Photo your scorecard" message:@"How many sides of the scorecard do you need to photograph?" delegate:self cancelButtonTitle:@"One" otherButtonTitles:@"Two", nil];
                alert.tag = 12;
                [alert show];
                
                break;
            case 1:
                doublePhotosD = NO;
                photoNumberD = 1;
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id)self;
                imagePicker.allowsImageEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
                
                break;
        }
        
    }
    
    else if(alertView.tag == 12){
        switch (buttonIndex) {
            case 0:
                [self cameraSingle:self];
                break;
            case 1:
                [self cameraDouble:self];
                break;
        }
    }
    
}

-(IBAction)cameraSingle:(id)sender{
    // Create image picker controller
    
    doublePhotosD = NO;
    photoNumberD = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)cameraDouble:(id)sender{
    // Create image picker controller
    
    doublePhotosD = YES;
    photoNumberD = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(image.size.width > 1024){
        
        float scaleAmount = 1024 / image.size.width;
        
        CGSize destinationSize = CGSizeMake(image.size.width * scaleAmount, image.size.height * scaleAmount);
        
        UIGraphicsBeginImageContext(destinationSize);
        [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    NSString  *jpgPath;
    if(photoNumberD == 1){
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
    }
    else{
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp2.jpg"];
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    
    
    if(doublePhotosD && (photoNumberD == 1)){
        [self dismissModalViewControllerAnimated:NO];
        photoNumberD = 2;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id)self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{
        
        if(doublePhotosD){
            //stitch image to temp.jpg
            UIImage * piece1 = [UIImage imageWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"]];
            
            CGSize newSize = CGSizeMake(piece1.size.width * 2, piece1.size.height);
            UIGraphicsBeginImageContext( newSize );
            
            [piece1 drawInRect:CGRectMake(0,0,piece1.size.width, piece1.size.height)];
            [image drawInRect:CGRectMake(piece1.size.width,0,piece1.size.width, piece1.size.height)];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
        }
        
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
        [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
        
        NSDate *now = [NSDate date];
        NSLog(now.description);
        
        NSString* newDir = [[@"Documents/" stringByAppendingString:now.description]stringByAppendingString:@".jpg"];
        
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:newDir];
        [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
        
        [self dismissModalViewControllerAnimated:YES];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        
        if (!self.detailViewController) {
            self.detailViewController = [[GrintBDetail7Multiplayer alloc] initWithNibName:@"GrintBDetail7Multiplayer" bundle:nil];
        }
        
        
        ((GrintBDetail7Multiplayer*)self.detailViewController).teeID = self.teeID;
        
        
        ((GrintBDetail7Multiplayer*)self.detailViewController).username = self.username;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseName= self.courseName;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseAddress= self.courseAddress;
        ((GrintBDetail7Multiplayer*)self.detailViewController).teeboxColor= self.teeboxColor;
        ((GrintBDetail7Multiplayer*)self.detailViewController).date = self.date;
        ((GrintBDetail7Multiplayer*)self.detailViewController).score = self.score;
        ((GrintBDetail7Multiplayer*)self.detailViewController).putts = self.putts;
        ((GrintBDetail7Multiplayer*)self.detailViewController).penalties = self.penalties;
        ((GrintBDetail7Multiplayer*)self.detailViewController).accuracy = self.accuracy;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player1 = self.player1;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player2 = self.player2;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player3 = self.player3;
        ((GrintBDetail7Multiplayer*)self.detailViewController).player4 = self.player4;
        ((GrintBDetail7Multiplayer*)self.detailViewController).courseID = self.courseID;
        ((GrintBDetail7Multiplayer*)self.detailViewController).scores = self.scores;
        ((GrintBDetail7Multiplayer*)self.detailViewController).holeOffset = self.holeOffset;
        ((GrintBDetail7Multiplayer*)self.detailViewController).attachedScorecard = [NSNumber numberWithInt:1];
        ((GrintBDetail7Multiplayer*)self.detailViewController).isNine = self.isNine;
        ((GrintBDetail7Multiplayer*)self.detailViewController).nineType = self.nineType;
        ((GrintBDetail7Multiplayer*)self.detailViewController).leaderboardID = self.leaderboardID;
        
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    /*  UIAlertView *alert;
     
     // Unable to save the image
     if (error)
     alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Unable to save image to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     else // All is well
     alert = [[UIAlertView alloc] initWithTitle:@"Success"
     message:@"Image saved to Photo Album."
     delegate:self cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     [alert show];*/
}



-(IBAction)nextScreen:(id)sender{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Attach picture" message:@"Would you like to attach a photo of your scorecard with this submission?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 11;
    [alert show];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) displayScores:(id)sender{
    
    NSArray* scoreArray = [scores objectAtIndex:playerIndex];
    
    switch (playerIndex) {
        case 0:
            [label1 setText:[NSString stringWithFormat:@"%@'S SCORECARD", [[[playerData objectAtIndex:0]valueForKey:@"fname" ] uppercaseString]]];
            break;
            
        case 1:
            [label1 setText:[NSString stringWithFormat:@"%@'S SCORECARD", [[[playerData objectAtIndex:1]valueForKey:@"fname" ] uppercaseString]]];
            break;
            
        case 2:
            [label1 setText:[NSString stringWithFormat:@"%@'S SCORECARD", [[[playerData objectAtIndex:2]valueForKey:@"fname" ] uppercaseString]]];
            break;
            
        case 3:
            [label1 setText:[NSString stringWithFormat:@"%@'S SCORECARD", [[[playerData objectAtIndex:3]valueForKey:@"fname" ] uppercaseString]]];
            break;
            
    }
    
    for(int i = 100; i <= 500; i += 100){
        
        float total = 0;
        
        for(int j = 0; j <= 18; j++){
            
            if(i != 100){
                
                [self.view viewWithTag:i + j].layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
                [self.view viewWithTag:i + j].layer.borderWidth = 1.0;
            }
            
            if(i == 100){
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scoreArray objectAtIndex:j]).par;
                    total += [((GrintScore*)[scoreArray objectAtIndex:j]).par intValue];
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            else if(i == 200){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scoreArray objectAtIndex:j]).score;
                    total += [((GrintScore*)[scoreArray objectAtIndex:j]).score intValue];
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
                
                if(!((UILabel*)[self.view viewWithTag:200 + j]).text){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                    
                }
                else if( [((UILabel*)[self.view viewWithTag:200 + j]).text intValue] ==  [((UILabel*)[self.view viewWithTag:100 + j]).text intValue] ){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:0.12 green:0.32 blue:0.37 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                }
                else if([((UILabel*)[self.view viewWithTag:200 + j]).text intValue] <  [((UILabel*)[self.view viewWithTag:100 + j]).text intValue] ){
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    
                }
                else{
                    
                    ((UILabel*)[self.view viewWithTag:200 + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    ((UILabel*)[self.view viewWithTag:200 + j]).textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
                    
                }
                
            }
            else if(i == 300){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scoreArray objectAtIndex:j]).putts;
                    total += [((GrintScore*)[scoreArray objectAtIndex:j]).putts intValue];
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
                
                
            }
            
            else if(i == 400){
                
                if(j <= 17){
                    ((UILabel*)[self.view viewWithTag:i + j]).text = ((GrintScore*)[scoreArray objectAtIndex:j]).penalty;
                    if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"S "]) {
                        total += 0.5;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"F "]) {
                        total += 0.5;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"W "]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"O "]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"D "]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"SS"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"FF"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"WW"]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"OO"]) {
                        total += 4;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"DD"]) {
                        total += 2;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"FS"]) {
                        total += 1;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"WS"]) {
                        total += 1.5;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"OS"]) {
                        total += 2.5;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"DS"]) {
                        total += 1.5;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"OW"]) {
                        total += 3.0;
                    }
                    else if([((GrintScore*)[scoreArray objectAtIndex:j]).penalty isEqualToString:@"OF"]) {
                        total += 2.5;
                    }

                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            else if(i == 500){
                
                if(j <= 17){
                    
                    /*   if([((UILabel*)[self.view viewWithTag:100 + j]).text isEqualToString:@"3"]){
                     [self.view viewWithTag:i + j].layer.borderWidth = 0.0;
                     }*/
                    
                    if(((GrintScore*)[scoreArray objectAtIndex:j]).fairway.length < 1){
                        ((GrintScore*)[scoreArray objectAtIndex:j]).fairway = @" ";
                    }
                    
                    
                    ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                    if(((GrintScore*)[scoreArray objectAtIndex:j]).fairway.length > 0){
                        if([[((GrintScore*)[scoreArray objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"H"]){
                            ((UILabel*)[self.view viewWithTag:i + j]).text = @"✔";
                            //          ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.12 green:0.32 blue:0.37 alpha:1.0];
                        }
                        else if([[((GrintScore*)[scoreArray objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"L"]){
                            ((UILabel*)[self.view viewWithTag:i + j]).text = @"◀";
                            //          ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                        }
                        else if([[((GrintScore*)[scoreArray objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"R"]){
                            ((UILabel*)[self.view viewWithTag:i + j]).text = @"▶";
                            //         ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                        }
                        else if([[((GrintScore*)[scoreArray objectAtIndex:j]).fairway substringToIndex:1] isEqualToString:@"S"]){
                            ((UILabel*)[self.view viewWithTag:i + j]).text = @"▼";
                            //         ((UILabel*)[self.view viewWithTag:i + j]).backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1.0];
                        }
                        else{
                            ((UILabel*)[self.view viewWithTag:i + j]).text = @"";
                        }
                    
                    if([[((GrintScore*)[scoreArray objectAtIndex:j]).fairway substringToIndex:1]isEqualToString:@"H"]) {
                        total++;
                    }
                    }
                    else{
                        ((UILabel*)[self.view viewWithTag:i + j]).text = @"";
                    }
                }
                else{
                    ((UILabel*)[self.view viewWithTag:i + j]).text = [NSString stringWithFormat:@"%.0f", total];
                }
            }
            
        }

    }
}



- (void)nextPlayer:(id)sender{
    
    if((playerIndex == 0) || (playerIndex == 1 && player3.length > 0) || (playerIndex == 2 && player4.length > 0)){
    
    if (playerIndex + 1 < scores.count){
        playerIndex ++;
        [self displayScores:sender];
    }
    }
    
}

- (void)previousPlayer:(id)sender{
    
    if (playerIndex > 0){
        playerIndex --;
        [self displayScores:sender];
    }
    
}



#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    
    //NSLog(self.courseName);
    
    [super viewWillAppear:animated];
    [label1 setText:[NSString stringWithFormat:@"%@'S SCORECARD", [[[playerData objectAtIndex:0]valueForKey:@"fname" ] uppercaseString]]];
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];

    self.navigationController.navigationBar.hidden = YES;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(1.57079633);
    self.view.bounds = CGRectMake(0.0, 0.0, 460.0, 320.0);
    [button1.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button2.layer setCornerRadius:5.0f];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    label2.text = courseName;
    
    playerIndex = 0;
    [self displayScores:self];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextPlayer:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(previousPlayer:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
    

}


- (void)swipeRightDetected:(id)sender{
    
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
