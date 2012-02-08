//
//  CBAsyncImageView.h
//  Cashbury
//
//  Created by Rami on 18/8/11.
//  Copyright 2010 Cashbury All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZURLRequest.h"

@interface CBAsyncImageView : UIImageView <KZURLRequestDelegate> 
{
    NSURL *url;
}

@property (nonatomic, retain) KZURLRequest *urlRequest;
@property (nonatomic, assign) BOOL cropNorth;

- (void) loadImageWithAsyncUrl:(NSURL*)theURL;

@end
