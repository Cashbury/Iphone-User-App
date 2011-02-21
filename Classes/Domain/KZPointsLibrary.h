//
//  KZPointsLibrary.h
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KZPointsLibraryDelegate
- (void)didUpdatePointsForBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints;
@end


@interface KZPointsLibrary : NSObject
{
    NSString *rootPath;
    NSMutableDictionary *pointsArray;
}

@property (nonatomic, assign) id<KZPointsLibraryDelegate> delegate;

- (id) initWithRootPath:(NSString*)thePath;

- (void) setPoints:(NSUInteger)thePoints forBusiness:(NSString*)theBusinessIdentifier;

- (void) addPoints:(NSUInteger)thePoints forBusiness:(NSString*)theBusinessIdentifier;

- (NSUInteger)pointsForBusinessIdentifier:(NSString*)theBusinessIdentifier;

@end
