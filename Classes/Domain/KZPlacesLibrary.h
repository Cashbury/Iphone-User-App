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

// add a CLLocation parameter to retrieve places near a certain x/y
- (void) requestPlacesWithKeywords:(NSString*)keywords;


+ (KZPlacesLibrary*) shared;


////// Returns a list of rewards retrieved from all places to be shown on the outer cashburies screen.
+ (NSArray*) getOuterRewards;

+ (NSArray*) getNearByBusinessesWithIDCards;

@end
