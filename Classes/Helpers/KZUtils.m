//
//  KZUtils.m
//  Cashbury
//
//  Created by Basayel Said on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "KZUtils.h"

@implementation KZUtils



+ (NSString *) md5ForString:(NSString *)str

{
	
	const char *cStr = [str UTF8String];
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString 
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0],  result[1],  result[2],  result[3],
			result[4],  result[5],  result[6],  result[7],
			result[8],  result[9],  result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
	
}



+ (NSString*) urlEncodeForString:(NSString *)str {
	return (NSString *)
	CFURLCreateStringByAddingPercentEscapes(NULL,
											(CFStringRef) str,
											NULL,
											(CFStringRef) @"!*'();:@&=+$,/?%#[]",
											kCFStringEncodingUTF8);
}


+ (BOOL) isEmailValid:(NSString*)email_address {
	NSString *_filter = @"^[a-zA-Z0-9_\\.\\-]+@[a-zA-Z0-9_\\-]+\\.[a-zA-Z0-9_\\.\\-]+$";
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _filter];
    if ([_predicate evaluateWithObject:email_address] == YES) {
		return YES;
	} else {
		return NO;
	}
}


+ (BOOL) isPasswordValid:(NSString*)password {
	NSString *_filter = @"^[\\d\\D]{6,}$";
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _filter];
    if ([_predicate evaluateWithObject:password] == YES) {
		return YES;
	} else {
		return NO;
	}
}

+ (BOOL) isStringValid:(NSString*)str {
	if (str == nil) return NO;
	if ([str isEqual:@""]) return NO;
	return YES;
}


+ (NSString*) plural:(NSUInteger) val {
	if (val > 1) return @"s";
	return @"";
}

@end
