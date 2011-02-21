//
//  NSBundle+Helpers.h
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (Helpers)

- (id) loadObjectFromNibNamed:(NSString *)theNibName class:(Class)theClass owner:(id)theOwner options:(NSDictionary *)theOptions;

@end
