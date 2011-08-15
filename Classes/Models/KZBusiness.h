//
//  KZBusiness.h
//  Cashbery
//
//  Created by Basayel Said on 6/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPlace.h"

@class KZPlace;

@interface KZBusiness : NSObject {
	NSMutableDictionary* _places;
	NSString* currency_symbol;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* image_url;
@property (nonatomic) BOOL has_user_id_card;

- (void) addPlace:(KZPlace *)_place;

- (float) getScore;
- (NSString*) getCurrencySymbol;

- (NSArray*) getPlaces;

+ (KZBusiness*) getBusinessWithIdentifier:(NSString*)_identifier 
								  andName:(NSString*)_name 
							  andImageURL:(NSString*)_image_url;
@end
