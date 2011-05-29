//
//  MapViewController.h
//  Cashbury
//
//  Created by Basayel Said on 4/27/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"

@interface MapViewController : UIViewController <UIActionSheetDelegate> {
	KZPlace *place;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)showGoogleMapsButton:(id)theSender;
- (IBAction)doClose:(id)theSender;

- (id) initWithPlace:(KZPlace*)_place;

@end
