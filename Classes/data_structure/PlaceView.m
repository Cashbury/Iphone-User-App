//
//  PlaceView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlaceView.h"

@implementation PlaceView
@synthesize name,icon,discount,shopImage,address,distance,isNear,isOpen,hoursArray,imagesArray,latitude,longitude,currency,about,phone,crossStreet,smallImgURL,receiptsArray,businessID,rewardsArray,totalBalance;

-(id)init{
    if (self = [super init]) {
        self.hoursArray     =   [NSMutableArray array];
        self.imagesArray    =   [NSMutableArray array];
        self.receiptsArray  =   [NSMutableArray array];
        self.rewardsArray   =   [NSMutableArray array];
    }
    return self;
}

-(void)dealloc{
  
    [name release];
    [icon release];
    [distance release];
    [discount release];
    [shopImage release];
    [address release];
    [hoursArray release];
    [imagesArray release];
    [currency release];
    [about release];
    [phone release];
    [crossStreet release];
    [smallImgURL release];
    [receiptsArray release];
    [rewardsArray release];
    [totalBalance release];
      
    [super dealloc];
 
}
@end

@implementation OpenHour

@synthesize fromTime,toTime,day;

-(void)dealloc{
    
    [fromTime release];
    [toTime release];
    [day release];
    
    [super dealloc];
}

@end


@implementation PlaceImages

@synthesize thumbURL,mediumURL;

-(void)dealloc{
    
    [thumbURL release];
    [mediumURL release];
    [super dealloc];
}

@end




@implementation PlaceReceipt

@synthesize currentBalance,place,dateTime,text,type,spendMoney,currency;

-(void)dealloc{
    [currentBalance release];
    [place release];
    [dateTime release];
    [text release];
    [type release];
    [spendMoney release];
    [currency release];
    [super dealloc];
}

@end


@implementation PlaceReward

@synthesize isSpend,campaignID,numberOfRedeems,rewardID,heading1,heading2,rewardName,neededAmount,thumbImgUrl,mediumImgUrl,howToGet,unlockMsg,enjoyMsg;

-(void)dealloc{
    
    [heading1 release];
    [heading2 release];
    [rewardName release];
    [neededAmount release];
    [thumbImgUrl release];
    [mediumImgUrl release];
    [howToGet release];
    [unlockMsg release];
    [super dealloc];
}

@end








