//
//  FileSaver.m
//  Cashbery
//
//  Created by Basayel Said on 7/12/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import "FileSaver.h"


@implementation FileSaver



+ (void) saveFile: (NSString*)_file_name andData:(NSData*)_file_data
{
    // Generate a unique path to a resource representing the image you want
    NSString *uniquePath = [NSTemporaryDirectory() stringByAppendingPathComponent: _file_name];
	
	[[NSFileManager defaultManager] createFileAtPath:uniquePath
											contents:_file_data
										  attributes:nil];
}


+ (NSString*) getFilePathForFilename: (NSString*)_file_name
{
    NSString *uniquePath = [NSTemporaryDirectory() stringByAppendingPathComponent: _file_name];
	// Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
    {
        return uniquePath;
    } else {
		return nil;
	}
}

@end
