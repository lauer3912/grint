//
//  GrintDetail5.m
//  grint
//
//  Created by Peter Rocker on 30/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintDetail5.h"
#import "GrintDetail7.h"
#import "GrintVerticalWebModalViewController.h"

@implementation GrintDetail5
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
@synthesize pastUsers;
@synthesize friendList, data, connection, friendListNames;

int photoNumberC = 0;
bool doublePhotosC = NO;


-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end forString:(NSString*) string {
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return nil;
}

-(IBAction)navigationBackClick:(id)sender{
    
    [self tryAdd:self withText:[friendList objectAtIndex:[pickerView1 selectedRowInComponent:0]]];
    [pickerView1 setHidden:YES];
    [navigationBar1 setHidden:YES];
    
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [friendList count];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [friendListNames objectAtIndex:row];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    friendList = [[NSMutableArray alloc]init];
    friendListNames = [[NSMutableArray alloc]init];
    
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", responseText);
    
    for(NSString* s in [responseText componentsSeparatedByString:@"</friend>"]){
        
        if(s.length > 11){
            
            NSString* p = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
            
            if(p && p.length > 0)
            [friendList addObject:p];
            [friendListNames addObject:[NSString stringWithFormat:@"%@ %@", [self stringBetweenString:@"<fname>" andString:@"</fname>" forString:s], [self stringBetweenString:@"<lname>" andString:@"</lname>" forString:s]]];
        }
    }

         button1.enabled = YES;

}


- (IBAction)selectFriendList:(id)sender{
    
    if(friendList && [friendList count] > 0){
              
    [pickerView1 reloadAllComponents];
    pickerView1.hidden = NO;
    navigationBar1.hidden = NO;

    }
    else{
        
        [[[UIAlertView alloc]initWithTitle:@"Add Friends First" message:@"The Add Friend feature is coming soon. If you want to add friends you can do so at our website" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Go to site", nil] show];
        
    }
    
}

- (void) tryAdd:(id)sender withText:(NSString*) string{
    
    if(textField1.text.length < 1){
        [textField1 setText:string];
    }
    else if(textField2.text.length < 1){
        [textField2 setText:string];
    }
    else if(textField3.text.length < 1){
        [textField3 setText:string];
    }
    else if(textField4.text.length < 1){
        [textField4 setText:string];
    }
    
}

- (IBAction)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
}

-(IBAction)addUser:(id)sender{
    
    switch (((UILabel*)sender).tag) {
        case 1:
            [self tryAdd:sender withText:label4.text];
            break;
        case 2:
            [self tryAdd:sender withText:label5.text];
            break;
        case 3:
            [self tryAdd:sender withText:label6.text];            
            break;
        case 4:
            [self tryAdd:sender withText:label7.text];            
            break;
        case 5:
            [self tryAdd:sender withText:label8.text];
            break;
        case 6:
            [self tryAdd:sender withText:label9.text];
            break;
        case 7:
            [self tryAdd:sender withText:label10.text];            
            break;
        case 8:
            [self tryAdd:sender withText:label11.text];            
            break;
        default:
            break;
    }
    
}

- (bool)historyContains:(NSString*) user{
    
    for(NSString* s in pastUsers){
    
        if([s isEqualToString:user]){
            return true;
        }
    
    }
    return false;
    
}

-(IBAction)nextScreen:(id)sender{
        
    if(textField1.text.length > 0){
        if(![self historyContains:textField1.text] && ![textField1.text isEqualToString:username]){
            
            [pastUsers insertObject:textField1.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    if(textField2.text.length > 0){
        if(![self historyContains:textField2.text] && ![textField2.text isEqualToString:username]){
            
            [pastUsers insertObject:textField2.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }

    }
    if(textField3.text.length > 0){
        if(![self historyContains:textField3.text] && ![textField3.text isEqualToString:username]){
            
            [pastUsers insertObject:textField3.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    if(textField4.text.length > 0){
        if(![self historyContains:textField4.text] && ![textField4.text isEqualToString:username]){
            
            [pastUsers insertObject:textField4.text atIndex:0];
            [pastUsers removeObjectAtIndex:[pastUsers count] - 1];
            
        }
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:0] forKey:@"history1"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:1] forKey:@"history2"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:2] forKey:@"history3"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:3] forKey:@"history4"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:4] forKey:@"history5"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:5] forKey:@"history6"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:6] forKey:@"history7"];
    [[NSUserDefaults standardUserDefaults] setValue:[pastUsers objectAtIndex:7] forKey:@"history8"];
        
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Upload scorecard" message:@"Select photo source" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Photo Roll", nil];
    alert.tag = 13;
    [alert show];
    
    /*
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintDetail6 alloc] initWithNibName:@"GrintDetail6" bundle:nil];
    }
    
    ((GrintDetail6*)self.detailViewController).username = self.username;
    ((GrintDetail6*)self.detailViewController).courseName= self.courseName;
    ((GrintDetail6*)self.detailViewController).courseAddress= self.courseAddress;
    ((GrintDetail6*)self.detailViewController).teeboxColor= self.teeboxColor;
    ((GrintDetail6*)self.detailViewController).date = self.date;
    ((GrintDetail6*)self.detailViewController).score = self.score;
    ((GrintDetail6*)self.detailViewController).putts = self.putts;
    ((GrintDetail6*)self.detailViewController).penalties = self.penalties;
    ((GrintDetail6*)self.detailViewController).accuracy = self.accuracy;
    
    ((GrintDetail6*)self.detailViewController).player1 = textField1.text;
    ((GrintDetail6*)self.detailViewController).player2 = textField2.text;
    ((GrintDetail6*)self.detailViewController).player3 = textField3.text;
    ((GrintDetail6*)self.detailViewController).player4 = textField4.text;
    ((GrintDetail6*)self.detailViewController).courseID = self.courseID;

    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    */
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIBarButtonItem* backButton;
    UIAlertView* alert;
    
    if(alertView.tag == 13){
        
        switch (buttonIndex) {
            case 0:
                alert = [[UIAlertView alloc] initWithTitle:@"Photo your scorecard" message:@"How many sides of the scorecard do you need to photograph?" delegate:self cancelButtonTitle:@"One" otherButtonTitles:@"Two", nil];
                alert.tag = 12;
                [alert show];

                break;
            case 1:
                
                alert = [[UIAlertView alloc] initWithTitle:@"Photo your scorecard" message:@"How many sides of the scorecard do you need to upload?" delegate:self cancelButtonTitle:@"One" otherButtonTitles:@"Two", nil];
                alert.tag = 14;
                [alert show];
                
              

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
    
    else if(alertView.tag == 14){
        
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        switch (buttonIndex) {
            case 0:
                
                doublePhotosC = NO;
                photoNumberC = 1;
                
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id)self;
                imagePicker.allowsImageEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
                break;
                
            case 1:
                
                doublePhotosC = YES;
                photoNumberC = 1;
                
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = (id)self;
                imagePicker.allowsImageEditing = NO;
                [self presentModalViewController:imagePicker animated:YES];
                break;
        }
    }
    else{
        if(buttonIndex != [alertView cancelButtonIndex]){
            
            GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
            [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com/loginapp"]]];
            controller.webView1.scalesPageToFit = YES;
            
        }
    }
    
}

-(IBAction)cameraSingle:(id)sender{
    // Create image picker controller
    
    doublePhotosC = NO;
    photoNumberC = 1;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id)self;
    imagePicker.allowsImageEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}

-(IBAction)cameraDouble:(id)sender{
    // Create image picker controller
    
    doublePhotosC = YES;
    photoNumberC = 1;
    
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
    if(photoNumberC == 1){
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
    
    
    
    if(doublePhotosC && (photoNumberC == 1)){
        [self dismissModalViewControllerAnimated:NO];
        photoNumberC = 2;
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  picker.sourceType;
        imagePicker.delegate = (id)self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else{
        
        if(doublePhotosC){
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
        ((GrintDetail7*)self.detailViewController).player1 = textField1.text;
        ((GrintDetail7*)self.detailViewController).player2 = textField2.text;
        ((GrintDetail7*)self.detailViewController).player3 = textField3.text;
        ((GrintDetail7*)self.detailViewController).player4 = textField4.text;
        ((GrintDetail7*)self.detailViewController).courseID = self.courseID;     
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
   /* UIAlertView *alert;
    
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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Select Players", @"Select Players");
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/getfriends_iphone/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"username=%@&course_id=%@", username, courseID];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];
    }

    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
 /*   [label2 setFont:[UIFont fontWithName:@"Merriweather" size:10]];
    [label3 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label4 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label5 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label6 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label7 setFont:[UIFont fontWithName:@"Merriweather" size:12]];   
    [label8 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label9 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label10 setFont:[UIFont fontWithName:@"Merriweather" size:12]];
    [label11 setFont:[UIFont fontWithName:@"Merriweather" size:12]];*/
    
    
    [label12 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
    [button1.layer setCornerRadius:5.0f];
    button1.enabled = NO;
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(nextScreen:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    
    [labelCourse setText:[NSString stringWithFormat:@"at %@", courseName]];
    
    textField1.text = username;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(connection){
        [connection cancel];
        connection = nil;
    }
    
}

- (void)swipeRightDetected:(id)sender{
    
    [[self navigationController]popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    [label4 setText:username];
    
    pastUsers = [[NSMutableArray alloc] init];
    
    [pastUsers addObject:username];
    
    NSString* temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history1"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history2"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history3"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history4"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history5"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history6"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history7"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    temp = [[NSUserDefaults standardUserDefaults]valueForKey:@"history8"];
    
    if(![temp isEqualToString:username]){
        [pastUsers addObject:temp];
    }
    
    [label5 setText:[pastUsers objectAtIndex:1]];
    [label6 setText:[pastUsers objectAtIndex:2]];
    [label7 setText:[pastUsers objectAtIndex:3]];
    [label8 setText:[pastUsers objectAtIndex:4]];
    [label9 setText:[pastUsers objectAtIndex:5]];
    [label10 setText:[pastUsers objectAtIndex:6]];
    [label11 setText:[pastUsers objectAtIndex:7]];
    
    
        
        UIBarButtonItem* button = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextScreen:)];
        [self.navigationItem setRightBarButtonItem:button];
    
    //[textField1 setText:@""];
    //[textField2 setText:@""];
    //[textField3 setText:@""];
    //[textField4 setText:@""];
    
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
