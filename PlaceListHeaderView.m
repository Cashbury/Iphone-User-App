//
//  PlaceListHeaderView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/27/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlaceListHeaderView.h"


@implementation PlaceAnnotation
@synthesize coordinate,title,subtitle;
@synthesize isNear;

-(id)initWithCoordinate:(CLLocationCoordinate2D)locationCoordinate{
	coordinate		=   locationCoordinate;
	return self;
}

-(NSString*)title{
	return title;
}

-(NSString*)subtitle{
	return subtitle;
}

-(void)dealloc{
    [subtitle release];
    [title release];
    [super dealloc];
}

@end


@implementation PlaceListHeaderView
@synthesize placeDelegate,mapView;
@synthesize isMapTouched;
MKCoordinateRegion placeRegion;
float valueToMove   =   0.007;


#pragma MapView Functions

-(void)removeMapLoadPlaces{
    if (isMapTouched == FALSE) {
        //hide map
        
        [self setPlacesToScrollView];
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.frame    =   CGRectMake(0.0, 0.0, 320.0, 135.0);
            self.mapView.frame  =   CGRectMake(0.0, 0.0, -320.0, 135.0);
        }completion:^(BOOL f){
            self.mapView.hidden =   TRUE;
             [self validateTimer];
        }];
    }else {
        if (checkMapTouched) {
            [checkMapTouched invalidate];
            checkMapTouched =   nil;
        }
    }
}

-(void)startTimerForCheckMap{
    isMapTouched        =   FALSE;
    checkMapTouched     =   [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeMapLoadPlaces) userInfo:nil repeats:NO];
    
}

-(void)animatemapToOriginal{
    [mapView setRegion:placeRegion animated:TRUE];
}

-(void)animateMapToDifferent{
    MKCoordinateRegion newRegion;
    newRegion.span.latitudeDelta    =   placeRegion.span.latitudeDelta;
    newRegion.span.longitudeDelta   =   placeRegion.span.longitudeDelta;
    
    newRegion.center.latitude       =   placeRegion.center.latitude+valueToMove;
    newRegion.center.longitude      =   placeRegion.center.longitude+valueToMove;
    [mapView setRegion:newRegion animated:TRUE];
    [self performSelector:@selector(animatemapToOriginal) withObject:nil afterDelay:0.2];
    
    
    
}

-(void)setbackMapView{
    MKCoordinateRegion newRegion;
    newRegion.span.latitudeDelta    =   placeRegion.span.latitudeDelta;
    newRegion.span.longitudeDelta   =   placeRegion.span.longitudeDelta;
    
    newRegion.center.latitude       =   placeRegion.center.latitude-valueToMove;
    newRegion.center.longitude      =   placeRegion.center.longitude-valueToMove;
    [mapView setRegion:newRegion animated:TRUE];
    [self performSelector:@selector(animatemapToOriginal) withObject:nil afterDelay:0.2];
}

-(void)mapTapped{
    isMapTouched    =   TRUE;
    if (checkMapTouched) {
        [checkMapTouched invalidate];
        checkMapTouched =   nil;
    }
    if (mapView.frame.size.height != 311) {
        [placeDelegate expandMapView];
        [self performSelector:@selector(animateMapToDifferent) withObject:nil afterDelay:0.1];
    }  
}

-(void)setUpPlaceMapView{
    mapView                     =   [[MKMapView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 135.0)];
    mapView.showsUserLocation   =   TRUE;
    [self addSubview:mapView];
    [mapView release];
    CLLocationCoordinate2D loc;
    loc.latitude                        =   [[LocationHelper getLatitude] doubleValue];
    loc.longitude                       =   [[LocationHelper getLongitude] doubleValue];
    MKCoordinateRegion region;
    region.center                       =   loc;
    region.span.latitudeDelta           =   0.1;
    region.span.longitudeDelta          =   0.1;
    mapView.delegate                    =   self;
    [mapView setRegion:region animated:YES]; 
    UITapGestureRecognizer *tapGesture  =   [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapTapped)];
    [mapView addGestureRecognizer:tapGesture];
    [tapGesture release];
}


//Region calculation
-(void) setMapRegionForMinLat:(double)minLatitude minLong:(double)minLongitude maxLat:(double)maxLatitude maxLong:(double)maxLongitude {
    
    placeRegion.center.latitude              =   ((minLatitude + maxLatitude) / 2);
    placeRegion.center.longitude             =   ((minLongitude + maxLongitude) / 2);
    placeRegion.span.latitudeDelta           =   (maxLatitude - minLatitude);
    placeRegion.span.longitudeDelta          =   (maxLongitude - minLongitude);
    

    valueToMove =   placeRegion.span.latitudeDelta/2;
    NSLog(@"center latitude %f Longitude %f",placeRegion.span.latitudeDelta,placeRegion.span.longitudeDelta);//
    
    
    MKCoordinateRegion tempRegion;
    tempRegion.center.latitude              =   ((minLatitude + maxLatitude) / 2)+0.001;
    tempRegion.center.longitude             =   ((minLongitude + maxLongitude) / 2)+0.005;
    tempRegion.span.latitudeDelta           =   (maxLatitude - minLatitude);
    tempRegion.span.longitudeDelta          =   (maxLongitude - minLongitude);
    
    [mapView setRegion:tempRegion animated:YES];
    
}

- (void) zoomToAnnotationsBounds:(NSArray *)annotations {
    CLLocationDegrees minLatitude       =   DBL_MAX;
    CLLocationDegrees maxLatitude       =   -DBL_MAX;
    CLLocationDegrees minLongitude      =   DBL_MAX;
    CLLocationDegrees maxLongitude      =   -DBL_MAX;
    
    for (PlaceAnnotation *annotation in annotations) {
        double annotationLat            =   annotation.coordinate.latitude;
        double annotationLong           =   annotation.coordinate.longitude;
        minLatitude                     =   fmin(annotationLat, minLatitude);
        maxLatitude                     =   fmax(annotationLat, maxLatitude);
        minLongitude                    =   fmin(annotationLong, minLongitude);
        maxLongitude                    =   fmax(annotationLong, maxLongitude);
    }
    double annotationLat            =   [[LocationHelper getLatitude] doubleValue];
    double annotationLong           =   [[LocationHelper getLongitude] doubleValue];
    minLatitude                     =   fmin(annotationLat, minLatitude);
    maxLatitude                     =   fmax(annotationLat, maxLatitude);
    minLongitude                    =   fmin(annotationLong, minLongitude);
    maxLongitude                    =   fmax(annotationLong, maxLongitude);
    [self setMapRegionForMinLat:minLatitude minLong:minLongitude maxLat:maxLatitude maxLong:maxLongitude];
}

-(void)addPlaceAnnotations{
    [mapView removeAnnotations:mapView.annotations];
    for (int i = 0; i < [appDelegate.placesArray count]; i++) {
        PlaceView *place                =   [appDelegate.placesArray objectAtIndex:i];
        if (!(place.latitude == 0 && place.longitude == 0)) {
            CLLocationCoordinate2D placeLoc;
            placeLoc.latitude               =   place.latitude;
            placeLoc.longitude              =   place.longitude;
            PlaceAnnotation *annotation     =   [[PlaceAnnotation alloc] initWithCoordinate:placeLoc];
            annotation.title                =   place.name;
            annotation.isNear               =   place.isNear;
            annotation.subtitle             =   place.address;
            [mapView addAnnotation:annotation];
            [annotation release]; 
        }
        
        
    }
    if ([mapView.annotations count] > 0) {
        [self zoomToAnnotationsBounds:mapView.annotations];
    }
    [self startTimerForCheckMap];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(PlaceAnnotation*)annotation{
    if ([annotation isKindOfClass:[PlaceAnnotation class]]) {
        static NSString *AnnotationViewID   =   @"annotationViewID";
        MKAnnotationView *annotationView    =   (MKAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        
        if (annotationView == nil){
            annotationView                  =   [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
        }
        if (annotation.isNear) {
            annotationView.image            =   [UIImage imageNamed:@"blue_pin"];
        }else {
            annotationView.image            =   [UIImage imageNamed:@"green_pin"];
        }
        
        annotationView.canShowCallout       =   YES;
        annotationView.annotation           =   annotation;
        return annotationView;
    }
    return nil;
    
    
}




#pragma mark Scroll Functions

-(void)setUpScrollView{
    
    scrollView  =   [[UIScrollView alloc] initWithFrame:CGRectMake(320.0, 0.0, 320.0, 135.0)];
    scrollView.pagingEnabled    =   TRUE;
    scrollView.scrollEnabled    =   TRUE;
    scrollView.showsVerticalScrollIndicator     =   FALSE;
    scrollView.showsHorizontalScrollIndicator   =   FALSE;
    [self addSubview:scrollView];
    [scrollView release];
    
}


-(void)movePlaces{
    
    [scrollView scrollRectToVisible:CGRectMake(scrollView.contentOffset.x+320,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height) animated:TRUE]; 
    
    if (scrollView.contentOffset.x == placesArray.count * 320) {         
        [scrollView scrollRectToVisible:CGRectMake(0.0,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];         
    }
}

- (void)addPlace:(PlaceView*)place atPosition:(NSInteger)position withTag:(NSInteger)cTag {
    
    
    UIView *containerView           =   [[UIView alloc] initWithFrame:CGRectMake(position, 0, 320, 135)];
    [containerView setUserInteractionEnabled:TRUE];
    containerView.tag               =   cTag;
    
    UIImageView *shopImage          =   [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    shopImage.image                 =   place.shopImage;
    [containerView addSubview:shopImage];
    [shopImage release];
    
    UIImageView *iconImage          =   [[UIImageView alloc] initWithFrame:CGRectMake(6, 77, 42, 42)];
    iconImage.image                 =   place.icon;
    [containerView addSubview:iconImage];
    [iconImage release];
    
    UILabel *shopName               =   [[UILabel alloc]initWithFrame:CGRectMake(56.0, 78.0, 249.0, 20.0)];
    shopName.backgroundColor        =   [UIColor clearColor];
    shopName.font                   =   [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    shopName.textColor              =   [UIColor whiteColor];
    shopName.text                   =   place.name;
    shopName.textAlignment          =   UITextAlignmentLeft;
    [containerView addSubview:shopName];
    [shopName release];
    
    UILabel *discountLabel          =   [[UILabel alloc]initWithFrame:CGRectMake(56.0, 99, 249.0, 15.0)];
    discountLabel.backgroundColor   =   [UIColor clearColor];
    discountLabel.font              =   [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    discountLabel.textColor         =   [UIColor whiteColor];
    discountLabel.text              =   place.discount;
    discountLabel.textAlignment     =   UITextAlignmentLeft;
    [containerView addSubview:discountLabel];
    [discountLabel release];
    
    [scrollView addSubview:containerView];
    [containerView release];
    
    
    
}


-(void)setPlacesToScrollView{
    
    CGFloat xValue              =   320;
    scrollView.delegate         =   self;
    scrollView.contentSize      =   CGSizeMake(([placesArray count] +2) * 320, scrollView.frame.size.height);    
	[scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO]; 
    
    PlaceView *lastPlace       =   [placesArray lastObject];
    [self addPlace:lastPlace atPosition:0 withTag:[placesArray count]];
    
    for (int i = 0; i < [placesArray count]; i ++) {
        PlaceView *place        =   [placesArray objectAtIndex:i];
        [self addPlace:place atPosition:xValue withTag:i+1];
        xValue                  =   xValue + 320;   
    }
    
    PlaceView *firstPlace       =   [placesArray objectAtIndex:0];
    [self addPlace:firstPlace atPosition:xValue withTag:1];
   
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self invalidateTimer];
    [self performSelector:@selector(validateTimer) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender 
{
	if (scrollView.contentOffset.x == 0) {         
		[scrollView scrollRectToVisible:CGRectMake(placesArray.count * 320,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];     
	}    
	else if (scrollView.contentOffset.x == (placesArray.count +1) * 320) {         
		[scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height) animated:NO];         
	}
}

-(void)invalidateTimer{
    if (isMapTouched == FALSE) {
        if (moveTimer) {
            [moveTimer invalidate];
            moveTimer   =   nil;
        }
    }    
}

-(void)validateTimer{
    if (isMapTouched == FALSE) {
        if (moveTimer == nil) {
            moveTimer   =   [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(movePlaces) userInfo:nil repeats:YES];
        }
    }
        
}

-(void)addPlacesToArray{
    for (int i = 0; i < 4; i ++) {
        PlaceView *place    =   [[PlaceView alloc]init];
        switch (i) {
            case 0:
                place.name      =   @"Coupa Cafe";
                place.discount  =   @"$ 10 OFF . Open . 50m away";
                place.icon      =   [UIImage imageNamed:@"coupaIcon"];
                place.shopImage =   [UIImage imageNamed:@"coupaimg"];
                break;
            case 1:
                place.name      =   @"Samovar";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_3"];
                place.shopImage =   [UIImage imageNamed:@"bg_3"];
                
                break;
            case 2:
                place.name      =   @"La Bounlange";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_2"];
                place.shopImage =   [UIImage imageNamed:@"bg_2"];
                
                break;
            case 3:
                place.name      =   @"Al Falamanki";
                place.discount  =   @"$ 10 OFF . 100m away";
                place.icon      =   [UIImage imageNamed:@"icon_1"];
                place.shopImage =   [UIImage imageNamed:@"bg_1"];
                
                break;
                
            default:
                break;
        }
        [placesArray addObject:place];
        [place release];
        
    }
}
#pragma mark Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //Scroll view
        appDelegate     =   [[UIApplication sharedApplication] delegate];
        placesArray     =   [[NSMutableArray alloc] init];
        isMapTouched    =   FALSE;
        [self setUpScrollView];
        [self addPlacesToArray];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidateTimer) name:@"InvalidatePlaceTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateTimer) name:@"ValidatePlaceTimer" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPlaceAnnotations) name:@"UpdatePlacesView" object:nil];

        //map view
        [self performSelector:@selector(setUpPlaceMapView) withObject:nil afterDelay:0.3];
    }
    return self;
}

-(void)dealloc{
    [placeDelegate release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
