//
//  PlaceListHeaderView.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/27/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceView.h"
#import "KazdoorAppDelegate.h"
#import "LocationHelper.h"

@protocol PlaceMapHeaderDelegate <NSObject>

-(void)expandMapView;

@end


@interface PlaceAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    BOOL isNear;
}
@property () BOOL isNear;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)locationCoordinate;
@end

@interface PlaceListHeaderView : UIView<UIScrollViewDelegate,MKMapViewDelegate>{
    NSMutableArray *placesArray;
    UIScrollView *scrollView;
    NSTimer *moveTimer;
    KazdoorAppDelegate  *appDelegate;
    BOOL isMapTouched;
    
    
}
@property (nonatomic, retain) id<PlaceMapHeaderDelegate>placeDelegate;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MKMapView *mapView;
@property ()  BOOL isMapTouched;
-(void)setbackMapView;
-(void)startTimerForCheckMap;

@end
