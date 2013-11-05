//
//  GrintRegisterScreen.m
//  grint
//
//  Created by Peter Rocker on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintRegisterScreen.h"
#import "UICustomSwitch.h"
#import "Flurry.h"
#import "GrintVerticalWebModalViewController.h"
#import "SpinnerView.h"

@implementation GrintRegisterScreen
{
    SpinnerView* spinnerView;
}

@synthesize delegate;
@synthesize data;
@synthesize countryIso, countryNames, connection;

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

- (IBAction)openCountrySelector:(id)sender{
    [self showPicker: 0];
}

- (void) showPicker: (int) nKind
{
    [self dismissKeyboard];
    m_nPickerKind = nKind;
    [pickerView1 reloadAllComponents];
    
    [pickerView1 selectRow: m_anCurRow[m_nPickerKind] inComponent:0 animated: NO];
    
    pickerView1.hidden = NO;
    _m_btnEnter.hidden = NO;
}

- (void) dismissKeyboard {
    [textFieldUsername resignFirstResponder];
    [textFieldEmail resignFirstResponder];
    [textFieldPassword1 resignFirstResponder];
    [textFieldPassword2 resignFirstResponder];
    [textFieldFirstname resignFirstResponder];
    [textFieldLastname resignFirstResponder];
    [textFieldZip resignFirstResponder];
}

- (IBAction)openHandicap:(id)sender {
    [self showPicker: 1];
}

- (IBAction)openGender:(id)sender {
    [self showPicker: 2];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    m_anCurRow[m_nPickerKind] = row;
}

- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (m_nPickerKind == 0)
        return [countryNames count];
    else if (m_nPickerKind == 1)
        return 37;
    return 2;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (m_nPickerKind == 0)
        return [countryNames objectAtIndex:row];
    else if (m_nPickerKind == 1)
        return [NSString stringWithFormat:@"%d", row];
    return ((row == 0) ? @"Men" : @"Ladies");
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [self.data appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                      otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (spinnerView) {
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseText);
    if ([responseText rangeOfString:@"error"].location != NSNotFound){
            [[[UIAlertView alloc] initWithTitle:@"Registration Error"
                                        message:@"That username or email address is already taken. Please try again!"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        
        NSLog(@"ERROR : %@", responseText);
        }
        else{
   
            [[NSUserDefaults standardUserDefaults] setValue:textFieldUsername.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:textFieldPassword1.text forKey:@"password"];
            
            [Flurry logEvent:@"registration_completed"];
            
//            [delegate dismissModalViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated: YES];
            
         //   [delegate loginUser:self];
            
        }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1124) {//photo
        UIImagePickerController* imagePickerViewController = [[UIImagePickerController alloc] init];
        imagePickerViewController.delegate = self;
        if (buttonIndex == 0) {
            imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } else {
            imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerViewController animated:YES completion:nil];

    } else {
        [_m_confirmView setFrame: CGRectMake(0, 0, _m_confirmView.frame.size.width, _m_confirmView.frame.size.height)];
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.2];
        
        [_m_confirmView setFrame: CGRectMake(0, self.view.frame.size.height, _m_confirmView.frame.size.width, _m_confirmView.frame.size.height)];
        
        [UIView commitAnimations];
    }
}

- (IBAction)registerClick:(id)sender{
    
    if(![textFieldPassword1.text isEqualToString:textFieldPassword2.text]){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Passwords do not match. Please try again!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else if(textFieldUsername.text.length < 1){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a username"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show]; 
    }
    else if(textFieldPassword1.text.length < 1){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];   
    }
    else if(textFieldEmail.text.length < 1){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a valid email address"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    else if(textFieldFirstname.text.length < 1){
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter a first name"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else if (_m_btnCheck.selected == NO) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"" message: @"To register you need to agree to the Terms & Conditions." delegate:nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    else {
        
        if(textFieldHandicap.text.length < 1){
            textFieldHandicap.text = @"36";
        }
        
        [_m_textConfirmEmail setText: textFieldEmail.text];
        
        [_m_confirmView setFrame: CGRectMake(0, self.view.frame.size.height, _m_confirmView.frame.size.width, _m_confirmView.frame.size.height)];
        
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.2];
        
        _m_confirmView.hidden = NO;
        [_m_confirmView setFrame: CGRectMake(0, 0, _m_confirmView.frame.size.width, _m_confirmView.frame.size.height)];
        
        [UIView commitAnimations];
    }
    
    
}


- (IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == textFieldUsername){
        [textFieldEmail becomeFirstResponder];
    }
    if(textField == textFieldEmail){
        [textFieldPassword1 becomeFirstResponder];
    }    
    if(textField == textFieldPassword1){
        [textFieldPassword2 becomeFirstResponder];
    }
    else if(textField == textFieldPassword2){
        [textFieldFirstname becomeFirstResponder];
    }
    else if(textField == textFieldFirstname){
        [textFieldLastname becomeFirstResponder];
    }
    else if (textField == textFieldLastname){
        [textField resignFirstResponder];
    }
    else if (textField == textFieldZip){
        [textField resignFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#define kOFFSET_FOR_KEYBOARD 100.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
  /*  if (scrollView1.contentOffset.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (scrollView1.contentOffset.y < 0)
    {
        [self setViewMovedUp:NO];
    }*/
    
    if (_m_confirmView.hidden == NO)
        return;
    
    _m_btnEnter.hidden = YES;
    pickerView1.hidden = YES;
    
    [self setViewMovedUp:YES];
}

-(void)keyboardWillHide {
   /* if (scrollView1.contentOffset.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (scrollView1.contentOffset.y < 0)
    {
        [self setViewMovedUp:NO];
    }*/
    
    if (_m_confirmView.hidden == NO)
        return;

    [self setViewMovedUp:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{        //move the main view, so that the keyboard does not hide it.
    //    if  (self.view.frame.origin.y >= 0)
    //   {
    //        [self setViewMovedUp:YES];
    //   }
    
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
       // rect.origin.y -= kOFFSET_FOR_KEYBOARD;
       // rect.size.height += kOFFSET_FOR_KEYBOARD;
        [_m_scrollView setContentOffset:CGPointMake(0, _m_scrollView.contentOffset.y + kOFFSET_FOR_KEYBOARD) animated:YES];
    }
    else
    {
        // revert back to the normal state.
     //   rect.origin.y += kOFFSET_FOR_KEYBOARD;
     //   rect.size.height -= kOFFSET_FOR_KEYBOARD;
        
        [_m_scrollView setContentOffset:CGPointMake(0, _m_scrollView.contentOffset.y - kOFFSET_FOR_KEYBOARD) animated:YES];
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

//    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
//    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    [button1.layer setCornerRadius:5.0f];
//    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
//    [button2.layer setCornerRadius:5.0f];
    [textFieldUsername setText:[[NSUserDefaults standardUserDefaults]valueForKey:@"Oswald"]];
 
    [pickerView1 reloadAllComponents];
    [pickerView1 selectRow:[countryNames indexOfObject:@"United States"] inComponent:0 animated:NO];
    [self.view bringSubviewToFront:pickerView1];
    
    _m_confirmView.hidden = YES;
}
    

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

            
        if(connection){
            [connection cancel];
            connection = nil;
        }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    switchView1 = [[UICustomSwitch alloc] initWithFrame:CGRectMake(162, 412, 107, 31)];
//    [[switchView1 rightLabel] setText:@"Men"];
//    [[switchView1 leftLabel] setText:@"Ladies"];
//    [self.view addSubview:switchView1];
//    [((UIScrollView*)self.view) setContentSize:CGSizeMake(320, 650)];
    
    memset(m_anCurRow, 0, sizeof(int) * 3);
    
    countryNames = [[NSMutableArray alloc]init];
    countryIso = [[NSMutableArray alloc]init];
    
    NSString* countriesString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.thegrint.com/countries_iphone"] encoding:NSUTF8StringEncoding error:nil];
    int nCount = 0;
    for(NSString* s in [countriesString componentsSeparatedByString:@"</country>"]){
        
        if(s.length > 13){
            
            [countryIso addObject:[self stringBetweenString:@"<iso2>" andString:@"</iso2>" forString:s]];
            NSString* strCountry = [self stringBetweenString:@"<name>" andString:@"</name>" forString:s];
            [countryNames addObject:strCountry];
            if ([strCountry isEqualToString: @"United States"] == YES)
                m_anCurRow[0] = nCount;
            nCount ++;
        }
    }
    
    m_anCurRow[1] = 36;
    
    [self initializeView];
    
}

- (void) initializeView
{
    [_m_scrollView setContentSize: CGSizeMake(320, 950)];
    
    [self effectView: _m_view1 RADIUS: 5];
    [self effectView: _m_view2 RADIUS: 10];
    [self effectView: _m_view3 RADIUS: 10];
    
    [_m_btnJoin.layer setShadowColor:[UIColor blackColor].CGColor];
    [_m_btnJoin.layer setShadowOpacity:0.7];
    [_m_btnJoin.layer setShadowRadius:2];
    [_m_btnJoin.layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    
    [_m_label1 setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [_m_label2 setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    [_m_label3 setFont: [UIFont fontWithName: @"Oswald" size: 20]];
    
    [_m_btnJoin.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: 15]];
    [_m_btnCancel.titleLabel setFont: [UIFont fontWithName: @"Oswald" size: 15]];
    
    [_m_textConfirmEmail setFont: [UIFont fontWithName: @"Oswald" size: 15]];
    
    [_m_btnGetStarted.layer setShadowColor:[UIColor blackColor].CGColor];
    [_m_btnGetStarted.layer setShadowOpacity:0.7];
    [_m_btnGetStarted.layer setShadowRadius:2];
    [_m_btnGetStarted.layer setShadowOffset:CGSizeMake(-3.0, 3.0)];

}

- (void) effectView: (UIView*) view RADIUS: (CGFloat) rRad
{
    [view.layer setCornerRadius: rRad];
    
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.7];
    [view.layer setShadowRadius:2];
    [view.layer setShadowOffset:CGSizeMake(0.0, 3.0)];
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

- (IBAction)actionTakePhoto:(id)sender {
    UIAlertView* alertview = [[UIAlertView alloc] initWithTitle:@"" message:@"Add your photo" delegate:self cancelButtonTitle:@"Camera" otherButtonTitles:@"Camera Roll", nil];
    alertview.tag = 1124;
    [alertview show];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // Access the uncropped image from info dictionary

    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    UIImage* image = [self fixImage: originalImage];
    
    NSLog(@"width = %f, height=%f", image.size.width, image.size.height);
    
    [_m_photoView setImage: image];
    
    NSLog(@"width = %f, height=%f", _m_photoView.image.size.width, _m_photoView.image.size.height);

    //    [picker release];
}

- (UIImage *) fixImage:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

//- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        
//        [picker popViewControllerAnimated: YES];
//        
//        UIImagePickerController* imagePickerViewController = [[UIImagePickerController alloc] init];
//        imagePickerViewController.delegate = self;
//        imagePickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imagePickerViewController animated:YES completion:nil];
//    }
//}

- (IBAction)actionEnter:(id)sender {
    switch (m_nPickerKind) {
        case 0:
            [textFieldCountry setText: [countryNames objectAtIndex: m_anCurRow[0]]];
            break;
        case 1:
            [textFieldHandicap setText: [NSString stringWithFormat: @"%d", (m_anCurRow[1])]];
            break;
        case 2:
            [textFieldGender setText: ((m_anCurRow[2] == 1) ? @"Ladies" : @"Men")];
            break;
        default:
            break;
    }
    [pickerView1 setHidden:YES];
    _m_btnEnter.hidden = YES;
}

- (IBAction)actionAccept:(id)sender {
    _m_btnCheck.selected = !_m_btnCheck.selected;
}

- (IBAction)actionTerms:(id)sender {
    GrintVerticalWebModalViewController* controller = [[GrintVerticalWebModalViewController alloc] initWithNibName:@"GrintVerticalWebModalViewController" bundle:nil];
    controller.delegate = self;
    [self presentViewController: controller animated: YES completion:nil];
    [controller.webView1 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.thegrint.com/terms"]]];
    controller.webView1.scalesPageToFit = YES;
}

- (IBAction)actionJoin:(id)sender {
    [self dismissKeyboard];
    pickerView1.hidden = YES;
    _m_btnEnter.hidden = YES;
    
    [self registerClick: sender];
}

- (IBAction)actionCancel:(id)sender {
//    [delegate dismissViewControllerAnimated: YES completion: nil];
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)actionGetStarted:(id)sender {
    
    spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:@"https://www.thegrint.com/register_iphone/"]];
//    NSMutableURLRequest *request = [NSMutableURLRequest
//                                    requestWithURL:[NSURL URLWithString:@"http://192.168.0.177/grintsite2/register_iphone/"]];
    
    NSMutableDictionary* _params = [NSMutableDictionary dictionaryWithObjectsAndKeys: textFieldUsername.text, @"username", textFieldPassword1.text, @"password", _m_textConfirmEmail.text, @"email", textFieldHandicap.text, @"handicap", textFieldGender.text, @"gender", textFieldFirstname.text, @"fname", textFieldLastname.text, @"lname", textFieldZip.text, @"zip", [countryIso objectAtIndex: m_anCurRow[0]], @"country", @"I", @"source", nil];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSString* FileParamConstant = @"Filedata";
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSLog(@"width = %f, height=%f", _m_photoView.image.size.width, _m_photoView.image.size.height);
    
    NSData *imageData = UIImageJPEGRepresentation(_m_photoView.image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];

    
//    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        data = [NSMutableData data];
    }
}

@end
