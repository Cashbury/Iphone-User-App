//
//  KZSnapHandlerDelegate.h
//  Cashbery
//
//  Created by Basayel Said on 7/28/11.
//  Copyright 2011 Cashbury. All rights reserved.
//



@protocol KZSnapHandlerDelegate

- (void) didSnapCode:(NSString*)_code;

- (void) didCancelledSnapping;


@end
