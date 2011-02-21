//
//  KZApplication.h
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPlacesLibrary.h"
#import "KZPointsLibrary.h"

@interface KZApplication : NSObject
{
    KZPlacesLibrary *placesArchive;
    KZPointsLibrary *pointsArchive;
}

+ (KZApplication*) shared;

- (KZPlacesLibrary*) placesArchive;
- (KZPointsLibrary*) pointsArchive;

@end
