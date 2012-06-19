//
//  ContactDetails.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/15/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactDetails : NSObject

@property () NSInteger type;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *mobile;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *time;
@end
