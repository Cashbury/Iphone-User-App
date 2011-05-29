//
//  KZOpenHours.h
//  Cashbury
//
//  Created by Basayel Said on 5/4/11.
//  Copyright 2011 Cashbury. All rights reserved.
//


@interface KZOpenHours : NSObject{
	NSString *day;
	NSString *from_time;
	NSString *to_time;
}

@property (readonly) NSString *day;
@property (readonly) NSString *from_time;
@property (readonly) NSString *to_time;

- (id) initWithDay:(NSString*)_day andFromTime:(NSString*)_from_time andToTime:(NSString*)_to_time ;

@end
