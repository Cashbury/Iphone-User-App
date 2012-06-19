//
//  Receipt.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/13/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceView.h"

@interface Receipt : NSObject

@property(retain, nonatomic) NSString *billTotal;
@property(retain, nonatomic) NSString *tipPercentage;
@property(retain, nonatomic) NSString *tipAmt;
@property(retain, nonatomic) NSString *creditused;
@property(retain, nonatomic) NSString *balanceCredit;
@property(retain, nonatomic) NSString *savedAmt;
@property(retain, nonatomic) PlaceView *place;



@end
