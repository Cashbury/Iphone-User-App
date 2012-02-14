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
 * Fired when the balance of a business is updated.
 *
 * The info dictionary includes three keys: "totalBalance", "cashburies", and "moneyBalance"
 * each representing the value of the coressponding balance.
 *
 * The object carried in the NSNotification is an instance of
 * KZBusiness.
 */
extern NSString * const KZBusinessBalanceNotification;

/**
 * Fired when the user's savings at a business is updated.
 *
 * The info dictionary includes the an NSNumber representing
 * the user's savings at a business. The key for this value is "savings"
 *
 * The object carried in the NSNotification is an instance of
 * KZBusiness.
 */
extern NSString * const KZBusinessSavingsNotification;

@class KZPlace;

@interface KZBusiness : NSObject <KZURLRequestDelegate>
{
	NSMutableDictionary* _places;
	NSString* currency_code;
	
    NSNumber *moneyBalance;
    NSNumber *cashburies;
    NSNumber *totalBalance;
    
    NSNumber *savings;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSURL* image_url;
@property (nonatomic) BOOL has_user_id_card;

- (void) addPlace:(KZPlace *)_place;

- (float) getScore;
- (NSString*) getCurrencyCode;

// Returns the current savings
// Fires up a KZBusinessSavingsNotification when the savings balance is updated
- (NSNumber *) savingsBalance;

// Returns the total balance
// Fires up a KZBusinessBalanceNotification when the balance is updated
- (NSNumber *) totalBalance;

- (NSArray*) getPlaces;

+ (KZBusiness*) getBusinessWithIdentifier:(NSString*)_identifier 
								  andName:(NSString*)_name 
							  andImageURL:(NSURL*)_image_url;
@end
