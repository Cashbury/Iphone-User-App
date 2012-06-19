//
//  PlaceView.m
//  Cashbury
//
//  Created by Mrithula Ancy on 6/7/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import "PlaceView.h"

@implementation PlaceView
@synthesize name,icon,discount,shopImage,address;

-(void)dealloc{
    [super dealloc];
    [name release];
    [icon release];
    [discount release];
    [shopImage release];
    [address release];
    
}
@end
