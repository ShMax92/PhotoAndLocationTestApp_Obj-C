//
//  MapVC.m
//  ITRex_TestProj_Obj-C
//
//  Created by Maxim Shirko on 23.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>

@interface MapVC ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    float radius = 5000.0;
    
    if (_photo != nil) {
        float latitude = _photo.photoLocation.latitude;
        float longitude = _photo.photoLocation.longitude;
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, radius, radius);
        [self.mapView setRegion:region];
        [self.mapView addAnnotation:annotation];
    }
    
}

@end
