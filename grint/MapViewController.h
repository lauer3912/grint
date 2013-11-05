//
//  MapViewController.h
//  grint
//
//  Created by Mountain on 7/12/13.
//
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>

@class ShowHoleMapController;
@interface MapViewController : UIViewController<GMSMapViewDelegate>
{
    CGPoint m_aptPoint[3];
}

@property double m_dAngle;
@property int m_nZoom;

@property (nonatomic, retain) GMSMapView* mapView_;
@property (nonatomic, retain) UIImageView* m_imgMapView;
@property (nonatomic, retain) ShowHoleMapController* parentController;

@property CLLocationCoordinate2D m_stMapCenter;
@property CLLocationCoordinate2D m_stTeebox;
@property CLLocationCoordinate2D m_stGreenCenter;

- (void) showMap;
- (void) changeMap;
- (UIImage*) imageWithView;

@end
