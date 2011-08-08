//
//  KZSnapController.h
//  Cashbery
//
//  Created by Basayel Said on 6/26/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ZXingWidgetController.h>
#import "KZUtils.h"
#import "KZSnapHandlerDelegate.h"

@interface KZSnapController : NSObject <ZXingDelegate>{

}

+ (void) cancel;

+ (ZXingWidgetController*) snapWithDelegate:(id<KZSnapHandlerDelegate>)_delegate andShowCancel:(BOOL)_show_cancel;

@property (nonatomic, assign) id<KZSnapHandlerDelegate> delegate;
@property (retain, nonatomic) ZXingWidgetController* zxing_vc;
@property (nonatomic) BOOL show_cancel;
@end
