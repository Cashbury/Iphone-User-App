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
#import "CWRingUpViewController.h"
@protocol KZEngagementHandlerDelegate <NSObject>
@optional
- (void) willDismissZXing;
@end

@interface KZEngagementHandler : NSObject <KZURLRequestDelegate, KZSnapHandlerDelegate> {
	KZURLRequest *req;
}

+ (KZEngagementHandler *) shared;

+ (ZXingWidgetController*) snap;

+ (ZXingWidgetController*) snapInPlace:(KZPlace*)_place;

+ (void) cancel;

@property (retain, nonatomic) KZPlace* place;

@property (nonatomic, assign) id<KZEngagementHandlerDelegate> delegate;

@end
