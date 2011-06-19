//
//  DummySplashViewController.h
//  Cashbery
//
//  Created by Basayel Said on 6/13/11.
//  Copyright 2011 Cashbury. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DummySplashViewController : UIViewController {
	
}

@property (nonatomic, retain) IBOutlet UILabel *lbl_loadong;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity_indicator;

- (void) setLoadingMessage:(NSString*)str_message;

- (id) initWithMessage:(NSString*)_message;
@end
