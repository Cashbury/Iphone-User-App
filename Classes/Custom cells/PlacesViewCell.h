//
//  PlacesViewCell.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/8/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KazdoorAppDelegate.h"


@protocol PlaceMapViewDelegate <NSObject>

-(void)expandMapview;

@end


@interface PlaceAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    BOOL pinDrop;
}
@property () BOOL pinDrop;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* subtitle;
@end


@interface PlacesViewCell : UITableViewCell<UIScrollViewDelegate,MKMapViewDelegate>{
    
    NSTimer *moveTimer;
    KazdoorAppDelegate  *appDelegate;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) NSMutableArray *placesArray;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) id<PlaceMapViewDelegate>mapdelegate;

@end
