//
//  KZPointsLibrary.m
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define POINTS @"points"

#import "KZPointsLibrary.h"

@interface KZPointsLibrary (PrivateMethods)
- (void)archive;
- (void)unarchive;
@end

@implementation KZPointsLibrary

@synthesize delegate;

//------------------------------------------
// Init & dealloc
//------------------------------------------
#pragma mark -
#pragma mark Init & dealloc

- (id) initWithRootPath:(NSString*)thePath
{
    self = [super init];
    
    if (self)
    {
        rootPath = [thePath copy];
        
        //[self unarchive];
    }
    
    return self;
}



- (void) dealloc
{
    [rootPath release];
    [pointsArray release];
    
    [super dealloc];
}

//------------------------------------------
// Public methods
//------------------------------------------
#pragma mark -
#pragma mark Public methods

- (void)setPoints:(NSUInteger)thePoints forBusiness:(NSString*)theBusinessIdentifier
{
    NSNumber *_points = [NSNumber numberWithInt:thePoints];
    
    [pointsArray setValue:_points forKey:theBusinessIdentifier];
    
    [self archive];
    
    [delegate didUpdatePointsForBusinessIdentifier:theBusinessIdentifier points:thePoints];
}

- (void) addPoints:(NSUInteger)thePoints forBusiness:(NSString*)theBusinessIdentifier
{
    NSUInteger _previousPoints = (NSUInteger) [[pointsArray valueForKey:theBusinessIdentifier] intValue];

    [self setPoints:(thePoints+_previousPoints) forBusiness:theBusinessIdentifier];
}

- (NSUInteger) pointsForBusinessIdentifier:(NSString *)theBusinessIdentifier
{
    return (NSUInteger) [[pointsArray valueForKey:theBusinessIdentifier] intValue];
}

//------------------------------------------
// Archiving
//------------------------------------------
#pragma mark -
#pragma mark Archiving

- (void) archive
{
    NSMutableData *_data = [[NSMutableData alloc] init];
    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:_data];
    
    [_archiver encodeObject:pointsArray forKey:POINTS];
    [_archiver finishEncoding];
    
    [_data writeToFile:rootPath atomically:YES];
    
    [_archiver release];
    [_data release];
}

- (void) unarchive
{
    if([[NSFileManager defaultManager] fileExistsAtPath:rootPath])
    {
        NSData *_data = [[NSData alloc] initWithContentsOfFile:rootPath];
        
        NSKeyedUnarchiver *_unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:_data];
        
        pointsArray = [[_unarchiver decodeObjectForKey:POINTS] retain];
        [_unarchiver finishDecoding];
        
        [_unarchiver release];
        [_data release];
    }
    
    if(pointsArray == nil)
    {
        pointsArray = [NSMutableDictionary new];
    }
}

@end
