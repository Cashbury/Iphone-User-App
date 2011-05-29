//
//  AddressAnnotation.h
//  Cashbury
//
//  Created by Basayel Said on 4/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubTitle;
}
- (void) setTitle:(NSString*)title andSubtitle:(NSString*)subtitle;
@end
