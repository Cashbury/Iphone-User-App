//
//  KZUtils.h
//  Cashbury
//
//  Created by Basayel Said on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KZUtils : NSObject {

}

+ (NSString *)urlEncodeForString:(NSString *)original;

+ (NSString *)md5ForString:(NSString *)str;

+ (BOOL) isEmailValid:(NSString*)email_address;

+ (BOOL) isPasswordValid:(NSString*)password;

+ (BOOL) isStringValid:(NSString*)password;

+ (NSString*) plural:(NSUInteger) val;

@end
