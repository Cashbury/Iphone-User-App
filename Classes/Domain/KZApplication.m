//
//  KZApplication.m
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZApplication.h"

@implementation KZApplication

static KZApplication *shared = nil;

#define API_URL    @"http://www.spinninghats.com"

static NSString *LOCAL_POINTS     = @"points.archive";
static NSString *LOCAL_PLACES     = @"places.archive";

+ (KZApplication*) shared
{
    if (shared == nil)
    {
        shared = [[KZApplication alloc] init];
    }
    
    return shared;
}

- (id) init
{
    self = [super init];

    if (self)
    {
        NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *_documentsDirectory = [_paths objectAtIndex:0];
        
        
        NSString *_localPoints = [_documentsDirectory stringByAppendingPathComponent:LOCAL_POINTS];
        NSString *_localPlaces = [_documentsDirectory stringByAppendingPathComponent:LOCAL_PLACES];
        
        pointsArchive = [[KZPointsLibrary alloc] initWithRootPath:_localPoints];
        placesArchive = [[KZPlacesLibrary alloc] initWithRootPath:_localPlaces apiURL:[NSURL URLWithString:API_URL]];
    }
    
    return self;
}

- (KZPlacesLibrary*) placesArchive { return placesArchive; }
- (KZPointsLibrary*) pointsArchive { return pointsArchive; }

@end
