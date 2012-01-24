//
//  CBSavings.m
//  Cashbury
//
//  Created by Rami on 24/1/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "CBSavings.h"
#import "KZUserInfo.h"
#import "KZApplication.h"
#import "CXMLElement+Helpers.h"

static CBSavings *sharedInstance;

// Notifications
NSString * const CBTotalSavingsUpdateNotification     = @"CBTotalSavingsUpdateNotification";

// Request identifier constants
#define TOTAL_SAVINGS_REQUEST_IDENTIFIER    456

@implementation CBSavings

//----------------------------------------
// Singleton method
//----------------------------------------
#pragma mark - Singleton method

+ (CBSavings *) sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[CBSavings alloc] init];
        }
    }
    return sharedInstance;
}

//----------------------------------------
// Init & dealloc
//----------------------------------------
#pragma mark - Init & dealloc

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        totalSavings = [[NSNumber numberWithFloat:0.0] retain];
    }
    
    return self;
}

- (void) dealloc
{    
    [totalSavings release];
    
    [super dealloc];
}

//----------------------------------------
// Public methods
//----------------------------------------
#pragma mark - Public methods

- (NSNumber *) totalSavings
{
    NSString *_authToken = [KZUserInfo shared].auth_token;
    NSString *_urlString = [NSString stringWithFormat:@"%@/users/businesses/savings.xml?auth_token=%@", API_URL, _authToken];
    
    NSMutableDictionary *_headers = [[[NSMutableDictionary alloc] init] autorelease];
	[_headers setValue:@"application/xml" forKey:@"Accept"];
    
    KZURLRequest *_request = [[KZURLRequest alloc] initRequestWithString:_urlString
                                                               andParams:nil
                                                                delegate:self
                                                                 headers:_headers
                                                       andLoadingMessage:nil];
    
    _request.identifier = TOTAL_SAVINGS_REQUEST_IDENTIFIER;
    
    return totalSavings;
}

//----------------------------------------
// KZURLRequestDelegate methods
//----------------------------------------
#pragma mark - KZURLRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData
{
    CXMLDocument *_document = [[[CXMLDocument alloc] initWithData:theData options:0 error:nil] autorelease];
    
    NSString *_totalSavings = [[[_document rootElement] nodeForXPath:@"/hash/total-savings" error:nil] stringValue];
    
    [totalSavings release];
    totalSavings = [[NSNumber numberWithFloat:[_totalSavings floatValue]] retain];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CBTotalSavingsUpdateNotification object:totalSavings userInfo:nil];
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError
{
    
}

@end
