//
//  KZAccount.h
//  Cashbury
//
//  Created by Basayel Said on 5/11/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KZAccount : NSObject {

}

@property (retain, nonatomic) NSString *campaign_id;
@property (retain, nonatomic) NSNumber* amount;
@property (retain, nonatomic) NSString* measurement_type;
@property (nonatomic) BOOL is_money;

+ (KZAccount*) getAccountByCampaignId:(NSString*)_campaign_id;

+ (KZAccount*) setAccountWithCampaignId:(NSString*)_campaign_id
						andAmount:(NSNumber*)_amount
						andMeasurementType:(NSString*)_measurement_type
						andisMoney:(BOOL)_is_money;

+ (NSNumber*) getAccountBalanceByCampaignId:(NSString*)_campaign_id;

+ (void) updateAccountBalance:(NSNumber*)_balance withCampaignId:(NSString*)_campaign_id;

+ (void) clearAccounts;

@end
