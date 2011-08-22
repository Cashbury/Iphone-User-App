//
//  KZURLRequest.m
//  Kazdoor
//
//  Created by Rami on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KZURLRequest.h"
#import "KZApplication.h"

@interface KZURLRequest (PrivateMethods)

- (void) initReceivedDataWithContentLength:(long long)theContentLength;

@end


@implementation KZURLRequest

@synthesize receivedData, delegate, identifier;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initRequestWithString:(NSString *)theURL andParams:(NSString*)_params delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders andLoadingMessage:(NSString*)_loading_msg {
    if (self = [super init]) {
		if (_params == nil || [_params isEqual:@""]) {
			params = nil;
		} else {
			params = [_params retain];
		}
		
        self.delegate = theDelegate;
		
		if (_loading_msg == nil || [_loading_msg isEqual:@""]) {
			loading_message = nil;
			has_loading = NO;
		} else {
			loading_message = [_loading_msg retain];
			has_loading = YES;
		}
		
        if (has_loading) [KZApplication showLoadingScreen:loading_message];
        NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:theURL]];
        
        NSArray *_keys = [theHeaders allKeys];
        
        for (NSString* _field in _keys) {
            NSString *_value = [theHeaders valueForKey:_field];
            [_request setValue:_value forHTTPHeaderField:_field];
        }
		if (params != nil) { 
			// POST
			[_request setHTTPMethod:@"POST"];
			[_request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
		}
        connection = [[NSURLConnection connectionWithRequest:_request delegate:self] retain];
		
        if (connection == nil) {
            // seems like an appropriate error message
            NSError *_error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
            if (has_loading) [KZApplication hideLoading];
            if (self.delegate != nil) [self.delegate KZURLRequest:self didFailWithError:_error];
        }
        
    }
    return self;
}



- (void)dealloc {
    [connection release];
	[loading_message release];
	[params release];
    self.delegate = nil;
	self.receivedData = nil;
    [super dealloc];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) initReceivedDataWithContentLength:(long long)theContentLength {
    if (theContentLength == NSURLResponseUnknownLength)
    {
        theContentLength = 500000;
    }
    
    self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)theContentLength];
}

//------------------------------------
// Public methods
//------------------------------------
#pragma mark -
#pragma mark Public methods

- (void) cancel
{
    [connection cancel];
	if (has_loading) [KZApplication hideLoading];
}

//------------------------------------
// NSURLConnectionDelegate methods
//------------------------------------
#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void) connection:(NSURLConnection*)theConnection didReceiveResponse:(NSURLResponse*)theResponse {
    if ([theResponse isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *_httpResponse = (NSHTTPURLResponse*) theResponse;

        NSInteger _statusCode = _httpResponse.statusCode;
        
        if (_statusCode == 200 || _statusCode == 500)
        {
            [self initReceivedDataWithContentLength:[theResponse expectedContentLength]];
        }
        else
        {
			NSString *_localizedMessage;
			if (_statusCode == 500) {
				_localizedMessage = [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease];
			} else {
				_localizedMessage = [NSHTTPURLResponse localizedStringForStatusCode:_statusCode];
			}
            // maybe expand on this for other reasonable errors that might crop up.
            NSInteger _errorCode = _statusCode == 404 ? NSURLErrorFileDoesNotExist : NSURLErrorUnknown;
            
            NSDictionary *_userInfo = [NSDictionary dictionaryWithObject:_localizedMessage forKey:NSLocalizedDescriptionKey];
            NSError *_error = [NSError errorWithDomain:NSURLErrorDomain code:_errorCode userInfo:_userInfo];
            if (has_loading) [KZApplication hideLoading];
            if (self.delegate != nil) [self.delegate KZURLRequest:self didFailWithError:_error];
            
            [connection cancel];
        }
    }
    else
    {
        [self initReceivedDataWithContentLength:[theResponse expectedContentLength]];
    }
    
}

- (void) connection:(NSURLConnection*)theConnection didReceiveData:(NSData*)theData {
    [self.receivedData appendData:theData];
}

- (void) connection:(NSURLConnection*)theConnection didFailWithError:(NSError*)theError {
	if (has_loading) [KZApplication hideLoading];
    if (self.delegate != nil) [self.delegate KZURLRequest:self didFailWithError:theError];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    if (self.delegate != nil) [self.delegate KZURLRequest:self didSucceedWithData:receivedData];
	if (has_loading) [KZApplication hideLoading];
}


@end
