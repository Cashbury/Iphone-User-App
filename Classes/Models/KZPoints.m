//
//  KZPoints.m
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// NSCoder keys for KZPoints

#define REWARD    @"reward"
#define POINTS      @"points"

#import "KZPoints.h"


@implementation KZPoints

@synthesize rewardIdentifier, points;

- (id) initWithBusinessIdentifier:(NSString*)theRewardIdentifier points:(NSInteger)thePoints
{
    self = [super init];
    
    if (self)
    {
        rewardIdentifier = [theRewardIdentifier retain];
        points = thePoints;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        rewardIdentifier = [[aDecoder decodeObjectForKey:REWARD] retain];
        points = [aDecoder decodeIntegerForKey:POINTS];
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:rewardIdentifier forKey:REWARD];
    [aCoder encodeInteger:points forKey:POINTS];
}

- (void) dealloc
{
    [rewardIdentifier release];
    
    [super dealloc];
}

@end
