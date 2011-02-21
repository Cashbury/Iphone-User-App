//
//  NSBundle+Helpers.m
//  Kazdoor
//
//  Created by Rami on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSBundle+Helpers.h"


@implementation NSBundle (Helpers)

- (id) loadObjectFromNibNamed:(NSString *)theNibName class:(Class)theClass owner:(id)theOwner options:(NSDictionary *)theOptions
{
    NSArray *_nib = [self loadNibNamed:theNibName owner:theOwner options:theOptions];
    
    for(id _object in _nib)
    {
        if([_object isKindOfClass:theClass])
        {
            return _object;
        }
    }
    
    return nil; // not found
}

@end
