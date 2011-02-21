//
//  KZStamp.h
//  Kazdoor
//
//  Created by Rami on 10/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZStamp : NSObject
{

}

- (id) initWithBusinessIdentifier:(NSString *)theBusinessIdentifier points:(NSUInteger)thePoints;

@property (readonly, nonatomic) NSString *businessIdentifier;
@property (readonly, nonatomic) NSUInteger points;

@end