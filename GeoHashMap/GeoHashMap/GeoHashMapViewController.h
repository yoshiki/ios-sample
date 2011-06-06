//
//  GeoHashMapViewController.h
//  GeoHashMap
//
//  Created by Yoshiki Kurihara on 11/06/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "geohash.h"

@interface GeoHashMapViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UISearchBar *searchBar;
    CLLocation *_location;
    MKPointAnnotation *_pointAnnotation;
    MKPolygon *_polygon;
}

- (void)addPointAnnotation;
- (void)addOverlayWithGeohash:(NSString *)geohash;

- (NSString *)geohashWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (GeoCoord)geocoordWithGeohash:(NSString *)geohash;
- (CLLocation *)cllocationWithGeohash:(NSString *)geohash;

@end
