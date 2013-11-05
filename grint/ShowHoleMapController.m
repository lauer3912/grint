//
//  ShowHoleMapController.m
//  grint
//
//  Created by Mountain on 7/4/13.
//
//

#import "ShowHoleMapController.h"
#import <CoreImage/CoreImage.h>
#import "Communication.h"
#import "THLabel.h"

#import "GPUImage.h"

#import "MapViewController.h"
#import "SpinnerView.h"

#import "GSBorderLabel.h"

#define DEFAULT_LAT 25.9990
#define DEFAULT_LNG -80.1885

BOOL FRenderFinished;

@interface ShowHoleMapController ()

@end

@implementation ShowHoleMapController {
//    GMSMapView *map.mapView_;
    float m_rScale;
    int m_nFirstDraw;
    
    UIImage* m_normalImage;
    int m_nPrevHoleNumber;
    int m_nPrevCourseID;
}

@synthesize m_nDistBack, m_nDistCenter, m_nDistFront, m_nFirstDraw;

@synthesize m_dictCourseInfo, m_dictMapInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        commServer = [[Communication alloc] init];
        map = [[MapViewController alloc] initWithNibName: @"MapViewController" bundle:nil];
        map.parentController = self;
        m_nFirstDraw = 1;
        
        m_nPrevHoleNumber = -1;
        m_nPrevCourseID = -1;
    }
    return self;
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
    
    int nCourse = [[m_dictCourseInfo objectForKey: @"courseid"] integerValue];
    int nHole = [[m_dictCourseInfo objectForKey: @"holeno"] integerValue];
    
    if (nCourse != m_nPrevCourseID || nHole != m_nPrevHoleNumber) {
        [self performSelector: @selector(brightProcessOfMap) withObject: nil afterDelay: 5.0];
        m_nPrevHoleNumber = nHole;
        m_nPrevCourseID = nCourse;
    } else {
        [self performSelector: @selector(brightProcessOfMap) withObject: nil afterDelay: 2.0];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
    
    m_FZoomed = NO;
    
    FRenderFinished = YES;
    m_FFirst = YES;
    m_nStep = -1;
    

    //update code//
    [m_GPSButton.layer setCornerRadius: m_GPSButton.bounds.size.width/2];
    [m_GPSButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [m_GPSButton.layer setShadowOpacity:0.7];
    [m_GPSButton.layer setShadowRadius:2];
    [m_GPSButton.layer setShadowOffset:CGSizeMake(-3.0, 3.0)];
    
    [m_grLabel.layer setCornerRadius: m_grLabel.bounds.size.width/2];
    [m_grLabel setFont: [UIFont fontWithName:@"Oswald" size: 12]];
    [m_grLabel setText: @""];
    
    [m_grCenterLabel setFont: [UIFont fontWithName:@"Oswald" size: 30]];
    
    
    m_DistanceCenterLabel.textColor = [UIColor whiteColor];
    [m_DistanceCenterLabel setBorderColor: [UIColor blackColor]];
    [m_DistanceCenterLabel setBorderWidth: 3];
    m_DistanceCenterLabel.font = [UIFont fontWithName:@"Oswald" size:36];

    m_DistanceTeeboxLabel.textColor = [UIColor whiteColor];
    [m_DistanceTeeboxLabel setBorderColor: [UIColor blackColor]];
    [m_DistanceTeeboxLabel setBorderWidth: 3];
    m_DistanceTeeboxLabel.font = [UIFont fontWithName:@"Oswald" size:36];

//    [m_DistanceCenterLabel setFont:[UIFont fontWithName:@"Oswald" size:36]];
//    [m_DistanceCenterLabel setHidden: YES];
//    m_DistanceCenterLabel.adjustsFontSizeToFitWidth = NO;
//    [m_DistanceCenterLabel setStrokeColor:[UIColor blackColor]];
//	[m_DistanceCenterLabel setStrokeSize:2];
    
//    [m_DistanceTeeboxLabel setFont:[UIFont fontWithName:@"Oswald" size:36]];
//    [m_DistanceTeeboxLabel setHidden: YES];
//    m_DistanceTeeboxLabel.adjustsFontSizeToFitWidth = NO;
//    [m_DistanceTeeboxLabel setStrokeColor:[UIColor blackColor]];
//	[m_DistanceTeeboxLabel setStrokeSize:2];
    
    [m_HoleLabel setFont: [UIFont fontWithName:@"Oswald" size: 20]];
    m_HoleLabel.text = [NSString stringWithFormat:@"HOLE %d", [[m_dictCourseInfo objectForKey:@"holeno"] intValue]];
    m_ParLabel.text = [m_dictCourseInfo objectForKey: @"holepar"];
    
    ///////////////
    //create the locatin manager
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_locationManager.distanceFilter = kCLDistanceFilterNone;
    m_locationManager.delegate = self;
    [m_locationManager startUpdatingLocation];
    
    [self showMap];
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(zoomProcess:)];
    [m_HoleMap addGestureRecognizer: pinch];
//    swipeRecognizer = [[UISwipeGestureRecognizer alloc]	 initWithTarget:self action:@selector(swipeDetected:)];
//    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRecognizer];
    
    m_nTimeCount = 0;
    m_MapImageView.hidden = YES;
    m_CloudImageView.hidden = YES;
    m_OverlayMap.hidden = YES;

    spinnerView = [SpinnerView loadSpinnerIntoView: self.view];
}

- (void) drawMap
{
    m_MapImageView.hidden = YES;
    

//    [self performSelector: @selector(brightProcessOfMap) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [m_HoleMap addSubview: map.view];
    
    [m_HoleMap bringSubviewToFront: map.view];
    
    [m_HoleMap bringSubviewToFront: m_MapImageView];
    
    [m_HoleMap bringSubviewToFront: m_OverlayMap];
    [m_OverlayMap setFrame: CGRectMake(0, 0, m_HoleMap.frame.size.width, m_HoleMap.frame.size.height)];

    [m_HoleMap bringSubviewToFront: m_CloudImageView];
    
    [self.view setMultipleTouchEnabled: YES];
}

#define EPS_STRAIGHT 10
- (void) showCloudImage
{
//    CGPoint ptFairWay = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stFairway.dLatitute, m_stFairway.dLongitute)];
//    CGPoint ptCenter = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stGreenCenter.dLatitute, m_stGreenCenter.dLongitute)];
//    
//    int nWide = (ptFairWay.x - ptCenter.x);
//    if (abs(nWide) < EPS_STRAIGHT) {
//        [m_CloudImageView setImage: [UIImage imageNamed: @"cloud-1.png"]];
//    } else if (nWide < 0) {
//        [m_CloudImageView setImage: [UIImage imageNamed: @"cloud-2.png"]];
//    } else {
//        [m_CloudImageView setImage: [UIImage imageNamed: @"cloud-3.png"]];
//    }
}

- (void) showGrintInfo
{
    [self verifyCurLocAndAimPoint];
    
//    [self showCloudImage];
    
    [self showMarker: m_AimPointImageView LOCATION: &m_stAimPoint];
    [self showMarker: m_GreenCenterImageView LOCATION: &m_stGreenCenter];
    [self showMarker: m_TeeboxImageView LOCATION: &m_stCurrentLocation];
    
    [self showDistance];
    
    [self showHazardInfo];
}

- (void)swipeDetected:(id)sender{
    [self goBack: nil];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations && [locations count] > 0) {
        CLLocationCoordinate2D curLocation = ((CLLocation*)[locations lastObject]).coordinate;
        m_stCurrentLocation.dLatitute = curLocation.latitude;
        m_stCurrentLocation.dLongitute = curLocation.longitude;
        
        [self showGrintInfo];
    }
    
    CLLocation* newLocation = [locations lastObject];
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge>10) {
        [manager stopUpdatingLocation];
        [manager startUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D curLocation = newLocation.coordinate;
    m_stCurrentLocation.dLatitute = curLocation.latitude;
    m_stCurrentLocation.dLongitute = curLocation.longitude;
    
    [self showGrintInfo];
}

- (void) viewDidUnload
{
//    [map.mapView_ release];
    
    //[commServer release];
//    [m_locationManager stopUpdatingLocation];
}


#pragma mark - methods for converting the coordinate
//calculate by yard : 1 meter = 1.0936133 yards

- (double) getDistanceFromLatLonInM: (EarthLocation*) firstLoc SECOND: (EarthLocation*) secondLoc {
    double R = 6371000 * YARDS_PER_METER; // Radius of the earth in km
    double dLat = (PI / 180) * (secondLoc->dLatitute - firstLoc->dLatitute);  // deg2rad below
    double dLon = (PI / 180) * (secondLoc->dLongitute - firstLoc->dLongitute);
    double a = sin(dLat/2) * sin(dLat/2) + cos((PI / 180) * firstLoc->dLatitute) * cos((PI / 180) * (secondLoc->dLatitute)) * sin(dLon/2) * sin(dLon/2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = R * c; // Distance in km
    return d;
}


//convert 2d coordinate to Latitute/Longitute
- (void) convert2dToLocation: (Coordinate2D*) pstCoor2D LOCATION: (EarthLocation*) pstLocation
{
    CLLocationCoordinate2D location = [map.mapView_.projection coordinateForPoint: pstCoor2D->point];
    pstLocation->dLatitute = location.latitude;
    pstLocation->dLongitute = location.longitude;
}

//convert Latitute/Longitute to 2d coordinate
- (void) convertLocationTo2d : (EarthLocation*) pstLocation COORDINATE2D: (Coordinate2D*) pstCoor2D
{
    pstCoor2D->point = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(pstLocation->dLatitute, pstLocation->dLongitute)];
}

- (void) getCurrentLocation: (EarthLocation*) pstLocation
{
    pstLocation->dLatitute = 0L;
    pstLocation->dLongitute = 0L;
    CLLocation* loc = m_locationManager.location;
    if (!loc || !CLLocationCoordinate2DIsValid(loc.coordinate)) {
        return;
    }
    
    pstLocation->dLatitute = loc.coordinate.latitude;
    pstLocation->dLongitute = loc.coordinate.longitude;
}

#pragma mark - display the hazard info

#define TITLE_LABEL_HEIGHT 20
#define VALUE_LABEL_HEIGHT 40
#define OFFSET_HEIGHT 8

- (void) addInfoItem: (NSString*) strTitle DIST: (int) nDist
{
    UILabel* labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, m_nAddedInfoItemCount * (TITLE_LABEL_HEIGHT + VALUE_LABEL_HEIGHT + OFFSET_HEIGHT), m_infoScrollView.frame.size.width, TITLE_LABEL_HEIGHT)];
    [labelTitle setFont: [UIFont fontWithName:@"Oswald" size:13]];
    [labelTitle setTextAlignment: NSTextAlignmentCenter];
    labelTitle.text = [strTitle uppercaseString];
    [m_infoScrollView addSubview: labelTitle];

    UILabel* labelValue = [[UILabel alloc] initWithFrame: CGRectMake(0, m_nAddedInfoItemCount * (TITLE_LABEL_HEIGHT + VALUE_LABEL_HEIGHT + OFFSET_HEIGHT) + TITLE_LABEL_HEIGHT, m_infoScrollView.frame.size.width, VALUE_LABEL_HEIGHT)];
    [labelValue setFont: [UIFont fontWithName:@"Oswald" size:28]];
    [labelValue setTextAlignment: NSTextAlignmentCenter];
    labelValue.text = [NSString stringWithFormat: @"%d", nDist];
    [m_infoScrollView addSubview: labelValue];
    
    m_nAddedInfoItemCount ++;
}

- (void) showHazardInfo
{
    for (UIView* view in m_infoScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    m_nAddedInfoItemCount = 0;
        
    self.m_nDistCenter = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenCenter];
    self.m_nDistBack = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenBack];
    self.m_nDistFront = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenFront];
    
    double nDist = [self getDistanceFromLatLonInM:&m_stGreenCenter SECOND:&m_stAimPoint];
    if (nDist < 30) {
        self.m_nDistCenter = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stAimPoint];
    }
    m_grCenterLabel.text = [NSString stringWithFormat: @"%d", m_nDistCenter];
    
    [m_extra1 setFont: [UIFont fontWithName: @"Oswald" size: 12]];
    [m_extra2 setFont: [UIFont fontWithName: @"Oswald" size: 12]];
//    m_grLabel.text = [NSString stringWithFormat: @"Yards to Pin \n\n Tap go Back"];
//    m_grLabel.text = @"Yards to pin \n \n Tap for Map";
    
    [self addInfoItem: @"Green Back" DIST: m_nDistBack];
    [self addInfoItem: @"Green Center" DIST: m_nDistCenter];
    [self addInfoItem: @"Green Front" DIST: m_nDistFront];
    
    // display the hazard info list
    NSString* strName;
    EarthLocation stLoc;
    
    NSMutableArray* arrayBunkers = [[NSMutableArray alloc] init];
    NSDictionary* dictBunker = nil;
    NSArray* arrayHazard = [m_dictMapInfo objectForKey: STR_KEY_HAZARD];
    if (arrayHazard && [arrayHazard count] > 0) {
        for (int nIdx = 0; nIdx < [arrayHazard count]; nIdx ++) {
            strName = [[arrayHazard objectAtIndex: nIdx] objectForKey: @"name"];
            stLoc.dLatitute = [[[arrayHazard objectAtIndex: nIdx] objectForKey: @"lat"] doubleValue];
            stLoc.dLongitute = [[[arrayHazard objectAtIndex: nIdx] objectForKey: @"lng"] doubleValue];
            
            double dDist = [self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &stLoc];
            
            dictBunker = [NSDictionary dictionaryWithObjectsAndKeys:strName, @"name", [NSNumber numberWithInt:(int)dDist], @"dist", nil];
            [arrayBunkers addObject: dictBunker];
        }
        
        // sort the bunker by distance between user position & each bunker
        NSArray* arraySortedBunker = [arrayBunkers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary* dict1 = (NSDictionary*) obj1;
            NSDictionary* dict2 = (NSDictionary*) obj2;
            int nBig = [[dict1 objectForKey: @"dist"] intValue] - [[dict2 objectForKey: @"dist"] intValue];
            if (nBig > 0)
                return NSOrderedAscending;
            else if (nBig == 0)
                return NSOrderedSame;
            return NSOrderedDescending;
        }];
        
        for (int nIdx = 0; nIdx < [arraySortedBunker count]; nIdx ++) {
            [self addInfoItem:[[arraySortedBunker objectAtIndex: nIdx] objectForKey: @"name"] DIST: [[[arraySortedBunker objectAtIndex: nIdx] objectForKey: @"dist"] intValue]];
        }
    }
    
    [m_infoScrollView setContentSize: CGSizeMake(m_infoScrollView.frame.size.width, m_nAddedInfoItemCount * (TITLE_LABEL_HEIGHT + VALUE_LABEL_HEIGHT + OFFSET_HEIGHT))];
}

#pragma mark - loading map data and display the map, markers

//get location of special item
- (BOOL) getLocation: (NSString*) strKey Location: (EarthLocation*) pstLocation
{
    if (strKey == nil || strKey.length == 0)
        return NO;
    
    if (m_dictMapInfo) {
        if ([m_dictMapInfo objectForKey:strKey]) {
            NSDictionary* dictLoc = [m_dictMapInfo objectForKey:strKey];
            if (dictLoc) {
                pstLocation->dLatitute = [[dictLoc objectForKey: @"lat"] doubleValue];
                pstLocation->dLongitute = [[dictLoc objectForKey: @"lng"] doubleValue];
            }
            return YES;
        }
    }
    return NO;
}

// draw the line between two map point
- (void) drawDistanceLine: (CGPoint) ptFirst SECOND: (CGPoint) ptSecond
{
    CGPoint ptVector = CGPointMake(ptSecond.x - ptFirst.x, ptSecond.y - ptFirst.y);
    float rLen = sqrtf(ptVector.x * ptVector.x + ptVector.y * ptVector.y) + 0.1;
    ptVector.x /= rLen;
    ptVector.y /= rLen;
    
    CGPoint ptDrawSecond = CGPointMake(ptFirst.x + ptVector.x * (rLen - m_AimPointImageView.frame.size.width/2), ptFirst.y  + ptVector.y * (rLen - m_AimPointImageView.frame.size.width/2));
    [m_OverlayMap addPoint: ptFirst];
    [m_OverlayMap addPoint: ptDrawSecond];
}

//show the distance label
- (void) showLabel
{
    if (!m_FZoomed) {
        CGPoint ptLabel = CGPointMake((m_AimPointImageView.center.x + m_GreenCenterImageView.center.x) / 2, (m_AimPointImageView.center.y + m_GreenCenterImageView.center.y) / 2);
        m_DistanceCenterLabel.center = ptLabel;
        m_DistanceCenterLabel.text = [NSString stringWithFormat:@"%d", (int)[self getDistanceFromLatLonInM: &m_stGreenCenter SECOND: &m_stAimPoint]];
        
        ptLabel = CGPointMake((m_AimPointImageView.center.x + m_TeeboxImageView.center.x) / 2, (m_AimPointImageView.center.y + m_TeeboxImageView.center.y) / 2);
        m_DistanceTeeboxLabel.center = ptLabel;
        m_DistanceTeeboxLabel.text = [NSString stringWithFormat:@"%d", (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stAimPoint]];
    } else {
        CGPoint ptLabel = CGPointMake((m_AimPointImageView.center.x + (m_GreenCenterImageView.center.x - m_AimPointImageView.center.x) / 6), (m_AimPointImageView.center.y + (m_GreenCenterImageView.center.y - m_AimPointImageView.center.y) / 6));
        m_DistanceCenterLabel.center = ptLabel;
        m_DistanceCenterLabel.text = [NSString stringWithFormat:@"%d", (int)[self getDistanceFromLatLonInM: &m_stGreenCenter SECOND: &m_stAimPoint]];
        
        ptLabel = CGPointMake((m_AimPointImageView.center.x + (m_TeeboxImageView.center.x - m_AimPointImageView.center.x) / 6), (m_AimPointImageView.center.y + (m_TeeboxImageView.center.y - m_AimPointImageView.center.y) / 6));
        m_DistanceTeeboxLabel.center = ptLabel;
        m_DistanceTeeboxLabel.text = [NSString stringWithFormat:@"%d", (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stAimPoint]];
    }
}

- (void) showDistance
{
    [self showLabel];

//    double nDist = [self getDistanceFromLatLonInM:&m_stGreenCenter SECOND:&m_stCurrentLocation];
    double nDist = [self getDistanceFromLatLonInM:&m_stGreenCenter SECOND:&m_stAimPoint];
    if (nDist <= 30) { // compare teebox location with current location in the future
        m_DistanceCenterLabel.hidden = YES;
        m_DistanceTeeboxLabel.hidden = NO;
        
        [m_OverlayMap clear];
        [self drawDistanceLine: m_TeeboxImageView.center SECOND: m_AimPointImageView.center];
        [m_OverlayMap setNeedsDisplay];
        
        self.m_nDistCenter = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stAimPoint];
        m_grCenterLabel.text = [NSString stringWithFormat: @"%d", m_nDistCenter];

    } else {
        [m_OverlayMap clear];
        if (m_AimPointImageView.hidden == NO || m_GreenCenterImageView.hidden == NO)
            [self drawDistanceLine: m_GreenCenterImageView.center SECOND: m_AimPointImageView.center];
        if (m_AimPointImageView.hidden == NO || m_TeeboxImageView.hidden == NO)
            [self drawDistanceLine: m_TeeboxImageView.center SECOND: m_AimPointImageView.center];
        [m_OverlayMap setNeedsDisplay];
        
        m_DistanceCenterLabel.hidden = NO;
        m_DistanceTeeboxLabel.hidden = NO;

        self.m_nDistCenter = (int)[self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenCenter];
        m_grCenterLabel.text = [NSString stringWithFormat: @"%d", m_nDistCenter];
    }

}

- (void) showMarker:(UIImageView*) imgView LOCATION: (EarthLocation*) location
{
    CGPoint ptPoint =  [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(location->dLatitute, location->dLongitute)];
    
    CGRect rect = m_MapImageView.frame;
    ptPoint.x = (ptPoint.x) * m_rScale + rect.origin.x;
    ptPoint.y = (ptPoint.y) * m_rScale + rect.origin.y;
    
    [imgView setCenter: ptPoint];

//    rect = m_OverlayMap.frame;
//    CGRect rect1 = m_HoleMap.frame;
//    if (ptPoint.x < 0 || ptPoint.x > rect.size.width + 50
//        || ptPoint.y < 0 || ptPoint.y > rect.size.height + 50)
//        imgView.hidden = YES;
//    else {
//        imgView.hidden = NO;
//    }
}

- (void) loadInfo
{    
    if (m_dictMapInfo == nil)
        return;
    
    //read the location info
    [self getLocation: STR_KEY_TEEBOX Location: &m_stTeeBox];
    [self getLocation: STR_KEY_GREEN_CENTER Location: &m_stGreenCenter];
    m_stMapCenter.dLatitute = (m_stTeeBox.dLatitute + m_stGreenCenter.dLatitute) / 2 - 0.0002;
    m_stMapCenter.dLongitute = (m_stTeeBox.dLongitute + m_stGreenCenter.dLongitute) / 2;
    
    [self getLocation: STR_KEY_GREEN_FRONT Location: &m_stGreenFront];
    [self getLocation: STR_KEY_GREEN_BACK Location: &m_stGreenBack];
    if ([self getLocation:STR_KEY_FAIRWAY Location: &m_stFairway] == NO)
        m_stFairway = m_stMapCenter;
    
    m_stMapCenter.dLatitute = (m_stTeeBox.dLatitute * 1.7 + m_stGreenCenter.dLatitute + m_stFairway.dLatitute) / 3.7;
    m_stMapCenter.dLongitute = (m_stTeeBox.dLongitute * 1.7 + m_stGreenCenter.dLongitute + m_stFairway.dLongitute) / 3.7;
}

- (void) verifyCurLocAndAimPoint
{
    double nDist = [self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenCenter];
    if (nDist > 914.4) {//999 yards
        m_stCurrentLocation = m_stTeeBox;
        [m_TeeboxImageView setImage: [UIImage imageNamed: @"reddot-small.png"]];
    } else {
        [m_TeeboxImageView setImage: [UIImage imageNamed: @"bluedot-small.png"]];
    }
    
    //set User location
    CGPoint ptCurrent = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stCurrentLocation.dLatitute, m_stCurrentLocation.dLongitute)];
    CGPoint ptTeebox = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stTeeBox.dLatitute, m_stTeeBox.dLongitute)];

    if (ptCurrent.y > ptTeebox.y) {
        m_stCurrentLocation = m_stTeeBox;
    }
    
    if (m_FFirst == YES) {
        nDist = [self getDistanceFromLatLonInM: &m_stCurrentLocation SECOND: &m_stGreenCenter];
        double nDistFromTeebox = [self getDistanceFromLatLonInM: &m_stTeeBox SECOND: &m_stGreenCenter];
        
        if ([m_ParLabel.text rangeOfString: @"Par 3"].length > 0) {
            m_stAimPoint = m_stGreenCenter;
        } else {
            if (nDist > 200 && nDistFromTeebox > 200)
                m_stAimPoint = m_stFairway;
            else
                m_stAimPoint = m_stGreenCenter;
        }
        m_FFirst = NO;
    }
}

- (void) showMap
{
    
    ///load hole of course information
    [self loadInfo];
    
    float rDist = [self getDistanceFromLatLonInM: &m_stGreenCenter SECOND: &m_stTeeBox];
    
    map.m_nZoom = (rDist > 200.0f) ? ZOOM+1 : (ZOOM + 2);
    map.m_dAngle = 0;
    map.m_stMapCenter = CLLocationCoordinate2DMake(m_stMapCenter.dLatitute, m_stMapCenter.dLongitute);
    map.m_stTeebox = CLLocationCoordinate2DMake(m_stTeeBox.dLatitute, m_stTeeBox.dLongitute);
    map.m_stGreenCenter = CLLocationCoordinate2DMake(m_stGreenCenter.dLatitute, m_stGreenCenter.dLongitute);
    
    [map changeMap];
    
    CGRect rect = map.view.frame;
    rect.origin.x = -(rect.size.width - m_HoleMap.frame.size.width) / 2;
    rect.origin.y = -(rect.size.height - m_HoleMap.frame.size.height) / 2;
    map.view.frame = rect;
    
//    m_OverlayMap.frame = rect;
    
    [self calcScale];
    [self showCloudImage];
    
    m_FTouchedAimPoint = NO;
}

- (void) calcScale
{
    CGPoint ptStartPoint =  [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stTeeBox.dLatitute,  m_stTeeBox.dLongitute)];
    CGPoint ptEndPoint =  [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stGreenCenter.dLatitute,  m_stGreenCenter.dLongitute)];
    
    float rCurDist = fabsf(ptStartPoint.y - ptEndPoint.y);
    float rHeight = 404;//m_HoleMap.frame.size.height;
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        rHeight += 88;
    }
    m_rScale = (rHeight - 50) / rCurDist;
    
    m_MapImageView.frame = map.mapView_.frame;
    CGRect rect = m_MapImageView.frame;
    rect.size.height *= m_rScale;
    rect.size.width *= m_rScale;
    rect.origin.y = -(rect.size.height - rHeight - (rect.size.height - ptStartPoint.y * m_rScale - 10));
    rect.origin.x = -(rect.size.width - m_HoleMap.frame.size.width) / 2;
    if (rect.origin.y >= 0)
        rect.origin.y = 0;
    else if (rect.origin.y + rect.size.height - 20 <= rHeight)
        rect.origin.y = rHeight - rect.size.height + 20;

    [m_MapImageView setFrame: rect];
    [m_MapImageView setImage: m_normalImage];
}

#define BRIGHT_VALUE 0.2
#define CONTRAST_VALUE 3
#define REPEAT_COUNT 2

- (void) brightProcessOfMap
{
    
        UIImage* mapImage = [self imageWithView: map.mapView_];
        //brightness
        GPUImageBrightnessFilter* filterBright = [[GPUImageBrightnessFilter alloc] init];
        filterBright.brightness = BRIGHT_VALUE;
        UIImage* brightImage = [filterBright imageByFilteringImage: mapImage];

//filter

        GPUImageContrastFilter* filterContrast = [[GPUImageContrastFilter alloc] init];
        [filterContrast removeAllTargets];
        filterContrast.contrast = 1.2;
        UIImage* finalImage = [filterContrast imageByFilteringImage: brightImage];

        
        if (m_normalImage)
            m_normalImage = nil;
        m_normalImage = [finalImage copy];

        [m_MapImageView setImage: finalImage];
        
//        if (m_nTimeCount > 1) {
//        }
    
        FRenderFinished = YES;        

        [self showMarker: m_AimPointImageView LOCATION: &m_stAimPoint];
        [self showMarker: m_GreenCenterImageView LOCATION: &m_stGreenCenter];
        [self showMarker: m_TeeboxImageView LOCATION: &m_stCurrentLocation];

        [self showDistance];
        
        if (spinnerView) {
            [spinnerView removeSpinner];
            spinnerView = nil;
        }
        m_MapImageView.hidden = NO;
        m_OverlayMap.hidden = NO;
//    } else {
////        m_MapImageView.hidden = YES;
////        m_CloudImageView.hidden = YES;
//    }
}

- (UIImage*) imageWithView: (UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (UIImage*)scaleToSize:(UIImage*) image SCALE: (CGFloat)scale {
    
    CGSize size = image.size;
    size.width *= scale;
    size.height *= scale;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - touches events

#define RADIUS 25
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet* allTouches = [event allTouches];
    for (UITouch* touch in allTouches) {
        CGPoint touchPoint = [touch locationInView: m_OverlayMap];
        if (CGRectContainsPoint(m_AimPointImageView.frame, touchPoint)) {
            m_FTouchedAimPoint = YES;
            
//            [self.view removeGestureRecognizer: swipeRecognizer];

            return;
        } else {// if (m_FZoomed) {
            m_ptPrev = CGPointMake(0, 0);
            touchPoint = [touch locationInView: m_HoleMap];
            if (CGRectContainsPoint(m_HoleMap.frame, touchPoint)) {
                m_ptPrev = touchPoint;
//                [self.view removeGestureRecognizer: swipeRecognizer];
            }
        }
    }
}

- (CGPoint) convertToMapPoint : (CGPoint) ptPoint
{
    CGRect rect = m_MapImageView.frame;
    
    CGPoint ptMap = CGPointMake((ptPoint.x - rect.origin.x) / m_rScale, (ptPoint.y - rect.origin.y) / m_rScale);
    
    return ptMap;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (m_FTouchedAimPoint == YES) { // move the aim point
        NSSet* allTouches = [event allTouches];
        for (UITouch* touch in allTouches) {
            CGPoint touchPoint = [touch locationInView: self.view];
            CGRect rect = m_AimPointImageView.frame;
            if (CGRectContainsPoint(m_HoleMap.frame, touchPoint)) {
                touchPoint = [touch locationInView: m_HoleMap];

                rect.origin.x = touchPoint.x - rect.size.width / 2;
                rect.origin.y = touchPoint.y - rect.size.height - 20;
                if (rect.origin.x <= 0)
                    rect.origin.x = 0;
                if (rect.origin.x >= m_HoleMap.frame.size.width - rect.size.width)
                    rect.origin.x = m_HoleMap.frame.size.width - rect.size.width;
                
                if (rect.origin.y <= 0)
                    rect.origin.y = 0;
                if (rect.origin.y >= m_HoleMap.frame.size.height - rect.size.height)
                    rect.origin.y = m_HoleMap.frame.size.height - rect.size.height;
                
//                rect.origin.x -= m_OverlayMap.frame.origin.x;
//                rect.origin.y -= m_OverlayMap.frame.origin.y;
                
                [m_AimPointImageView setFrame: rect];
                CGPoint ptPoint = [self convertToMapPoint: m_AimPointImageView.center];
                CLLocationCoordinate2D loc = [map.mapView_.projection coordinateForPoint: ptPoint];
                m_stAimPoint.dLatitute = loc.latitude;
                m_stAimPoint.dLongitute = loc.longitude;

                [self showDistance];
                
                break;
            }
        }
    } else {//if (m_FZoomed) {
        if (m_ptPrev.x > 0 && m_ptPrev.y > 0) {
            NSSet* allTouches = [event allTouches];
    //        CGPoint ptCetner = map.mapView_.center;
            for (UITouch* touch in allTouches) {
                CGPoint touchPoint = [touch locationInView: self.view];
                if (CGRectContainsPoint(m_HoleMap.frame, touchPoint)) {
                    touchPoint = [touch locationInView: m_HoleMap];
                    CGRect rect = m_MapImageView.frame;
                    rect.origin.x += (touchPoint.x - m_ptPrev.x);
                    rect.origin.y += (touchPoint.y - m_ptPrev.y);
                    
                    if (rect.origin.x >= 0)
                        rect.origin.x = 0;
                    if (rect.origin.x + rect.size.width <= m_HoleMap.frame.size.width)
                        rect.origin.x = m_HoleMap.frame.size.width - rect.size.width;

                    if (rect.origin.y >= 0)
                        rect.origin.y = 0;
                    if (rect.origin.y + rect.size.height - 30 <= m_HoleMap.frame.size.height)
                        rect.origin.y = m_HoleMap.frame.size.height - rect.size.height + 30;

                    [m_MapImageView setFrame: rect];
                    
                    [self showMarker: m_AimPointImageView LOCATION: &m_stAimPoint];
                    [self showMarker: m_GreenCenterImageView LOCATION: &m_stGreenCenter];
                    [self showMarker: m_TeeboxImageView LOCATION: &m_stCurrentLocation];
                    
                    [self showDistance];
                    
                    m_ptPrev = touchPoint;
                    return;
                }
            }
        }
    }
}

#define SCALE_CONST 3
- (void) changeMap:(CLLocationCoordinate2D) stCenter zoom: (int) nZoom viewAngle: (double) angle
{
    CGRect rect = m_MapImageView.frame;
    rect.size.width *= SCALE_CONST;
    rect.size.height *= SCALE_CONST;
    rect.origin.x = - (rect.size.width - m_HoleLabel.frame.size.width) / 2;
    rect.origin.y = 0;//- (rect.size.height - m_HoleLabel.frame.size.height) / 2 + 60;
    [m_MapImageView setFrame: rect];
    if (!m_FZoomed) {
        [self calcScale];
        m_CloudImageView.alpha = 1;
    } else {
        m_rScale *= SCALE_CONST;
        m_CloudImageView.alpha = 0;
//        [m_OverlayMap setFrame: rect];
    }
    
    [self showMarker: m_AimPointImageView LOCATION: &m_stAimPoint];
    [self showMarker: m_GreenCenterImageView LOCATION: &m_stGreenCenter];
    [self showMarker: m_TeeboxImageView LOCATION: &m_stCurrentLocation];
    
    [self showDistance];
}

//- (void)mapView:(GMSMapView *)mapView
//didChangeCameraPosition:(GMSCameraPosition *)position
//{
//    [self brightProcessOfMap];
//}

#define MAX_ZOOM 20
- (void) doubleTapProcess: (UIGestureRecognizer*) gesture
{
    m_nStep = -m_nStep;
    
    int zoom = map.mapView_.camera.zoom;
    zoom += m_nStep;
    m_FZoomed = (m_nStep > 0) ? YES : NO;
    [self changeMap:CLLocationCoordinate2DMake(m_stMapCenter.dLatitute, m_stMapCenter.dLongitute) zoom: zoom viewAngle: map.mapView_.camera.bearing];
}

- (void) zoomProcess: (UIGestureRecognizer*) gesture
{
    UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*) gesture;
    if (pinch.scale > 1) {
        if (!m_FZoomed) {
            m_FZoomed = YES;
           [self zooming];
        }
    } else {
        if (m_FZoomed) {
            m_FZoomed = NO;
           [self zooming];
        }
    }
}

- (void) zooming
{
    [UIView beginAnimations: nil context:nil];
    [UIView setAnimationDuration: 0.5];
    if (!m_FZoomed) {
        [self calcScale];
        //m_CloudImageView.alpha = 1;
    } else {
        float rDist = [self getDistanceFromLatLonInM: &m_stGreenCenter SECOND: &m_stTeeBox];
        float rMoreZoom = (rDist < 200) ? 1.0 : 2.0;
        m_rScale *= (SCALE_CONST * rMoreZoom);

        CGRect rect = m_MapImageView.frame;
        rect.size.width *= (SCALE_CONST * rMoreZoom);
        rect.size.height *= (SCALE_CONST * rMoreZoom);
        
        CGPoint ptEndPoint = [map.mapView_.projection pointForCoordinate: CLLocationCoordinate2DMake(m_stGreenCenter.dLatitute,  m_stGreenCenter.dLongitute)];
        rect.origin.x = - ptEndPoint.x * m_rScale + m_HoleMap.frame.size.width/2;
        rect.origin.y = - ptEndPoint.y * m_rScale + m_HoleMap.frame.size.height/2;
        
        if (rect.origin.y >= 0)
            rect.origin.y = 0;
        if (rect.origin.y + rect.size.height - 30 <= m_HoleMap.frame.size.height)
            rect.origin.y = m_HoleMap.frame.size.height - rect.size.height + 30;
        
        [m_MapImageView setFrame: rect];

        m_CloudImageView.alpha = 0;
//        [m_OverlayMap setFrame: rect];
        
//        //brightness
//        GPUImageBrightnessFilter* filterBright = [[GPUImageBrightnessFilter alloc] init];
//        filterBright.brightness = - BRIGHT_VALUE / 2;
//        UIImage* brightImage = [filterBright imageByFilteringImage: m_normalImage];
        
        //filter

//        GPUImageContrastFilter* filterContrast = [[GPUImageContrastFilter alloc] init];
//        [filterContrast removeAllTargets];
//        filterContrast.contrast = 1.2;
//        UIImage* finalImage = [filterContrast imageByFilteringImage: m_normalImage];

        [m_MapImageView setImage: m_normalImage];
        m_stAimPoint = m_stGreenCenter;
    }
    
    [self showMarker: m_AimPointImageView LOCATION: &m_stAimPoint];
    [self showMarker: m_GreenCenterImageView LOCATION: &m_stGreenCenter];
    [self showMarker: m_TeeboxImageView LOCATION: &m_stCurrentLocation];
    
    [self showDistance];

    [UIView commitAnimations];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_ptPrev = CGPointMake(0, 0);
    m_FTouchedAimPoint = NO;
//    [self.view addGestureRecognizer: swipeRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_GREEN_INFO" object: self];
    
//    [m_locationManager stopUpdatingLocation];
    
//    [map release];
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated: YES];
}
@end
