//
//  KZPlacesLibrary.h
//  Kazdoor
//
//  Created by Rami on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZURLRequest.h"
#import "KZBusiness.h"
#import "PlaceView.h"
#import "KazdoorAppDelegate.h"
#import "TBXML.h"

@protocol KZPlacesLibraryDelegate

- (void) didUpdatePlaces;
- (void) didFailUpdatePlaces;

@end

@interface KZPlacesLibrary : NSObject <KZURLRequestDelegate> {
    NSURL *apiURL;
    NSString *rootPath;
    NSMutableDictionary *places;
    NSMutableDictionary *requests;
}

@property (nonatomic, assign) id<KZPlacesLibraryDelegate> delegate;

- (id) initWithRootPath:(NSString*)thePath apiURL:(NSURL*)theapiURL;

+ (NSArray*) getPlaces;
- (void) requestPlacesWithKeywords:(NSString*)keywords;

+ (KZPlacesLibrary*) shared;

+ (NSArray*) getOuterRewards;

+ (NSArray*) getNearByBusinessesWithIDCards;

@end
