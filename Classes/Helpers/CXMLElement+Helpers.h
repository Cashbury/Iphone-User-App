//
//  CXMLElement+Helpers.h
//  Kazdoor
//
//  Created by Rami on 13/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

@interface CXMLElement (Helpers) 

- (CXMLNode *) firstNodeForXPath:(NSString* )theXPath error:(NSError **)theError;

- (NSString *) stringFromChildNamed:(NSString *)theChildName;

- (CXMLElement*) getChildByName:(NSString*)child_name;

@end
