//
//  BusinessDetails.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/25/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "BusinessDetails.h"

#import "KZUserInfo.h"
#import "KZApplication.h"

@implementation BusinessDetails
@synthesize placeView;

- (id)initWithPlaceView:(PlaceView*)place {
	if (self = [self init]) {
        self.placeView          =   place;
        NSString *_authToken    =   [KZUserInfo shared].auth_token;
        NSString *_urlString    =   [NSString stringWithFormat:@"%@/users/businesses/balance.xml?auth_token=%@&id=%d", API_URL, _authToken, place.businessID];
//        NSString *_urlString = [NSString stringWithFormat:@"%@/users/businesses/savings.xml?auth_token=%@&id=%d", API_URL, _authToken, place.businessID];
        NSLog(@"Res %@",_urlString);
        
        NSMutableDictionary *_headers = [[[NSMutableDictionary alloc] init] autorelease];
        [_headers setValue:@"application/xml" forKey:@"Accept"];
        
        [[KZURLRequest alloc] initRequestWithString:_urlString andParams:nil delegate:self headers:_headers andLoadingMessage:nil];
		
	}
	return self;
}

-(void)KZURLRequest:(KZURLRequest *)theRequest didFailWithError:(NSError *)theError{
    
}

-(void)KZURLRequest:(KZURLRequest *)theRequest didSucceedWithData:(NSData *)theData{
    
    NSString *balance   =   [[NSString alloc]initWithData:theData encoding:NSASCIIStringEncoding];
    NSLog(@"Bal name%@   id : %d %@",self.placeView.name,self.placeView.businessID, balance);
    [balance release];
    
    TBXML *tbxmlParser      =   [[TBXML alloc]initWithXMLData:theData];
    TBXMLElement *root      =   tbxmlParser.rootXMLElement;
    
    if (root) {
        TBXMLElement *bal   =   [TBXML childElementNamed:@"balance" parentElement:root];
        if (bal) {
            self.placeView.totalBalance =   [NSString stringWithFormat:@"%f",bal];
        }
    }
    
    [tbxmlParser release];
    
    
}

-(void)dealloc{
    [placeView release];
    [super dealloc];
}

@end
