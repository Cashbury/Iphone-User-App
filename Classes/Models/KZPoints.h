//
//  KZPoints.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZPoints : NSObject
{
}

- (id) initWithBusinessIdentifier:(NSString*)theBusinessIdentifier points:(NSInteger)thePoints;

@property (readonly, nonatomic) NSString *rewardIdentifier;
@property (readonly, nonatomic) NSInteger points;

@end
