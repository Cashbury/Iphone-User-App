//
//  KZBusiness.h
//  Cashbery
//
//  Created by Basayel Said on 6/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZURLRequest.h"

/**
 * Fired when the balance of a business is received.
 *
 * The info dictionary includes three keys: "totalBalance", "cashburies", and "moneyBalance"
 * each representing the value of the coressponding balance.
 *
 * The object carried in the NSNotification is an instance of
 * KZBusiness.
 */
extern NSString * const KZBusinessBalanceNotification;

@class KZPlace;

@interface KZBusiness : NSObject <KZURLRequestDelegate>
{
	NSMutableDictionary* _places;
	NSString* currency_code;
	
    NSNumber *moneyBalance;
    NSNumber *cashburies;
    NSNumber *totalBalance;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* image_url;
@property (nonatomic) BOOL has_user_id_card;

- (void) addPlace:(KZPlace *)_place;

- (float) getScore;
- (NSString*) getCurrencyCode;

// Returns $0.00 when no balance is available
// Fires up a KZBusinessBalanceNotification when the balance is updated
- (NSNumber *) moneyBalance;

- (NSArray*) getPlaces;

+ (KZBusiness*) getBusinessWithIdentifier:(NSString*)_identifier 
								  andName:(NSString*)_name 
							  andImageURL:(NSString*)_image_url;
@end
