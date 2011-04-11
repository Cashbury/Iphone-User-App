//
//  LocationHelper.h
//  Cashbury
//
//  Created by Basayel Said on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *location_manager;
}

+ (NSString *) getLongitude;
+ (NSString *) getLatitude;

@property (nonatomic, retain) CLLocationManager *location_manager;

@end
