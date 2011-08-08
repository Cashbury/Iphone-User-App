//
//  KZBusiness.m
//  Cashbery
//
//  Created by Basayel Said on 6/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZBusiness.h"


@implementation KZBusiness

@synthesize identifier, name, image_url, has_user_id_card;

static NSMutableDictionary* _businesses = nil;

- (id) initWithIdentifier:(NSString*)_identifier 
				  andName:(NSString*)_name 
			  andImageURL:(NSString*)_image_url 
{
	if (self = [self init]) {
		self.identifier = _identifier;
		self.name = _name;
		self.image_url = _image_url;
		_places = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void) dealloc {
	self.identifier = nil;
	self.name = nil;
	self.image_url = nil;
	[_places release];
	
	[super dealloc];
}

- (void) addPlace:(KZPlace*)_place 
{
	_place.business = self;
	[_places setObject:_place forKey:_place.identifier];
}

- (NSArray*) getPlaces 
{
	return (NSArray*)_places;
}


+ (KZBusiness*) getBusinessWithIdentifier:(NSString*)_identifier 
								  andName:(NSString*)_name 
							  andImageURL:(NSString*)_image_url 
{
	KZBusiness* biz;
	if (_businesses == nil) {
		_businesses = [[NSMutableDictionary alloc] init];
	}
	if (_identifier == nil || [_identifier isEqual:@""] == YES) return nil;
	if ((biz = [_businesses objectForKey:_identifier]) == nil) {
		biz = [[KZBusiness alloc] initWithIdentifier:_identifier andName:_name andImageURL:_image_url];
		[_businesses setObject:biz forKey:_identifier];
		[biz release];
	}
	return biz;
}
				
@end
