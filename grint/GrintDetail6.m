//
//  GrintDetail6.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintDetail6.h"
#import "GrintDetail7.h"


@implementation GrintDetail6
@synthesize detailViewController;

@synthesize username;
@synthesize courseName;
@synthesize courseAddress;
@synthesize teeboxColor;
@synthesize score;
@synthesize putts;
@synthesize penalties;
@synthesize accuracy;
@synthesize date;
@synthesize player1;
@synthesize player2;
@synthesize player3;
@synthesize player4;
@synthesize courseID;

int photoNumber = 0;
bool doublePhotos = NO;

-(IBAction)cameraSingle:(id)sender{
    // Create image picker controller
    
    doublePhotos = NO;
    photoNumber = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)cameraDouble:(id)sender{
    // Create image picker controller
    
    doublePhotos = YES;
    photoNumber = 1;
    
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
    if(photoNumber == 1){
    jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp1.jpg"];
    }
    else{
    jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp2.jpg"];
    }
    
  //  UIImageWriteToSavedPhotosAlbum(image, self, 
   //                                @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [UIImageJPEGRepresentation(image, 0.9) writeToFile:jpgPath atomically:YES];
        
        NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
   
    
    
    if(doublePhotos && (photoNumber == 1)){
         [self dismissModalViewControllerAnimated:NO];
        photoNumber = 2;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = (id)self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{    
        
        if(doublePhotos){
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
    [self nextScreen:self];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
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
    [alert show];
}

-(IBAction)nextScreen:(id)sender{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintDetail7 alloc] initWithNibName:@"GrintDetail7" bundle:nil];
    }
    
    ((GrintDetail7*)self.detailViewController).username = self.username;
    ((GrintDetail7*)self.detailViewController).courseName= self.courseName;
    ((GrintDetail7*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintDetail7*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintDetail7*)self.detailViewController).date = self.date;
    ((GrintDetail7*)self.detailViewController).score = self.score;
    ((GrintDetail7*)self.detailViewController).putts = self.putts;
    ((GrintDetail7*)self.detailViewController).penalties = self.penalties;
    ((GrintDetail7*)self.detailViewController).accuracy = self.accuracy;
    
    ((GrintDetail7*)self.detailViewController).player1 = self.player1;
    ((GrintDetail7*)self.detailViewController).player2 = self.player2;
    ((GrintDetail7*)self.detailViewController).player3 = self.player3;
    ((GrintDetail7*)self.detailViewController).player4 = self.player4;

    ((GrintDetail7*)self.detailViewController).courseID = self.courseID;

    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Camera", @"Camera");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [label1 setFont:[UIFont fontWithName:@"Merriweather-Bold" size:16]];
    [label2 setFont:[UIFont fontWithName:@"Merriweather" size:14]];

    [button1.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Merriweather" size:14]];
    [button2.layer setCornerRadius:5.0f];
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
