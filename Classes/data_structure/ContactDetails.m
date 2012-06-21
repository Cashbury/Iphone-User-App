//
//  ContactDetails.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/15/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "ContactDetails.h"

@implementation ContactDetails

@synthesize name,mobile,email,url,address,type,date,time,qrcode;

-(void)dealloc{
    
    [super dealloc];
    [name release];
    [mobile release];
    [email release];
    [url release];
    [address release];
    [date release];
    [time release];
    [qrcode release];
    
}
@end
