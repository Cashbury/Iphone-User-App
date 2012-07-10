//
//  ContactDetails.h
//  Cashbury
//
//  Created by Mrithula Ancy on 6/15/12.
//  Copyright (c) 2012 Cashbury. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ContactDetails : NSManagedObject

@property (retain, nonatomic) NSNumber *type;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *mobile;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *time;
@property (retain, nonatomic) NSString *qrcode;
@end
