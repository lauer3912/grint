#import "CameraViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation CameraViewController {
  GMSMapView *mapView_;
  NSTimer *timer;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.9100
                                                          longitude:116.4
                                                               zoom:18
                                                            bearing:0
                                                       viewingAngle:45];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.settings.zoomGestures = YES;
  mapView_.settings.scrollGestures = NO;
  mapView_.settings.rotateGestures = NO;
  mapView_.settings.tiltGestures = YES;

  self.view = mapView_;
}

- (void)moveCamera {
  GMSCameraPosition *camera = mapView_.camera;
//  float zoom = fmax(camera.zoom - 0.1, 11);

  GMSCameraPosition *newCamera =
      [[GMSCameraPosition alloc] initWithTarget:camera.target
                                           zoom:camera.zoom
                                        bearing:camera.bearing + 10
                                   viewingAngle:camera.viewingAngle + 10];
  [mapView_ animateToCameraPosition:newCamera];
}

- (void)viewDidAppear:(BOOL)animated {
//  timer = [NSTimer scheduledTimerWithTimeInterval:1.f/30.f
//                                           target:self
//                                         selector:@selector(moveCamera)
//                                         userInfo:nil
//                                          repeats:YES];
    mapView_.mapType = kGMSTypeSatellite;

}

- (void)viewDidDisappear:(BOOL)animated {
  [timer invalidate];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [timer invalidate];
}

@end
