//
//  KZBusiness.m
//  Cashbery
//
//  Created by Basayel Said on 6/21/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "KZBusiness.h"
#import "KZPlace.h"
#import "KZReward.h"
#import "KZAccount.h"
#import "KZUserInfo.h"
#import "KZApplication.h"
#import "CXMLDocument.h"
#import "CXMLElement+Helpers.h"

// Notifications

NSString * const KZBusinessBalanceNotification     = @"KZBusinessBalanceNotification";
NSString * const KZBusinessSavingsNotification     = @"KZBusinessSavingsNotification";

#define MONEY_BALANCE_REQUEST_ID    345
#define SAVINGS_REQUEST_ID          567


@interface KZBusiness (PrivateMethods)
- (void) parseBalanceXMLData:(NSData *)theData;
- (void) parseSavingsXMLData:(NSData *)theData;
@end


@implementation KZBusiness

@synthesize identifier, name, image_url, has_user_id_card;

static NSMutableDictionary* _businesses = nil;

- (id) initWithIdentifier:(NSString*)_identifier 
				  andName:(NSString*)_name 
			  andImageURL:(NSURL*)_image_url 
{
	if (self = [self init]) {
		self.identifier = _identifier;
		self.name = _name;
		self.image_url = _image_url;
		_places = [[NSMutableDictionary alloc] init];
		currency_code = nil;
        
        moneyBalance = [[NSNumber numberWithFloat:0.00] retain];
        cashburies = [[NSNumber numberWithFloat:0.00] retain];
        totalBalance = [[NSNumber numberWithFloat:0.00] retain];
        
        savings = [[NSNumber numberWithFloat:0.00] retain];
	}
	return self;
}


- (void) dealloc {
	self.identifier = nil;
	self.name = nil;
	self.image_url = nil;
	[_places release];
	[currency_code release];
    
    [moneyBalance release];
    [cashburies release];
    [totalBalance release];
    [savings release];
    
	[super dealloc];
}

- (void) addPlace:(KZPlace*)_place 
{
	_place.business = self;
	[_places setObject:_place forKey:_place.identifier];
}

- (NSArray*) getPlaces 
{
	return (NSArray*)[_places allValues];
}


- (float) getScore {
	NSArray* arr_places = [self getPlaces];
	NSString* spend_campaign_id = nil;
	float rule = 0.0;
	int i, n;
	for (n = [arr_places count]-1; n >= 0; n--) {
		KZPlace* p = (KZPlace*)[arr_places objectAtIndex:n];
		NSArray* arr_rewards = [p getRewards];
		for (i = [arr_rewards count]-1; i >= 0; i--) {
			KZReward* r = (KZReward*)[arr_rewards objectAtIndex:i];
			if (r.isSpendReward) {
				if (currency_code == nil) currency_code = [r.reward_currency_symbol copy];
				spend_campaign_id = r.campaign_id;
				rule = r.spend_exchange_rule;
				break;
			}
		}
	}
	if (spend_campaign_id != nil && rule > 0.0) {
		return [[KZAccount getAccountBalanceByCampaignId:spend_campaign_id] floatValue] / rule;
	} else {
		return 0.0;
	}
}

- (NSNumber *) savingsBalance
{
    NSString *_authToken = [KZUserInfo shared].auth_token;
    NSString *_urlString = [NSString stringWithFormat:@"%@/users/businesses/savings.xml?auth_token=%@&id=%@", API_URL, _authToken, self.identifier];
    
    NSMutableDictionary *_headers = [[[NSMutableDictionary alloc] init] autorelease];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *_request = [[KZURLRequest alloc] initRequestWithString:_urlString
                                                               andParams:nil
                                                                delegate:self
                                                                 headers:_headers
                                                       andLoadingMessage:nil];
    
    _request.identifier = SAVINGS_REQUEST_ID;
    
    return savings;
}

- (NSNumber *) totalBalance
{
    NSString *_authToken = [KZUserInfo shared].auth_token;
    NSString *_urlString = [NSString stringWithFormat:@"%@/users/businesses/balance.xml?auth_token=%@&id=%@", API_URL, _authToken, self.identifier];
    
    NSMutableDictionary *_headers = [[[NSMutableDictionary alloc] init] autorelease];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *_request = [[KZURLRequest alloc] initRequestWithString:_urlString
                                                               andParams:nil
                                                                delegate:self
                                                                 headers:_headers
                                                       andLoadingMessage:nil];
    
    _request.identifier = MONEY_BALANCE_REQUEST_ID;
    
    return totalBalance;
}


- (NSString*) getCurrencyCode {
	if (currency_code == nil) {
		[self getScore];
	}
	return [[currency_code retain] autorelease];
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

#pragma - Private methods

- (void) parseBalanceXMLData:(NSData *)theData
{
    CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
    
    CXMLElement *_rootElement = [_document rootElement];
    
    if ([_rootElement nodeForXPath:@"/hash/error" error:nil] != nil)
    {
        NSString *_errorMessage = [[_rootElement nodeForXPath:@"/hash/error" error:nil] stringValue];
        
        NSLog(@"Error retrieving balance for %@ (ID: %@): %@", self.name, self.identifier, _errorMessage);
    }
    
    if ([_rootElement nodeForXPath:@"/hash/balance" error:nil] != nil)
    {
        CXMLNode *_cashburies = [_rootElement nodeForXPath:@"/hash/cashburies" error:nil];
        CXMLNode *_moneyBalance = [_rootElement nodeForXPath:@"/hash/cash" error:nil];
        CXMLNode *_totalBalance = [_rootElement nodeForXPath:@"/hash/balance" error:nil];
        
        [cashburies release];
        [moneyBalance release];
        [totalBalance release];
        
        cashburies = [[NSNumber numberWithFloat:[[_cashburies stringValue] floatValue]] retain];
        moneyBalance = [[NSNumber numberWithFloat:[[_moneyBalance stringValue] floatValue]] retain];
        totalBalance = [[NSNumber numberWithFloat:[[_totalBalance stringValue] floatValue]] retain];
    }
    
    NSArray *_keys = [NSArray arrayWithObjects:@"cashburies", @"moneyBalance", @"totalBalance", nil];
    NSArray *_values = [NSArray arrayWithObjects:cashburies, moneyBalance, totalBalance, nil];
    
    NSMutableDictionary *_userInfo = [NSDictionary dictionaryWithObjects:_values forKeys:_keys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KZBusinessBalanceNotification object:self userInfo:_userInfo];
}

- (void) parseSavingsXMLData:(NSData *)theData
{
    CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
    
    CXMLElement *_rootElement = [_document rootElement];
    
    if ([_rootElement nodeForXPath:@"/hash/error" error:nil] != nil)
    {
        NSString *_errorMessage = [[_rootElement nodeForXPath:@"/hash/error" error:nil] stringValue];
        
        NSLog(@"Error retrieving balance for %@ (ID: %@): %@", self.name, self.identifier, _errorMessage);
    }
    
    if ([_rootElement nodeForXPath:@"/hash/total-savings" error:nil] != nil)
    {
        CXMLNode *_savings = [_rootElement nodeForXPath:@"/hash/total-savings" error:nil];
        
        [savings release];
        
        savings = [[NSNumber numberWithFloat:[[_savings stringValue] floatValue]] retain];
    }
    
    NSMutableDictionary *_userInfo = [NSDictionary dictionaryWithObject:savings forKey:@"savings"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KZBusinessSavingsNotification object:self userInfo:_userInfo];
}

#pragma - KZURLRequest delegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData
{
    if (theRequest.identifier == MONEY_BALANCE_REQUEST_ID)
    {
        [self parseBalanceXMLData:theData];
    }
    else
    {
        [self parseSavingsXMLData:theData];
    }
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError
{
    NSLog(@"Request: %@", theRequest);
    
    NSLog(@"Error: %@", theError);
}
				
@end
