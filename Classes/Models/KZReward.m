//
//  KZReward.m
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// NSCoder keys for KZReward

#define IDENTIFIER      @"identifier"
#define NAME            @"name"
#define DESCRIPTION     @"description"
#define POINTS          @"points"
#define PLACE           @"place"


#import "KZReward.h"


@implementation KZReward

@synthesize identifier, name, description, points, place;

- (id) initWithIdentifier:(NSString*)theIdentifier name:(NSString*)theName description:(NSString*)theDescription points:(NSUInteger)thePoints
{
    if (self = [super init])
    {
        identifier = [theIdentifier retain];
        name = [theName retain];
        description = [theDescription retain];
        points = thePoints;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        identifier = [[aDecoder decodeObjectForKey:IDENTIFIER] retain];
        name = [[aDecoder decodeObjectForKey:NAME] retain];
        points = [aDecoder decodeIntegerForKey:POINTS];
        place = [[aDecoder decodeObjectForKey:PLACE] retain];
        description = [[aDecoder decodeObjectForKey:DESCRIPTION] retain];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:identifier forKey:IDENTIFIER];
    [aCoder encodeObject:name forKey:NAME];
    [aCoder encodeObject:description forKey:DESCRIPTION];
    [aCoder encodeObject:place forKey:PLACE];
    [aCoder encodeInteger:points forKey:POINTS];
}

- (void) dealloc
{
    [identifier release];
    [place release];
    [name release];
    [description release];
    
    [super dealloc];
}

@end
