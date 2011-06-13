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
#import "KZPlaceInfoViewController.h"

@interface MapViewController : UIViewController <UIActionSheetDelegate> {
	KZPlace *place;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *directionsButton;

@property (nonatomic, retain) IBOutlet UIButton *place_btn;
@property (nonatomic, retain) IBOutlet UIButton *other_btn;

@property (nonatomic, retain) KZPlaceInfoViewController *parentController;

- (IBAction)showGoogleMapsButton:(id)theSender;

- (IBAction)goBackToPlace:(id)theSender;

- (IBAction)goBacktoPlaces:(id)theSender;

- (id) initWithPlace:(KZPlace*)_place;

@end
