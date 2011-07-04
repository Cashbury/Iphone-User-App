//
//  KZSnapController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KZPlace.h"
#import "KZApplication.h"
#import <ZXingWidgetController.h>
#import "KZURLRequest.h"
#import "KZAccount.h"
#import "EngagementSuccessViewController.h"
#import "KZUtils.h"
#import "KZReward.h"

@interface KZSnapController : NSObject <KZURLRequestDelegate, ZXingDelegate>{
	KZURLRequest *req;
}

- (void) cancel;

+ (void) snapInPlace:(KZPlace*)_place;
@property (retain, nonatomic) KZPlace* place;
@property (retain, nonatomic) ZXingWidgetController* zxing_vc;

@end
