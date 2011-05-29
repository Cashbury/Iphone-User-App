//
//  AddressAnnotation.m
//  Cashbury
//
//  Created by Basayel Said on 4/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation

@synthesize coordinate;

- (void) setTitle:(NSString*)title andSubtitle:(NSString*)subtitle {
	[mTitle release];
	mTitle = title;
	[mTitle retain];
	[mSubTitle release];
	mSubTitle = subtitle;
	[mSubTitle retain];
}

- (NSString *)subtitle{
	return [[mSubTitle retain] autorelease];
}

- (NSString *)title{
	return [[mTitle retain] autorelease];
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}

- (void) dealloc {
	[mTitle release];
	[mSubTitle release];
	[super dealloc];
}
@end