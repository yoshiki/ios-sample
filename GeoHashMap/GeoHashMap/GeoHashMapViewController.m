//
//  GeoHashMapViewController.m
//  GeoHashMap
//
//  Created by Yoshiki Kurihara on 11/06/05.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeoHashMapViewController.h"

#define SCOPE_GEOHASH 0
#define SCOPE_ADDRESS 1

@implementation GeoHashMapViewController

- (void)dealloc
{
    [mapView release], mapView = nil;
    [_pointAnnotation release], _pointAnnotation = nil;
    [_location release], _location = nil;
    [super dealloc];
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapGesture:)];  
	[mapView addGestureRecognizer:tapGesture];  
	[tapGesture release];  
    
    // 都庁前
    NSString *geohash = @"xn774c0";
    _location = [self cllocationWithGeohash:geohash];
    [mapView setCenterCoordinate:_location.coordinate animated:YES];

    MKCoordinateRegion cr = mapView.region;
    cr.center = _location.coordinate;
    cr.span.latitudeDelta = 0.01;
    cr.span.longitudeDelta = 0.01;
    [mapView setRegion:cr animated:YES];

    [self addPointAnnotation];
    [self addOverlayWithGeohash:geohash];

    searchBar.text = geohash;
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

- (void) handleTapGesture:(UITapGestureRecognizer*)sender {  
	CGPoint location = [sender locationInView:mapView];
	CLLocationCoordinate2D touched = [mapView convertPoint:location toCoordinateFromView:mapView];
    NSString *geohash = [self geohashWithLatitude:touched.latitude longitude:touched.longitude];
    _location = [self cllocationWithGeohash:geohash];
    [mapView setCenterCoordinate:_location.coordinate animated:YES];
    [self addPointAnnotation];
    [self addOverlayWithGeohash:geohash];
    searchBar.text = geohash;
} 

- (NSString *)geohashWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    char *geohash = geohash_encode(latitude, longitude, 7);
    return [NSString stringWithCString:geohash encoding:NSUTF8StringEncoding];
}

- (GeoCoord)geocoordWithGeohash:(NSString *)geohash
{
    return geohash_decode((char *)[geohash cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (CLLocation *)cllocationWithGeohash:(NSString *)geohash
{
    GeoCoord gc = [self geocoordWithGeohash:geohash];
    return [[[CLLocation alloc] initWithLatitude:gc.latitude
                                       longitude:gc.longitude] autorelease];
}

- (void)addPointAnnotation
{
    if (_pointAnnotation != nil)
        [mapView removeAnnotation:_pointAnnotation];
    _pointAnnotation = [[MKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = _location.coordinate;
    [mapView addAnnotation:_pointAnnotation];
}

- (void)addOverlayWithGeohash:(NSString *)geohash
{
    if (_polygon != nil)
        [mapView removeOverlay:_polygon];
    GeoCoord gc = [self geocoordWithGeohash:geohash];
    CLLocationCoordinate2D coordinates[4];
    coordinates[0] = CLLocationCoordinate2DMake(gc.north, gc.west);
    coordinates[1] = CLLocationCoordinate2DMake(gc.north, gc.east);
    coordinates[2] = CLLocationCoordinate2DMake(gc.south, gc.east);
    coordinates[3] = CLLocationCoordinate2DMake(gc.south, gc.west);
    
    _polygon = [MKPolygon polygonWithCoordinates:coordinates count:4];
    [mapView addOverlay:_polygon];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolygonView *view = [[[MKPolygonView alloc] initWithOverlay:overlay] autorelease];
    view.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    view.strokeColor = [UIColor blueColor];
    view.lineWidth = 1.0;
    return view;
}

#pragma marp - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
    NSString *geohash = searchBar_.text;
    switch (searchBar_.selectedScopeButtonIndex) {
        case SCOPE_GEOHASH:
            _location = [self cllocationWithGeohash:geohash];
            [mapView setCenterCoordinate:_location.coordinate animated:YES];
            [self addPointAnnotation];
            [self addOverlayWithGeohash:geohash];
            break;
        case SCOPE_ADDRESS:
            break;
        default:
            break;
    }
    [searchBar_ setShowsCancelButton:NO animated:YES];
    [searchBar_ setShowsScopeBar:NO];
    [searchBar_ sizeToFit];
    [searchBar_ resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar_
{
    [searchBar_ setShowsCancelButton:YES animated:YES];
    [searchBar_ setShowsScopeBar:YES];
    [searchBar_ sizeToFit];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar_
{
    [searchBar_ setShowsCancelButton:NO animated:YES];
    [searchBar_ setShowsScopeBar:NO];
    [searchBar_ sizeToFit];
    [searchBar_ resignFirstResponder];
}

@end
