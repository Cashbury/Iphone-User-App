//
//  CXMLElement+Helpers.m
//  Kazdoor
//
//  Created by Rami on 13/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CXMLElement+Helpers.h"


@implementation CXMLElement (Helpers)

- (CXMLNode *) firstNodeForXPath:(NSString *)theXPath error:(NSError **)theError
{
    NSArray *_result = [self nodesForXPath:theXPath error:theError];
    
    if([_result count] > 0)
    {
        return [_result objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

- (NSString *) stringFromChildNamed:(NSString *)theChildName
{
    NSArray *_children = [self elementsForName:theChildName];
    
    if([_children count] > 0)
    {
        return [[_children objectAtIndex:0] stringValue];    
    }
    else
    {
        return nil;
    }
}


- (CXMLElement*) getChildByName:(NSString*)child_name {
	for (CXMLElement *child in [self children]) {
		if ([child_name isEqualToString:[child name]]) {
			return child;
		}
	}
}

@end
