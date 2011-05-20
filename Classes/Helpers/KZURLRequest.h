//
//  KZURLRequest.h
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KZURLRequest;

@protocol KZURLRequestDelegate<NSObject>

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError*)theError;
- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData*)theData;

@end

@interface KZURLRequest : NSObject
{
    NSURLConnection *connection;
}

@property (nonatomic, retain) id<KZURLRequestDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;

- (id) initRequestWithString:(NSString *)theURL delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders;
- (id) initRequestWithURL:(NSURL*)theURL delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders;

@end
