//
//  PlaceView.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBAsyncImageView.h"

@interface PlaceView : NSObject

@property () BOOL isOpen;
@property () BOOL isNear;
@property () NSInteger businessID;
@property () double latitude;
@property () double longitude;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *discount;
@property (nonatomic, retain) NSString *totalBalance;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *distance;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *crossStreet;
@property (nonatomic, retain) NSString *smallImgURL;

@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) UIImage *shopImage;
@property (nonatomic, retain) NSMutableArray *hoursArray;
@property (nonatomic, retain) NSMutableArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *receiptsArray;
@property (nonatomic, retain) NSMutableArray *rewardsArray;
@property (nonatomic, retain) NSMutableDictionary *accountsDict;
@end



@interface OpenHour : NSObject

@property (retain, nonatomic) NSString *fromTime;
@property (retain, nonatomic) NSString *toTime;
@property (retain, nonatomic) NSString *day;
@end




@interface PlaceImages : NSObject   

@property (retain, nonatomic) NSString *thumbURL;
@property (retain, nonatomic) NSString *mediumURL;

@end


@interface PlaceReceipt : NSObject

@property (retain, nonatomic) NSString *currentBalance;
@property (retain, nonatomic) NSString *spendMoney;
@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *dateTime;
@property (retain, nonatomic) NSString *place;
@property (retain, nonatomic) NSString *currency;

@end



@interface PlaceReward : NSObject

@property () BOOL isSpend;

@property () NSInteger campaignID;
@property () NSInteger rewardID;
@property () NSInteger numberOfRedeems;
@property (retain, nonatomic) NSString *heading1;
@property (retain, nonatomic) NSString *heading2;
@property (retain, nonatomic) NSString *rewardName;
@property (retain, nonatomic) NSString *neededAmount;
@property (retain, nonatomic) NSString *thumbImgUrl;
@property (retain, nonatomic) NSString *mediumImgUrl;
@property (retain, nonatomic) NSString *howToGet;
@property (retain, nonatomic) NSString *unlockMsg;
@property (retain, nonatomic) NSString *enjoyMsg;
@property (retain, nonatomic) NSString *legalTerm;
@property (retain, nonatomic) NSString *offerAvailableTill;
@property (retain, nonatomic) NSString *spendExchangeRule;
@property (retain, nonatomic) NSString *spendUntil;
@property (retain, nonatomic) NSString *rewardMoney;
@property (retain, nonatomic) NSString *rewardCurrency;

@end

@interface PlaceAccount : NSObject

@property() BOOL isMoney;
@property (retain, nonatomic) NSString *amount;
@property (retain, nonatomic) NSString *points;


@end
