//
//  GrintCourseDownload.m
//  grint
//
//  Created by Peter Rocker on 25/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GrintCourseDownload.h"

#import "GrintDetail2.h"

@implementation GrintCourseDownload

@synthesize username;
@synthesize detailViewController;
@synthesize locman, spinnerView;

NSArray* states;

bool receivedLoc = NO;

- (IBAction)pastCoursesClick:(id)sender{
    
    selectionMode = 3;
    
    if(!spinnerView)
        spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    receivedLoc = NO;
    
    locationEnabled = [CLLocationManager locationServicesEnabled];
    
    if(locationEnabled){
        
        NSLog(@"location services enabled");
        
        CLLocationManager* lm = [[CLLocationManager alloc]init];
        self.locman = lm;
        self.locman.delegate = (id)self;
        [self.locman startUpdatingLocation];
    }
    else{
        
        // [[[UIAlertView alloc]initWithTitle:@"Couldn't find your location" message:@"We were unable to determine your location. Using default location for now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        
        userLat = 28.0908;
        userLon = -81.9604;
        
        [self performSelector:@selector(downloadWithoutLoc) withObject:nil afterDelay:1.0];
    }

}

- (IBAction)inStateClick:(id)sender{
    picker1.hidden = NO;
    navigationBar1.hidden = NO;
}

- (IBAction)stateConfirmClick:(id)sender{
    
    [self coursesInState:sender];
    picker1.hidden = YES;
    navigationBar1.hidden = YES;
    
}

- (void)downloadWithoutLoc{
    
    if(selectionMode == 1){
        
        NSString* downloadTemp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://thegrint.com/util/appquery/?lat=%f&lon=%f&lrange=1.0", userLat, userLon]] encoding:NSUTF8StringEncoding error:nil];
        
        [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    else if(selectionMode == 2){
        
        NSString* downloadTemp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://thegrint.com/util/appquery/?state=%@", [[states objectAtIndex:[picker1 selectedRowInComponent:0 ]] substringToIndex:[[states objectAtIndex:[picker1 selectedRowInComponent:0]] rangeOfString:@" "].location]]] encoding:NSUTF8StringEncoding error:nil];
        
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] error:nil];
        
        [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
    }
    
    else if(selectionMode == 3){
        
        NSString* downloadTemp = [[NSUserDefaults standardUserDefaults]stringForKey:@"pastcourses"];
        [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
                
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintDetail2 alloc] initWithNibName:@"GrintDetail2" bundle:nil];
    }
    
    if(selectionMode == 1){
        self.detailViewController.shouldWarnGPS = YES;
    }
    
    ((GrintDetail2*)self.detailViewController).username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    ((GrintDetail2*)self.detailViewController).userLon = userLon;
    ((GrintDetail2*)self.detailViewController).userLat = userLat;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
    
    
}

- (IBAction)coursesNearMe:(id)sender{
    
    selectionMode = 1;
    
    if(!spinnerView)
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    receivedLoc = NO;
    
    locationEnabled = [CLLocationManager locationServicesEnabled];
    
    if(locationEnabled){
        NSLog(@"location services enabled");
        
        CLLocationManager* lm = [[CLLocationManager alloc]init];
        self.locman = lm;
        self.locman.delegate = (id)self;
        [self.locman startUpdatingLocation];
    }
    else{
        
       // [[[UIAlertView alloc]initWithTitle:@"Couldn't find your location" message:@"We were unable to determine your location. Using default location for now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        
        userLat = 28.0908;
        userLon = -81.9604;
        
        [self performSelector:@selector(downloadWithoutLoc) withObject:nil afterDelay:1.0];
    }
    
}

- (void)locationManager:(CLLocationManager* )manager didFailWithError:(NSError *)error{
    NSLog(@"error: %@", [error localizedDescription]);
    [manager stopUpdatingLocation];
    
 //   [[[UIAlertView alloc]initWithTitle:@"Couldn't find your location" message:@"We were unable to determine your location. Using default location for now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    
    userLat = 28.0908;
    userLon = -81.9604;
    
    [self performSelector:@selector(downloadWithoutLoc) withObject:nil afterDelay:1.0];
    
   }

- (void)locationManager:(CLLocationManager* )manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"location manager received update");
    [manager stopUpdatingLocation];
    userLat = newLocation.coordinate.latitude;
    userLon = newLocation.coordinate.longitude;
    
    if(!receivedLoc){
        receivedLoc = YES;
        
        if(selectionMode == 1){
            
            NSString* downloadTemp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://thegrint.com/util/appquery/?lat=%f&lon=%f&lrange=1.0", userLat, userLon]] encoding:NSUTF8StringEncoding error:nil];
            
            [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        }
        
        
        else if(selectionMode == 2){
            
            NSString* downloadTemp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://thegrint.com/util/appquery/?state=%@", [[states objectAtIndex:[picker1 selectedRowInComponent:0 ]] substringToIndex:[[states objectAtIndex:[picker1 selectedRowInComponent:0]] rangeOfString:@" "].location]]] encoding:NSUTF8StringEncoding error:nil];
            
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] error:nil];
            
            [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
        }
        
        else if(selectionMode == 3){
                
            NSString* downloadTemp = [[NSUserDefaults standardUserDefaults]stringForKey:@"pastcourses"];
            [downloadTemp writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/courses.dat"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
                
        }
        
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
        
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        
        if (!self.detailViewController) {
            self.detailViewController = [[GrintDetail2 alloc] initWithNibName:@"GrintDetail2" bundle:nil];
        }
        
        ((GrintDetail2*)self.detailViewController).username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
        
        ((GrintDetail2*)self.detailViewController).userLon = userLon;
        ((GrintDetail2*)self.detailViewController).userLat = userLat;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        

        
    }
    else{
    }
}


- (IBAction)coursesInState:(id)sender{
    
    selectionMode = 2;
    
    if(!spinnerView)
    spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
    receivedLoc = NO;
    
    locationEnabled = [CLLocationManager locationServicesEnabled];
    
    if(locationEnabled){
  
        NSLog(@"location services enabled");
        
        CLLocationManager* lm = [[CLLocationManager alloc]init];
        self.locman = lm;
        self.locman.delegate = (id)self;
        [self.locman startUpdatingLocation];
    }
    else{
        
     //   [[[UIAlertView alloc]initWithTitle:@"Couldn't find your location" message:@"We were unable to determine your location. Using default location for now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        
        userLat = 28.0908;
        userLon = -81.9604;
        
        [self performSelector:@selector(downloadWithoutLoc) withObject:nil afterDelay:1.0];
    }
}

- (IBAction)coursesLastDownloaded:(id)sender{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    
    if (!self.detailViewController) {
        self.detailViewController = [[GrintDetail2 alloc] initWithNibName:@"GrintDetail2" bundle:nil];
    }
    
    ((GrintDetail2*)self.detailViewController).username = [[NSUserDefaults standardUserDefaults]valueForKey:@"username"];
    
    ((GrintDetail2*)self.detailViewController).userLon = userLon;
    ((GrintDetail2*)self.detailViewController).userLat = userLat;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Download Course Info", @"Download Course Info");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
   // spinnerView = [SpinnerView loadSpinnerIntoView:self.view];
    
  //  [self coursesInState:pickerView];
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [states count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [states objectAtIndex:row];
}


#pragma mark - View lifecycle

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaultsPicker = [NSUserDefaults standardUserDefaults];
	[defaultsPicker setObject:[NSNumber numberWithInt:[picker1 selectedRowInComponent:0]] forKey:@"state"];
	[defaultsPicker synchronize];
    
    if(spinnerView){
        [spinnerView removeSpinner];
        spinnerView = nil;
    }
   
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaultsPicker = [NSUserDefaults standardUserDefaults];
	[picker1 selectRow:[(NSNumber*)[defaultsPicker objectForKey:@"state"] intValue] inComponent:0 animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    states = [NSArray arrayWithObjects:@"International Courses",
              @"AL Alabama",
              @"AK Alaska",
              @"AZ Arizona",
              @"AR Arkansas",
              @"CA California",
              @"CO Colorado",
              @"CT Connecticut",
              @"DE Delaware",
              @"FL Florida",
              @"GA Georgia",
              @"HI Hawaii",
              @"ID Idaho",
              @"IL Illinois",
              @"IN Indiana",
              @"IA Iowa",
              @"KS Kansas",
              @"KY Kentucky",
              @"LA Louisiana",
              @"ME Maine",
              @"MD Maryland",
              @"MA Massachusetts",
              @"MI Michigan",
              @"MN Minnesota",
              @"MS Mississippi",
              @"MO Missouri",
              @"MT Montana",
              @"NE Nebraska",
              @"NV Nevada",
              @"NH New Hampshire",
              @"NJ New Jersey",
              @"NM New Mexico",
              @"NY New York",
              @"NC North Carolina",
              @"ND North Dakota",
              @"OH Ohio",
              @"OK Oklahoma",
              @"OR Oregon",
              @"PA Pennsylvania",
              @"RI Rhode Island",
              @"SC South Carolina",
              @"SD South Dakota",
              @"TN Tennessee",
              @"TX Texas",
              @"UT Utah",
              @"VT Vermont",
              @"VA Virginia",
              @"WA Washington",
              @"WV West Virginia",
              @"WI Wisconsin",
              @"WY Wyoming", nil];
    
    
    [label1 setFont:[UIFont fontWithName:@"Oswald" size:18]];
    [label2 setFont:[UIFont fontWithName:@"Oswald" size:12]];
    [label3 setFont:[UIFont fontWithName:@"Oswald" size:14]];
    
    [button1.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [button1.layer setCornerRadius:5.0f];
    [button2.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [button2.layer setCornerRadius:5.0f];
    [button3.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:17]];
    [button3.layer setCornerRadius:5.0f];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeRightDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
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
