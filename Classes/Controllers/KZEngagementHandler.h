//
//  KZEngagementHandler.h
//  Cashbery
//
//  Created by Basayel Said on 7/28/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZURLRequest.h"
#import "KZSnapHandlerDelegate.h"
#import "KZPlace.h"
#import <ZXingWidgetController.h>

@interface KZEngagementHandler : NSObject <KZURLRequestDelegate, KZSnapHandlerDelegate> {
	KZURLRequest *req;
}

+ (ZXingWidgetController*) snap;

+ (ZXingWidgetController*) snapInPlace:(KZPlace*)_place;

+ (void) cancel;

@property (retain, nonatomic) KZPlace* place;


@end
