//
//  KZStamp.m
//  Kazdoor
//
//  Created by Rami on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// NSCoder keys for KZPlace

#define BUSINESS_ID     @"business-id"
#define POINTS          @"points"


#import "KZStamp.h"


@implementation KZStamp

@synthesize businessIdentifier, points;

- (id) initWithBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints
{
    if (self = [super init])
    {
        businessIdentifier = [theBusinessIdentifier retain];
        points = thePoints;
    }
    
    return self;
}

- (void) dealloc
{
    [businessIdentifier release];
    
    [super dealloc];
}

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        businessIdentifier = [[aDecoder decodeObjectForKey:BUSINESS_ID] retain];
        points = [aDecoder decodeIntegerForKey:POINTS];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:businessIdentifier forKey:BUSINESS_ID];
    [aCoder encodeInteger:points forKey:POINTS];
}

@end
