//
//  MapViewController.m
//  grint
//
//  Created by Mountain on 7/12/13.
//
//

#import "MapViewController.h"
#import "ShowHoleMapController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    
}
@synthesize m_imgMapView;
@synthesize mapView_;
@synthesize m_dAngle;
@synthesize m_nZoom;
@synthesize m_stMapCenter;
@synthesize m_stTeebox;
@synthesize m_stGreenCenter;

@synthesize parentController;

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
    [self showMap];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
//    [mapView_ clear];
}

//method for rotating the map : teebox at the bottom, green center at the top
- (void) preprocessMap
{
    m_aptPoint[0] = CGPointMake(mapView_.bounds.size.width / 2, mapView_.bounds.size.height / 2);
    
    //convert to 2d coordinate
    m_aptPoint[1] = [mapView_.projection pointForCoordinate: m_stTeebox]; //teebox
    m_aptPoint[2] = [mapView_.projection pointForCoordinate: m_stGreenCenter]; //greencenter
    
    [self rotateMap];
}

#define EPS 0.0001
#define PI 3.141592

- (void) rotateMap
{
    CGPoint ptVector = CGPointMake((m_aptPoint[2].x - m_aptPoint[1].x), -(m_aptPoint[2].y - m_aptPoint[1].y));
    double alpha = PI / 2;
    if (fabs(ptVector.x) > EPS) {
        alpha = atan(fabs(ptVector.y / ptVector.x));
    }
    if (ptVector.y >= 0) {
        if (ptVector.x >= 0)
            alpha = (PI/2 - alpha);
        else
            alpha = -(PI/2 - alpha);
    } else {
        if (ptVector.x >= 0)
            alpha = PI/2 + alpha;
        else
            alpha = -(PI/2 + alpha);
    }
    
    m_dAngle = alpha / PI * 180;
}

- (void) showMap
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: m_stMapCenter.latitude
                                                            longitude: m_stMapCenter.longitude
                                                                 zoom: m_nZoom
                                                              bearing: 0
                                                         viewingAngle:0];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width + 100, self.view.frame.size.height);
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    if ([UIScreen mainScreen].bounds.size.height > 500)
        rect.size.height = 548 + 300;
    else
        rect.size.height = 460 + 300;
    mapView_ = [GMSMapView mapWithFrame: rect camera:camera];
    mapView_.settings.zoomGestures = NO;
    mapView_.settings.scrollGestures = NO;
    mapView_.settings.rotateGestures = NO;
    mapView_.settings.tiltGestures = NO;
    
    mapView_.delegate = self;
//    mapView_.clearsContextBeforeDrawing = YES;
    
    mapView_.mapType = kGMSTypeSatellite;
    self.view = mapView_;

}

- (void) changeMap
{
    mapView_.hidden = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: m_stMapCenter.latitude
                                                            longitude: m_stMapCenter.longitude
                                                                 zoom: m_nZoom
                                                              bearing: 0
                                                         viewingAngle:0];
    mapView_.camera = camera;
    [self preprocessMap];
    
    camera = [GMSCameraPosition cameraWithLatitude: m_stMapCenter.latitude
                                                            longitude: m_stMapCenter.longitude
                                                                 zoom: m_nZoom
                                                              bearing: m_dAngle
                                                         viewingAngle:45];
    mapView_.camera = camera;
    mapView_.hidden = NO;
    //    mapView_.myLocationEnabled = YES;
    
}

//- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
//{
//    if (mapView_.hidden == YES) {
//
//    } else {
//        [parentController performSelector:@selector(brightProcessOfMap) withObject:nil afterDelay:1.0];
//    }
//}
//
- (UIImage*) imageWithView
{
    UIGraphicsBeginImageContext(mapView_.bounds.size);
    [mapView_.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
