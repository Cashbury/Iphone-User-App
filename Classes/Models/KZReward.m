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
#define PROGRAM_ID      @"program-id"
#define ENGAGEMENT_ID   @"engagement-id"

#import "KZReward.h"


@implementation KZReward

@synthesize identifier, name, description, points, place, isAutoUnlock, program_id, engagement_id, unlocked;

- (id) initWithIdentifier:
				(NSString*)theIdentifier 
				name:(NSString*)theName 
				description:(NSString*)theDescription 
				points:(NSUInteger)thePoints
				program_id:(NSString*)_program_id
				engagement_id:(NSString*)_engagement_id
{
    if (self = [super init])
    {
        identifier = [theIdentifier retain];
        name = [theName retain];
        description = [theDescription retain];
        points = thePoints;
		program_id = [_program_id retain];
		if (nil == _engagement_id || [_engagement_id isEqualToString:@""]) {
			engagement_id = nil;
		} else {
			engagement_id = [_engagement_id retain];
		}
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
		program_id = [[aDecoder decodeObjectForKey:PROGRAM_ID] retain];
		engagement_id = [[aDecoder decodeObjectForKey:ENGAGEMENT_ID] retain];
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
	[aCoder encodeObject:program_id forKey:PROGRAM_ID];
	[aCoder encodeObject:engagement_id forKey:ENGAGEMENT_ID];
}

- (void) dealloc
{
    [identifier release];
    [place release];
    [name release];
    [description release];
    [program_id release];
	[engagement_id release];
    [super dealloc];
}

@end
