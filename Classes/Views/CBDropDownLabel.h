//
//  CBDropDownLabel.h
//  Cashbury
//
//  Created by Rami on 25/5/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CBDropDownLabel : UILabel
{
    @private
    UIImageView *indicator;
}

@property (nonatomic, retain) UIImage *indicatorImage;

@end
