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
	NSString *loading_message;
	NSString *params;
	BOOL has_loading;
	
}

@property (nonatomic, retain) id<KZURLRequestDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic) int identifier;

- (id) initRequestWithString:(NSString *)theURL andParams:(NSString*)_params delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders andLoadingMessage:(NSString*)_loading_msg;

- (void) cancel;

@end
