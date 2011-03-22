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

@synthesize receivedData, delegate;

//------------------------------------
// Init & dealloc
//------------------------------------
#pragma mark -
#pragma mark Init & dealloc methods

- (id) initRequestWithString:(NSString *)theURL delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders {
    return [self initRequestWithURL:[NSURL URLWithString:theURL] delegate:theDelegate headers:theHeaders];
}

- (id) initRequestWithString:(NSString *)theURL params:(NSString*)params delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders {
    return [self initRequestWithURL:[NSURL URLWithString:theURL] params:params delegate:theDelegate headers:theHeaders];
}

- (id) initRequestWithURL:(NSURL*)theURL delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders {
    if (self = [super init])
    {
        self.delegate = theDelegate;
        [KZApplication showLoadingScreen:nil];
        NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:theURL];
        
        NSArray *_keys = [theHeaders allKeys];
        
        for (NSString* _field in _keys)
        {
            NSString *_value = [theHeaders valueForKey:_field];
            
            [_request setValue:_value forHTTPHeaderField:_field];
        }
        connection = [[NSURLConnection connectionWithRequest:_request delegate:self] retain];

        if (connection == nil) 
        {
            // seems like an appropriate error message
            NSError *_error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
            [KZApplication hideLoading];
            [delegate KZURLRequest:self didFailWithError:_error];
        }
        
    }
    return self;
}


- (id) initRequestWithURL:(NSURL*)theURL params:(NSString*)params delegate:(id <KZURLRequestDelegate>)theDelegate headers:(NSDictionary*)theHeaders {
    if (self = [super init]) {
        self.delegate = theDelegate;
        [KZApplication showLoadingScreen:nil];
        NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:theURL];
        
        NSArray *_keys = [theHeaders allKeys];
        
        for (NSString* _field in _keys) {
            NSString *_value = [theHeaders valueForKey:_field];
            [_request setValue:_value forHTTPHeaderField:_field];
        }
		
		// POST
		[_request setHTTPMethod:@"POST"];
		[_request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

        connection = [[NSURLConnection connectionWithRequest:_request delegate:self] retain];
		
        if (connection == nil) {
            // seems like an appropriate error message
            NSError *_error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
            [KZApplication hideLoading];
            [delegate KZURLRequest:self didFailWithError:_error];
        }
        
    }
    return self;
}


- (void)dealloc {
    [receivedData release];
    [connection release];
    
    [super dealloc];
}

//------------------------------------
// Private methods
//------------------------------------
#pragma mark -
#pragma mark Private methods

- (void) initReceivedDataWithContentLength:(long long)theContentLength
{
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
	[KZApplication hideLoading];
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
        
        if (_statusCode == 200)
        {
            [self initReceivedDataWithContentLength:[theResponse expectedContentLength]];
        }
        else
        {
            NSString *_localizedMessage = [NSHTTPURLResponse localizedStringForStatusCode:_statusCode];
            
            // TODO, maybe expand on this for other reasonable errors that might crop up.
            NSInteger _errorCode = _statusCode == 404 ? NSURLErrorFileDoesNotExist : NSURLErrorUnknown;
            
            NSDictionary *_userInfo = [NSDictionary dictionaryWithObject:_localizedMessage forKey:NSLocalizedDescriptionKey];
            NSError *_error = [NSError errorWithDomain:NSURLErrorDomain code:_errorCode userInfo:_userInfo];
            
            [delegate KZURLRequest:self didFailWithError:_error];
            
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
    [delegate KZURLRequest:self didFailWithError:theError];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    [delegate KZURLRequest:self didSucceedWithData:receivedData];
	[KZApplication hideLoading];
}


@end
