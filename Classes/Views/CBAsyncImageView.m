//
//  CBAsyncImageView.m
//  Cashbury
//
//  Created by Rami on 18/8/11.
//  Copyright 2010 Cashbury All rights reserved.
//

#import "CBAsyncImageView.h"

static const NSInteger ACTIVITY_TAG = 9;

@implementation CBAsyncImageView

@synthesize urlRequest;

//------------------------------------------
// UIView methods
//------------------------------------------
#pragma mark - Init & dealloc

- (void)dealloc
{
    [urlRequest release];
    [url release];
    
    [super dealloc];
}

//------------------------------------------
// Public methods
//------------------------------------------
#pragma mark -
#pragma mark Public methods

/*
 * Different images have different aspect ratios.  The UIImageView is positioned with a correct baseline
 * and centered properly.  So resize the image and move back into place.
 */

- (void) loadImageWithAsyncUrl:(NSURL*)theURL
{
    // Bit of a hack, this could potentially fail if setImage is called inbetween calls to loadImageWithAsyncUrl
    // Only leaving this here as a stop gap solution until the url loading is removed from here, NAAsyncUIView does
    // this check as well.
    
    if([url isEqual:theURL])
    {
        return;
    }
    
    if (self.urlRequest == nil)
    {
        self.image = nil;
        
        UIActivityIndicatorView *_spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _spinny.tag = ACTIVITY_TAG;
        _spinny.center = self.center;
        
        [_spinny startAnimating];
        [self addSubview:_spinny];
        [_spinny release];
    }
    else
    {
        [urlRequest cancel];
    }

    url = [theURL copy];
    
    KZURLRequest *_r = [[KZURLRequest alloc] initRequestWithString:[url absoluteString]
                                                         andParams:nil
                                                          delegate:self
                                                           headers:nil
                                                 andLoadingMessage:@""];

    self.urlRequest = _r;
    
    [_r release];
}

//------------------------------------------
// NAUrlRequestDelegate methods
//------------------------------------------
#pragma mark -
#pragma mark NAUrlRequestDelegate methods

- (void) KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData
{
    UIImage *_image = [UIImage imageWithData:theData];
    
    [[self viewWithTag:ACTIVITY_TAG] removeFromSuperview];
    
    self.image = _image;
    
    self.urlRequest = nil;
}

- (void) KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError
{
    [[self viewWithTag:ACTIVITY_TAG] removeFromSuperview];
    
    self.urlRequest = nil;
    
    NSLog(@"Request: %@", theRequest);
    NSLog(@"Error: %@", theError);
    
    // TODO, do something?
}

@end
