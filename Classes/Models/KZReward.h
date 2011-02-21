//
//  KZReward.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPlace.h"


@interface KZReward : NSObject
{
}

- (id) initWithIdentifier:(NSString*)theIdentifier
                     name:(NSString*)theName
              description:(NSString*)theDescription
                   points:(NSUInteger)thePoints;

@property (readonly, nonatomic) NSString *identifier;
@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *description;
@property (readonly, nonatomic) NSUInteger points;

@property (nonatomic, retain) KZPlace *place;

@end
