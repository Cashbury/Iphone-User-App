//
//  FileSaver.h
//  Cashbery
//
//  Created by Basayel Said on 7/12/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileSaver : NSObject {

}

+ (void) saveFile: (NSString*)_file_name andData:(NSData*)_file_data;

+ (NSString*) getFilePathForFilename: (NSString*)_file_name;

@end
