//
//  BusinessDetails.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/25/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZURLRequest.h"
#import "PlaceView.h"
#include "TBXML.h"

@interface BusinessDetails : NSObject<KZURLRequestDelegate>

@property (retain, nonatomic) PlaceView *placeView;
- (id)initWithPlaceView:(PlaceView*)place;

@end
